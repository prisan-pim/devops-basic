
FROM node:lts-alpine 

WORKDIR /app

COPY . /app

ADD package.json /app/

RUN yarn install

COPY . .

CMD ["yarn",  "start" , "--host" , "0.0.0.0"]
