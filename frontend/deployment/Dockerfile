FROM node:21.6.0-alpine3.19 as builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

FROM nginx:1.15.2-alpine
RUN rm -rf /etc/nginx/conf.d
COPY deployment/conf /etc/nginx
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html/
EXPOSE 3000
WORKDIR /usr/share/nginx/html
COPY ./env.sh .
COPY .env .
RUN apk add --no-cache bash
RUN chmod +x env.sh
CMD ["/bin/bash", "-c", "/usr/share/nginx/html/env.sh && nginx -g \"daemon off;\""]
