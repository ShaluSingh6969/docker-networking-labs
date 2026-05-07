FROM node:13-alpine

ENV MONGO_DB_USERNAME=admin
ENV MONGO_DB_PASSWORD=password

RUN mkdir -p /home/app

COPY . /home/app

RUN echo "Listing /home/app contents:" && ls -la /home/app

CMD ["node", "/home/app/app/server.js"]