FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache git curl jq perl openjdk17-jre wget make bash

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 8888 9090 6060

CMD ["make", "all"]
