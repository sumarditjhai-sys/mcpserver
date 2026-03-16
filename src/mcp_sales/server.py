"""
MCP Server — main entry point.

Registers all tools and resources, then starts the server.
"""

import logging
import json
from datetime import date, datetime
from decimal import Decimal

from mcp.server.fastmcp import FastMCP

from mcp_sales.config import load_server_config, load_db_config
from mcp_sales.db import get_db, shutdown_db

# ============================================
# Setup
# ============================================
server_config = load_server_config()

logging.basicConfig(
    level=getattr(logging, server_config.log_level),
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)

# Create the MCP server
mcp = FastMCP(
    name=server_config.name,
    instructions=(
        "Sales analytics MCP server — query sales data, "
        "track rep performance, and analyze revenue trends. "
        "Use the available tools to explore regions, products, "
        "customers, orders, and sales rep performance. "
        "Start with list_tables or health_check to orient yourself."
    ),
)


# ============================================
# Custom JSON serializer for query results
# ============================================
def serialize_row(obj):
    """Convert non-serializable types to strings."""
    if isinstance(obj, Decimal):
        return float(obj)
    if isinstance(obj, (date, datetime)):
        return obj.isoformat()
    return str(obj)


def format_results(rows: list[dict], title: str = "Results") -> str:
    """Format query results as a readable string for the LLM."""
    if not rows:
        return f"## {title}\n\nNo results found."

    output = f"## {title}\n\n"
    output += f"**{len(rows)} row(s) returned**\n\n"

    # Build markdown table
    headers = list(rows[0].keys())
    output += "| " + " | ".join(headers) + " |\n"
    output += "| " + " | ".join(["---"] * len(headers)) + " |\n"

    for row in rows:
        values = [str(serialize_row(v)) if v is not None else "NULL" for v in row.values()]
        output += "| " + " | ".join(values) + " |\n"

    return output


# ============================================
# TOOLS — Health & Schema
# ============================================
@mcp.tool()
def health_check() -> str:
    """
    Check the database connection health.
    Returns the current status and server time.
    """
    db = get_db()
    result = db.health_check()
    return json.dumps(result, indent=2, default=serialize_row)


@mcp.tool()
def list_tables() -> str:
    """
    List all tables in the sales database with their column counts.
    Use this to understand the database structure before querying.
    """
    db = get_db()
    tables = db.get_table_info()
    return format_results(tables, "Database Tables")


@mcp.tool()
def describe_table(table_name: str) -> str:
    """
    Get detailed column information for a specific table.

    Args:
        table_name: Name of the table (e.g., 'orders', 'customers', 'products')
    """
    # Whitelist valid tables to prevent injection
    valid_tables = {
        "regions", "product_categories", "products",
        "sales_reps", "customers", "orders",
        "order_items", "sales_targets",
    }

    if table_name not in valid_tables:
        return f"Invalid table name '{table_name}'. Valid tables: {', '.join(sorted(valid_tables))}"

    db = get_db()
    columns = db.get_column_info(table_name)
    return format_results(columns, f"Table: {table_name}")


# ============================================
# TOOLS — Sales Queries
# ============================================
@mcp.tool()
def revenue_by_region(
    start_date: str = "2023-01-01",
    end_date: str = "2024-12-31",
) -> str:
    """
    Get total revenue broken down by region.

    Args:
        start_date: Start date in YYYY-MM-DD format
        end_date: End date in YYYY-MM-DD format
    """
    db = get_db()
    rows = db.execute_query(
        """
        SELECT 
            r.name AS region,
            r.country,
            COUNT(o.order_id) AS total_orders,
            SUM(o.total_amount)::NUMERIC(12,2) AS total_revenue,
            AVG(o.total_amount)::NUMERIC(12,2) AS avg_order_value
        FROM orders o
        JOIN sales_reps sr ON o.rep_id = sr.rep_id
        JOIN regions r ON sr.region_id = r.region_id
        WHERE o.order_date BETWEEN %s AND %s
          AND o.status != 'Cancelled'
        GROUP BY r.name, r.country
        ORDER BY total_revenue DESC;
        """,
        (start_date, end_date),
    )
    return format_results(rows, f"Revenue by Region ({start_date} to {end_date})")


