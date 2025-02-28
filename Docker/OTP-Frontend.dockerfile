
FROM node:16 AS build


WORKDIR /app


RUN npm install


COPY . .


RUN npm run build


EXPOSE 3000


CMD ["npm", "start"]


