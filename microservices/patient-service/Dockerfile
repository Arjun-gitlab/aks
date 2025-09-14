# ---- Stage 1: Builder ----
FROM node:18-alpine AS builder
WORKDIR /app
 
# Copy dependency definitions
COPY package*.json ./
 
# Install deps (ci if lockfile exists, otherwise install)
RUN if [ -f package.json ]; then npm ci; else npm install; fi
 
# Copy source code
COPY . .
 
# ---- Stage 2: Runner ----
FROM node:18-alpine AS runner
WORKDIR /app
 
# Copy only needed files from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist   # if you build into dist
# Or COPY source files if no dist build:
# COPY --from=builder /app/*.js ./
 
EXPOSE 3000
CMD ["node", "server.js"]
