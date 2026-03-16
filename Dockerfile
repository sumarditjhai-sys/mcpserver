# ============================================
# MCP Sales Analytics Server
# Multi-stage build for smaller image
# ============================================

# --- Stage 1: Builder ---
FROM python:3.12-slim AS builder

WORKDIR /build

# Install build dependencies
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Copy project files
COPY pyproject.toml .
COPY src/ src/

# Build the wheel
RUN pip wheel --no-cache-dir --wheel-dir /wheels -e .
RUN pip wheel --no-cache-dir --wheel-dir /wheels \
    "mcp[cli]>=1.2.0" \
    "psycopg[binary]>=3.2.0" \
    "psycopg-pool>=3.2.0" \
    "python-dotenv>=1.0.0"


# --- Stage 2: Runtime ---
FROM python:3.12-slim AS runtime

# Labels for documentation
LABEL maintainer=""
LABEL description="MCP Server for Sales Analytics with PostgreSQL"
LABEL version="0.1.0"

# Create non-root user for security
RUN groupadd -r mcpuser && useradd -r -g mcpuser -d /app -s /sbin/nologin mcpuser

WORKDIR /app

# Install wheels from builder
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/*.whl && rm -rf /wheels

# Copy source code
COPY src/ src/

# Install the project itself
COPY pyproject.toml .
RUN pip install --no-cache-dir -e .

# Switch to non-root user
USER mcpuser

# Health check script
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD python -c "from mcp_sales.db import get_db; db = get_db(); print(db.health_check())" || exit 1

# Default command — stdio transport
CMD ["python", "-m", "mcp_sales.server"]