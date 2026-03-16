# 🔧 MCP Sales Analytics Server

A **Model Context Protocol (MCP)** server that enables Large Language Models (LLMs) to
directly query and analyze a PostgreSQL sales database through natural language conversations.

Built with Python, the official MCP SDK, psycopg3, and Docker.

![Python](https://img.shields.io/badge/Python-3.12+-blue?logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql&logoColor=white)
![MCP](https://img.shields.io/badge/MCP-1.2+-green)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)

---

## 🧩 The Challenge

Business teams rely on sales data to make strategic decisions — identifying top customers,
tracking revenue trends, monitoring sales rep performance, and spotting growth opportunities.
However, accessing this data typically requires:

- **SQL expertise** — writing complex queries with joins, aggregations, and filters
- **Database access** — navigating credentials, connections, and security policies
- **Context switching** — moving between BI tools, spreadsheets, and communication platforms
- **Rigid dashboards** — pre-built reports that can't answer ad-hoc questions

This creates a bottleneck where business stakeholders depend on data analysts or engineers
for every new question, slowing down decision-making.

---

## 💡 The Solution

This project implements a **Model Context Protocol (MCP) server** that acts as a bridge
between an LLM (like Claude) and a PostgreSQL sales database. It allows users to ask
questions about sales data in **plain English** and get accurate, real-time answers.

---

### How It Works

1. **User** asks a question in Claude Desktop (e.g., *"Show me Q1 revenue by region"*)
2. **Claude** interprets the question and selects the appropriate MCP tool
3. **MCP Server** receives the tool call, executes a parameterized SQL query
4. **PostgreSQL** returns the results
5. **MCP Server** formats the data and sends it back to Claude
6. **Claude** presents the results in a clear, conversational format

---

## ✨ Features

- 🗣️ **Natural Language Queries** — Ask questions in plain English
- 🔧 **12 Pre-built Tools** — Revenue analysis, customer insights, rep performance, and more
- 🛡️ **Read-Only Safety** — Database connection enforces SELECT-only queries
- 🔒 **SQL Injection Prevention** — All queries use parameterized placeholders
- ⏱️ **Query Timeout** — 30-second limit prevents runaway queries
- 🏊 **Connection Pooling** — Efficient database connection management
- 🐳 **Docker Compose** — One-command setup for the entire stack
- 📊 **Realistic Sample Data** — 30 customers, 51 orders, 12 reps, 22 products
- 🧠 **Schema-as-Resource** — LLM has access to full database documentation

---

## 📋 Prerequisites

- **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** (v4.0+)
- **[Claude Desktop](https://claude.ai/download)** (v0.7+)

---

## 🚀 Installation

### Docker (Recommended)

The fastest way to get everything running. Docker handles PostgreSQL, data seeding,
and the MCP server automatically.

#### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/mcp-sales-server.git
cd mcp-sales-server
docker compose --env-file .env.docker up --build -d


---

<div align="center">
  <img src="./backend/docs/gameplay.png" alt="LLM Chess Gameplay Demo" width="600" />
</div>
<div align="center">
  <img src="./backend/docs/checkmate.png" alt="LLM Chess Gameplay Demo" width="600" />
</div>

---
