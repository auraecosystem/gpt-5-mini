FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache git curl jq perl openjdk17-jre wget make bash

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 8080 9090 3000 5000 8545 9494 3333

CMD ["sh"]
