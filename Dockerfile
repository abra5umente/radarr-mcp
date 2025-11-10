FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY pyproject.toml .
RUN pip install -e .

# Copy application files
COPY radarr-mcp-server.py .
COPY entrypoint.sh .

# Make entrypoint executable
RUN chmod +x entrypoint.sh

# Create non-root user
RUN useradd -m -u 1000 mcp && chown -R mcp:mcp /app
USER mcp

EXPOSE 4200

ENTRYPOINT ["./entrypoint.sh"] 