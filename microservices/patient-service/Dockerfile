# ---- Stage 1: Builder ----
FROM node:20-alpine AS builder
 
# Set working directory
WORKDIR /app
 
# Copy dependency definitions first (better cache)
COPY package*.json ./
 
# Install dependencies
# If lockfile exists → npm ci (strict, reproducible)
# Otherwise → npm install
RUN if [ -f package.json ]; then npm ci; else npm install; fi
 
# Copy rest of the source code
COPY . .
 
# ---- Stage 2: Runner ----
FROM node:20-alpine AS runner
 
# Set working directory
WORKDIR /app
 
# Copy only necessary files from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist   # for transpiled code (TypeScript, etc.)
# Or, if you don’t build into dist, copy raw JS:
# COPY --from=builder /app/*.js ./
 
# Expose application port
EXPOSE 3000
 
# Start the app
CMD ["node", "service.js"]