@mcp.tool()
def revenue_by_month(
    year: int = 2024,
) -> str:
    """
    Get monthly revenue breakdown for a given year.

    Args:
        year: The year to analyze (e.g., 2023 or 2024)
    """
    db = get_db()
    rows = db.execute_query(
        """
        SELECT 
            TO_CHAR(o.order_date, 'YYYY-MM') AS month,
            COUNT(o.order_id) AS orders,
            SUM(o.total_amount)::NUMERIC(12,2) AS revenue,
            AVG(o.total_amount)::NUMERIC(12,2) AS avg_order_value
        FROM orders o
        WHERE EXTRACT(YEAR FROM o.order_date) = %s
          AND o.status != 'Cancelled'
        GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
        ORDER BY month;
        """,
        (year,),
    )
    return format_results(rows, f"Monthly Revenue — {year}")


@mcp.tool()
def top_products(
    limit: int = 10,
    start_date: str = "2023-01-01",
    end_date: str = "2024-12-31",
) -> str:
    """
    Get top-selling products by total revenue.

    Args:
        limit: Number of products to return (default 10)
        start_date: Start date in YYYY-MM-DD format
        end_date: End date in YYYY-MM-DD format
    """
    limit = min(max(limit, 1), 50)  # Clamp between 1 and 50

    db = get_db()
    rows = db.execute_query(
        """
        SELECT 
            p.name AS product,
            pc.name AS category,
            SUM(oi.quantity) AS total_units_sold,
            SUM(oi.line_total)::NUMERIC(12,2) AS total_revenue,
            COUNT(DISTINCT o.order_id) AS order_count
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
        JOIN product_categories pc ON p.category_id = pc.category_id
        JOIN orders o ON oi.order_id = o.order_id
        WHERE o.order_date BETWEEN %s AND %s
          AND o.status != 'Cancelled'
        GROUP BY p.name, pc.name
        ORDER BY total_revenue DESC
        LIMIT %s;
        """,
        (start_date, end_date, limit),
    )
    return format_results(rows, f"Top {limit} Products by Revenue")


@mcp.tool()
def revenue_by_category(
    start_date: str = "2023-01-01",
    end_date: str = "2024-12-31",
) -> str:
    """
    Get revenue breakdown by product category.

    Args:
        start_date: Start date in YYYY-MM-DD format
        end_date: End date in YYYY-MM-DD format
    """
    db = get_db()
    rows = db.execute_query(
        """
        SELECT 
            pc.name AS category,
            COUNT(DISTINCT o.order_id) AS orders,
            SUM(oi.quantity) AS units_sold,
            SUM(oi.line_total)::NUMERIC(12,2) AS total_revenue,
            AVG(oi.discount)::NUMERIC(5,2) AS avg_discount_pct
        FROM order_items oi
        JOIN products p ON oi.product_id = p.product_id
        JOIN product_categories pc ON p.category_id = pc.category_id
        JOIN orders o ON oi.order_id = o.order_id
        WHERE o.order_date BETWEEN %s AND %s
          AND o.status != 'Cancelled'
        GROUP BY pc.name
        ORDER BY total_revenue DESC;
        """,
        (start_date, end_date),
    )
    return format_results(rows, f"Revenue by Category ({start_date} to {end_date})")


# ============================================
# TOOLS — Customer Queries
# ============================================
@mcp.tool()
def top_customers(
    limit: int = 10,
    segment: str | None = None,
) -> str:
    """
    Get top customers by total spend.

    Args:
        limit: Number of customers to return (default 10)
        segment: Filter by segment — 'Enterprise', 'Mid-Market', 'Small Business', or 'Startup'. Leave empty for all.
    """
    limit = min(max(limit, 1), 50)

    db = get_db()

    if segment:
        rows = db.execute_query(
            """
            SELECT 
                c.company_name,
                c.segment::text,
                r.name AS region,
                COUNT(o.order_id) AS total_orders,
                SUM(o.total_amount)::NUMERIC(12,2) AS total_spent,
                MIN(o.order_date) AS first_order,
                MAX(o.order_date) AS last_order
            FROM customers c
            JOIN orders o ON c.customer_id = o.customer_id
            JOIN regions r ON c.region_id = r.region_id
            WHERE o.status != 'Cancelled'
              AND c.segment = %s::customer_segment
            GROUP BY c.company_name, c.segment, r.name
            ORDER BY total_spent DESC
            LIMIT %s;
            """,
            (segment, limit),
        )
    else:
        rows = db.execute_query(
            """
            SELECT 
                c.company_name,
                c.segment::text,
                r.name AS region,
                COUNT(o.order_id) AS total_orders,
                SUM(o.total_amount)::NUMERIC(12,2) AS total_spent,
                MIN(o.order_date) AS first_order,
                MAX(o.order_date) AS last_order
            FROM customers c
            JOIN orders o ON c.customer_id = o.customer_id
            JOIN regions r ON c.region_id = r.region_id
            WHERE o.status != 'Cancelled'
            GROUP BY c.company_name, c.segment, r.name
            ORDER BY total_spent DESC
            LIMIT %s;
            """,
            (limit,),
        )

    title = f"Top {limit} Customers" + (f" ({segment})" if segment else "")
    return format_results(rows, title)


