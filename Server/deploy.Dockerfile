# SPDX-FileCopyrightText: 2025 Contributors to the CitrineOS Project
#
# SPDX-License-Identifier: Apache-2.0

# -------------------------------
# Build stage (CPU-compatible)
# -------------------------------
FROM --platform=${BUILDPLATFORM:-linux/amd64} node:18-bullseye-slim AS build

WORKDIR /usr/local/apps/citrineos

# Copy all source files
COPY . .

# Install dependencies and build
RUN npm install && npm run build

# -------------------------------
# Final stage (runtime)
# -------------------------------
FROM node:18-bullseye-slim

WORKDIR /usr/local/apps/citrineos

# Copy built files from build stage
COPY --from=build /usr/local/apps/citrineos /usr/local/apps/citrineos

# Make entrypoint executable
RUN chmod +x /usr/local/apps/citrineos/entrypoint.sh

# Expose runtime port (use environment variable PORT if set)
EXPOSE ${PORT:-8080}

# Set entrypoint
ENTRYPOINT ["/usr/local/apps/citrineos/entrypoint.sh"]
