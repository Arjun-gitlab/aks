FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm --only=production
COPY . .
EXPOSE 3000
CMD ["node","server.js"]
