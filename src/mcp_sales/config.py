"""
Configuration management — loads settings from environment variables.
"""

import os
from dataclasses import dataclass
from dotenv import load_dotenv

load_dotenv()


@dataclass(frozen=True)
class DatabaseConfig:
    """PostgreSQL connection configuration."""
    host: str
    port: int
    name: str
    user: str
    password: str
    schema: str

    @property
    def dsn(self) -> str:
        """Return a PostgreSQL connection string."""
        return (
            f"host={self.host} "
            f"port={self.port} "
            f"dbname={self.name} "
            f"user={self.user} "
            f"password={self.password}"
        )

    @property
    def connection_params(self) -> dict:
        """Return connection parameters as a dictionary."""
        return {
            "host": self.host,
            "port": self.port,
            "dbname": self.name,
            "user": self.user,
            "password": self.password,
        }


@dataclass(frozen=True)
class ServerConfig:
    """MCP server configuration."""
    name: str
    log_level: str


def load_db_config() -> DatabaseConfig:
    """Load database configuration from environment."""
    return DatabaseConfig(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "5432")),
        name=os.getenv("DB_NAME", "sales_db"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", ""),
        schema=os.getenv("DB_SCHEMA", "sales"),
    )


def load_server_config() -> ServerConfig:
    """Load server configuration from environment."""
    return ServerConfig(
        name=os.getenv("MCP_SERVER_NAME", "sales-analytics"),
        log_level=os.getenv("LOG_LEVEL", "INFO"),
    )