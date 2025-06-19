# Monitoring Stack

A comprehensive monitoring solution using Prometheus, Node Exporter, and Grafana, optimized for secure local deployment.

## Overview

This stack provides:
- **Prometheus**: Metrics collection and storage
- **Node Exporter**: System metrics collection
- **Grafana**: Metrics visualization and dashboarding

## Architecture

- All services run in Docker containers
- Uses local registry for image management (`localhost:5000`)
- All services are bound to `127.0.0.1` for security
- Inter-service communication via Docker network

## Prerequisites

- Docker
- Docker Compose
- Local Docker registry running on port 5000
- PowerShell (for Windows) or Bash (for Linux/MacOS)

## Directory Structure

```
monitoring/
├── docker-compose.yml     # Docker Compose configuration
├── prometheus.yml         # Prometheus configuration
├── update-images.ps1     # Windows script for updating images
├── update-images.sh      # Linux/MacOS script for updating images
└── .gitignore           # Git ignore patterns
```

## Quick Start

1. **Update Local Registry**
   ```powershell
   # Windows
   .\update-images.ps1

   # Linux/MacOS
   ./update-images.sh
   ```

2. **Start the Stack**
   ```powershell
   docker-compose up -d
   ```

3. **Access Services**
   - Grafana: http://127.0.0.1:3000 (default credentials: admin/admin)
   - Prometheus: http://127.0.0.1:9090
   - Node Exporter metrics: http://127.0.0.1:9100/metrics

## Configuration Details

### Docker Compose Configuration

The `docker-compose.yml` file defines three services:

- **Grafana**
  - Port: 3000
  - Persistent storage for dashboards and settings
  - Environment variables for initial setup

- **Prometheus**
  - Port: 9090
  - Mounts prometheus.yml configuration
  - Persistent storage for metrics data

- **Node Exporter**
  - Port: 9100
  - Host system metrics collection
  - Read-only access to host system files

### Prometheus Configuration

The `prometheus.yml` file configures:
- 15s scrape interval
- Prometheus self-monitoring
- Node Exporter metrics collection

### Security Considerations

- All services bind to localhost (`127.0.0.1`)
- No external network exposure
- Read-only volume mounts where possible
- Separate Docker network for inter-service communication

## Volume Management

The stack uses Docker named volumes:
- `grafana-data`: Stores Grafana dashboards and settings
- `prometheus-data`: Stores Prometheus time-series data

## Maintenance

### Updating Images

Run the update script periodically to fetch latest images:
```powershell
# Windows
.\update-images.ps1

# Linux/MacOS
./update-images.sh
```

### Checking Service Status
```powershell
docker-compose ps
```

### Viewing Logs
```powershell
# All services
docker-compose logs

# Specific service
docker-compose logs [service_name]
```

### Restarting Services
```powershell
# Restart everything
docker-compose restart

# Restart specific service
docker-compose restart [service_name]
```

## Troubleshooting

1. **Service Won't Start**
   - Check logs: `docker-compose logs [service_name]`
   - Verify port availability
   - Check volume permissions

2. **Can't Access Services**
   - Ensure services are running: `docker-compose ps`
   - Check localhost bindings
   - Verify no port conflicts

3. **Metrics Not Showing**
   - Check Prometheus targets page
   - Verify Node Exporter is accessible
   - Check Prometheus configuration

## License

Free Open Source Licence
