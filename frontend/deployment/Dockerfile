# as now the last version of node alpine is 21.4.0-alpine
# but the node:18.19.0-alpine3.18 is the last version working even for linux/arm/v7 architecture
# see https://github.com/npm/cli/issues/5743
#     https://github.com/nodejs/docker-node/issues/1794
FROM node:18.19.0-alpine3.18 as builder
WORKDIR /app
COPY . .
RUN npm install --verbose
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