@mcp.tool()
def customer_details(company_name: str) -> str:
    """
    Get detailed information and order history for a specific customer.

    Args:
        company_name: Company name (partial match supported, e.g., 'Apex' or 'Golden Gate')
    """
    db = get_db()

    # Customer info
    customer = db.execute_query(
        """
        SELECT 
            c.company_name, c.segment::text, c.contact_name,
            c.email, r.name AS region
        FROM customers c
        JOIN regions r ON c.region_id = r.region_id
        WHERE c.company_name ILIKE %s
        LIMIT 5;
        """,
        (f"%{company_name}%",),
    )

    if not customer:
        return f"No customer found matching '{company_name}'"

    # Order history for first match
    orders = db.execute_query(
        """
        SELECT 
            o.order_id, o.order_date, o.status::text,
            o.total_amount::NUMERIC(12,2),
            sr.first_name || ' ' || sr.last_name AS sales_rep
        FROM orders o
        JOIN customers c ON o.customer_id = c.customer_id
        JOIN sales_reps sr ON o.rep_id = sr.rep_id
        WHERE c.company_name ILIKE %s
        ORDER BY o.order_date DESC;
        """,
        (f"%{company_name}%",),
    )

    output = format_results(customer, "Customer Info")
    output += "\n\n" + format_results(orders, "Order History")
    return output


# ============================================
# TOOLS — Sales Rep Performance
# ============================================
@mcp.tool()
def rep_performance(
    year: int = 2024,
    quarter: int | None = None,
) -> str:
    """
    Get sales rep performance with quota attainment.

    Args:
        year: Year to analyze
        quarter: Quarter (1-4), or leave empty for full year
    """
    db = get_db()

    if quarter:
        rows = db.execute_query(
            """
            SELECT 
                sr.first_name || ' ' || sr.last_name AS rep_name,
                r.name AS region,
                st.quota_amount::NUMERIC(12,2) AS quota,
                COALESCE(SUM(o.total_amount), 0)::NUMERIC(12,2) AS actual_sales,
                ROUND(
                    COALESCE(SUM(o.total_amount), 0) / st.quota_amount * 100, 1
                ) AS attainment_pct,
                COUNT(o.order_id) AS deals_closed
            FROM sales_reps sr
            JOIN regions r ON sr.region_id = r.region_id
            JOIN sales_targets st ON sr.rep_id = st.rep_id
                AND st.year = %s AND st.quarter = %s
            LEFT JOIN orders o ON sr.rep_id = o.rep_id
                AND EXTRACT(YEAR FROM o.order_date) = %s
                AND EXTRACT(QUARTER FROM o.order_date) = %s
                AND o.status NOT IN ('Cancelled', 'Refunded')
            GROUP BY sr.first_name, sr.last_name, r.name, st.quota_amount
            ORDER BY attainment_pct DESC;
            """,
            (year, quarter, year, quarter),
        )
        title = f"Rep Performance — {year} Q{quarter}"
    else:
        rows = db.execute_query(
            """
            SELECT 
                sr.first_name || ' ' || sr.last_name AS rep_name,
                r.name AS region,
                SUM(st.quota_amount)::NUMERIC(12,2) AS annual_quota,
                COALESCE(SUM(DISTINCT o.total_amount), 0)::NUMERIC(12,2) AS actual_sales,
                COUNT(DISTINCT o.order_id) AS deals_closed
            FROM sales_reps sr
            JOIN regions r ON sr.region_id = r.region_id
            JOIN sales_targets st ON sr.rep_id = st.rep_id
                AND st.year = %s
            LEFT JOIN orders o ON sr.rep_id = o.rep_id
                AND EXTRACT(YEAR FROM o.order_date) = %s
                AND o.status NOT IN ('Cancelled', 'Refunded')
            GROUP BY sr.first_name, sr.last_name, r.name
            ORDER BY actual_sales DESC;
            """,
            (year, year),
        )
        title = f"Rep Performance — {year} Full Year"

    return format_results(rows, title)


