FROM node:22-slim

WORKDIR /app

# Install Hermes
RUN npm install -g hermes-agent

# Create directories
RUN mkdir -p /app/data /app/workspace

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 3000 9119

CMD ["/app/start.sh"]
