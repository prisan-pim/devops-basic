
FROM node:lts-alpine 

WORKDIR /app

COPY . /app

ADD package.json /app/

RUN yarn install

RUN yarn build

EXPOSE 3000

CMD ["yarn",  "start"]