@mcp.tool()
def order_status_summary() -> str:
    """
    Get a summary of orders grouped by their current status.
    Useful for checking pipeline health.
    """
    db = get_db()
    rows = db.execute_query(
        """
        SELECT 
            status::text AS order_status,
            COUNT(*) AS order_count,
            SUM(total_amount)::NUMERIC(12,2) AS total_value,
            AVG(total_amount)::NUMERIC(12,2) AS avg_value
        FROM orders
        GROUP BY status
        ORDER BY order_count DESC;
        """
    )
    return format_results(rows, "Order Status Summary")


# ============================================
# TOOLS — Flexible Query (Advanced)
# ============================================
@mcp.tool()
def run_sales_query(sql_query: str) -> str:
    """
    Execute a custom READ-ONLY SQL query against the sales database.
    
    The database runs in read-only mode — only SELECT statements are allowed.
    The search_path is set to the 'sales' schema.

    Available tables: regions, product_categories, products, sales_reps,
                      customers, orders, order_items, sales_targets

    Args:
        sql_query: A SELECT SQL query to execute
    """
    # Basic safety check
    cleaned = sql_query.strip().upper()
    if not cleaned.startswith("SELECT"):
        return "Only SELECT queries are allowed."

    dangerous_keywords = ["INSERT", "UPDATE", "DELETE", "DROP", "ALTER", "TRUNCATE", "CREATE", "GRANT", "EXECUTE"]
    for keyword in dangerous_keywords:
        if keyword in cleaned.split():
            return f"Query contains forbidden keyword: {keyword}"

    try:
        db = get_db()
        rows = db.execute_query(sql_query)
        return format_results(rows, "Custom Query Results")
    except Exception as e:
        return f"Query error: {str(e)}"


# ============================================
# RESOURCES — Database Schema
# ============================================
@mcp.resource("schema://sales/overview")
def get_schema_overview() -> str:
    """
    Complete overview of the sales database schema.
    Includes all tables, columns, types, and relationships.
    """
    return """
# Sales Database Schema

## Tables

### regions
- region_id (PK), name, country

### product_categories  
- category_id (PK), name, description

### products
- product_id (PK), category_id (FK→product_categories), name, sku, price, is_active

### sales_reps
- rep_id (PK), region_id (FK→regions), first_name, last_name, email, phone, hire_date, is_active

### customers
- customer_id (PK), company_name, segment (ENUM: Enterprise/Mid-Market/Small Business/Startup), region_id (FK→regions), contact_name, email, phone, address

### orders
- order_id (PK), customer_id (FK→customers), rep_id (FK→sales_reps), order_date, status (ENUM: Pending/Confirmed/Shipped/Delivered/Cancelled/Refunded), total_amount, notes

### order_items
- item_id (PK), order_id (FK→orders), product_id (FK→products), quantity, unit_price, discount, line_total (GENERATED)

### sales_targets
- target_id (PK), rep_id (FK→sales_reps), quarter, year, quota_amount
- UNIQUE(rep_id, quarter, year)

## Key Relationships
- orders → customers (many-to-one)
- orders → sales_reps (many-to-one)  
- order_items → orders (many-to-one, CASCADE delete)
- order_items → products (many-to-one)
- customers → regions (many-to-one)
- sales_reps → regions (many-to-one)
- products → product_categories (many-to-one)
- sales_targets → sales_reps (many-to-one)
"""


# ============================================
# Server lifecycle
# ============================================
def main():
    """Run the MCP server."""
    logger.info("Starting %s MCP server...", server_config.name)

    # Initialize DB on startup
    try:
        db = get_db()
        health = db.health_check()
        logger.info("Database health: %s", health["status"])
    except Exception as e:
        logger.error("Failed to connect to database: %s", e)
        raise

    # Run the server (stdio transport by default)
    mcp.run()


if __name__ == "__main__":
    main()