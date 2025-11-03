# Dockerfile (ในโฟลเดอร์ Next.js)

# 1. Build stage
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
# Next.js build: ต้องใช้ `output: "standalone"` เพื่อให้ทำงานใน Docker ได้ดี
RUN yarn build

# 2. Production stage
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV production
# คัดลอกเฉพาะไฟล์ที่จำเป็นสำหรับการรันน
COPY --from=builder /app/n8n/.next/standalone ./
COPY --from=builder /app/n8n/.next/static ./.next/static
COPY --from=builder /app/n8n/public ./public

EXPOSE 3000
CMD ["node", "server.js"]