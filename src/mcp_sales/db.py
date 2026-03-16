"""
Database connection management with connection pooling
and read-only query execution.

Uses psycopg 3 (modern PostgreSQL adapter).
"""

import logging
from contextlib import contextmanager
from typing import Any

import psycopg
from psycopg.rows import dict_row
from psycopg_pool import ConnectionPool

from mcp_sales.config import DatabaseConfig, load_db_config

logger = logging.getLogger(__name__)


class DatabaseManager:
    """
    Manages PostgreSQL connections with pooling and safe query execution.

    Key safety features:
    - Connection pooling (min 1, max 10 connections)
    - Read-only transaction mode by default
    - Query timeout to prevent long-running queries
    - Parameterized queries only
    """

    def __init__(self, config: DatabaseConfig | None = None):
        self.config = config or load_db_config()
        self._pool: ConnectionPool | None = None

    def initialize(self) -> None:
        """Create the connection pool."""
        try:
            conninfo = (
                f"host={self.config.host} "
                f"port={self.config.port} "
                f"dbname={self.config.name} "
                f"user={self.config.user} "
                f"password={self.config.password}"
            )
            self._pool = ConnectionPool(
                conninfo=conninfo,
                min_size=1,
                max_size=10,
                open=True,
            )
            logger.info(
                "Database connection pool created: %s@%s:%s/%s",
                self.config.user,
                self.config.host,
                self.config.port,
                self.config.name,
            )
        except psycopg.Error as e:
            logger.error("Failed to create connection pool: %s", e)
            raise

    def close(self) -> None:
        """Close all connections in the pool."""
        if self._pool:
            self._pool.close()
            logger.info("Database connection pool closed.")

    @contextmanager
    def get_connection(self):
        """
        Get a connection from the pool.
        Sets read-only mode for safety.
        """
        if not self._pool:
            raise RuntimeError(
                "Database pool is not initialized. Call initialize() first."
            )

        with self._pool.connection() as conn:
            conn.read_only = True
            conn.autocommit = False
            try:
                yield conn
            finally:
                conn.rollback()

    def execute_query(
        self,
        query: str,
        params: tuple | dict | None = None,
        timeout_seconds: int = 30,
    ) -> list[dict[str, Any]]:
        """
        Execute a read-only SQL query and return results as list of dicts.

        Args:
            query: SQL query with %s or %(name)s placeholders
            params: Query parameters (tuple or dict)
            timeout_seconds: Query timeout in seconds

        Returns:
            List of dictionaries, one per row
        """
        with self.get_connection() as conn:
            with conn.cursor(row_factory=dict_row) as cur:
                # Set search path and statement timeout
                cur.execute(
                    f"SET search_path TO {self.config.schema}"
                )
                cur.execute(
                    f"SET statement_timeout = '{timeout_seconds * 1000}'"
                )

                logger.debug("Executing query: %s | params: %s", query, params)
                cur.execute(query, params)

                if cur.description is None:
                    return []

                rows = cur.fetchall()
                return [dict(row) for row in rows]

    def execute_query_single(
        self,
        query: str,
        params: tuple | dict | None = None,
    ) -> dict[str, Any] | None:
        """Execute a query and return a single row or None."""
        results = self.execute_query(query, params)
        return results[0] if results else None

    def get_table_info(self) -> list[dict[str, Any]]:
        """Get metadata about all tables in the sales schema."""
        query = """
            SELECT
                t.table_name,
                obj_description(
                    (quote_ident(t.table_schema) || '.' || 
                     quote_ident(t.table_name))::regclass
                ) AS table_comment,
                (
                    SELECT COUNT(*)::int
                    FROM information_schema.columns c
                    WHERE c.table_schema = t.table_schema
                      AND c.table_name = t.table_name
                ) AS column_count
            FROM information_schema.tables t
            WHERE t.table_schema = %s
              AND t.table_type = 'BASE TABLE'
            ORDER BY t.table_name;
        """
        return self.execute_query(query, (self.config.schema,))

    def get_column_info(self, table_name: str) -> list[dict[str, Any]]:
        """Get column metadata for a specific table."""
        query = """
            SELECT
                c.column_name,
                c.data_type,
                c.is_nullable,
                c.column_default,
                c.character_maximum_length,
                c.numeric_precision
            FROM information_schema.columns c
            WHERE c.table_schema = %s
              AND c.table_name = %s
            ORDER BY c.ordinal_position;
        """
        return self.execute_query(query, (self.config.schema, table_name))

    def health_check(self) -> dict[str, Any]:
        """Run a simple health check on the database."""
        try:
            result = self.execute_query_single(
                "SELECT 1 AS ok, NOW() AS server_time;"
            )
            return {
                "status": "healthy",
                "server_time": str(result["server_time"]) if result else None,
            }
        except Exception as e:
            return {
                "status": "unhealthy",
                "error": str(e),
            }


# ============================================
# Singleton instance for the application
# ============================================
_db_manager: DatabaseManager | None = None


def get_db() -> DatabaseManager:
    """Get or create the singleton DatabaseManager."""
    global _db_manager
    if _db_manager is None:
        _db_manager = DatabaseManager()
        _db_manager.initialize()
    return _db_manager


def shutdown_db() -> None:
    """Shut down the database connection pool."""
    global _db_manager
    if _db_manager:
        _db_manager.close()
        _db_manager = None