# docker-python-supercronic-example

A simple example project demonstrating how to run Python scripts periodically in Docker using Supercronic — a cron‑like scheduler optimized for containers.

## Background

Traditional cron in containers has several limitations:

- Doesn't support environment variables natively
- Lacks proper logging and error handling for containerized applications

This project provides a cleaner, more Docker-friendly solution using [Supercronic](https://github.com/aptible/supercronic), designed specifically to address these pain points when scheduling periodic tasks in containers.

## Project Structure

```
.
├── Dockerfile          # Builds the Python image with Supercronic
├── docker-compose.yml  # Configuration for container deployment
├── entrypoint.sh       # Script that generates crontab and starts Supercronic
├── test.py             # Example Python script that runs on schedule
└── requirements.txt    # Python dependencies (add your requirements here)
```

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Setup and Run

1. Clone this repository
   ```bash
   git clone https://github.com/emuqi/docker-python-supercronic-example.git
   cd docker-python-supercronic-example
   ```

2. **Select Supercronic for your architecture**

   The Dockerfile is configured for ARM64 architecture by default. For other architectures (such as x86_64), you'll need to modify the `Dockerfile`:

   Visit the [Supercronic releases page](https://github.com/aptible/supercronic/releases), and find the **installation instructions** for your system architecture.

   Replace the following section：

   ```Dockerfile
   # Latest releases available at https://github.com/aptible/supercronic/releases
   # Choose the appropriate Supercronic version based on your system architecture
   ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-arm64 \
       SUPERCRONIC_SHA1SUM=e0f0c06ebc5627e43b25475711e694450489ab00 \
       SUPERCRONIC=supercronic-linux-arm64
   
   RUN curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic
   ```

3. Create a `.env` file for your environment variables
   ```
   CUSTOM_MESSAGE=Hello from the scheduled task!
   CRON_SCHEDULE=*/5 * * * *  # Run every 5 minutes
   ```

4. Build and start the container
   ```bash
   docker compose up -d --build

   ```

5. Check logs to verify it's running
   ```bash
   docker logs my_python_cron_job
   ```

## Configuration

### Environment Variables

| Variable | Description |
|----------|-------------|
| `TZ` | Container timezone | 
| `CRON_SCHEDULE` | Cron expression for scheduling | 
| `CUSTOM_MESSAGE` | Example variable passed to the Python script |

### Cron Schedule Examples

- `* * * * *` - Every minute
- `*/5 * * * *` - Every 5 minutes
- `0 * * * *` - Every hour
- `0 0 * * *` - Every day at midnight
- `0 18 * * *` - Every day at 6:00 PM

## Customizing

1. Replace or modify `test.py` with your own Python script
2. Extend or override variables by editing the `.env` file or the `environment:` block in `docker-compose.yml`. Any new variable you add (e.g., `NEW_VAR=value`) will be loaded into the container.
3. Update `requirements.txt` with any dependencies your script needs
4. Rebuild the container: `docker-compose up -d --build`


## Contributing

Contributions welcome! Please feel free to submit a Pull Request.

## License

[MIT License](LICENSE)