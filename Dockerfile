FROM node:20.8.0-buster AS base

COPY package.json ./
RUN npm install --silent

FROM base AS development
WORKDIR /usr/src/app
COPY ["package.json","./"]
RUN npm install -g @angular/cli@15.2.10
RUN npm install
COPY . .
EXPOSE 4200
CMD ng serve --port 4200

FROM development AS test
RUN npm install -g playwright


FROM base AS production
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
EXPOSE 80
RUN chown -R node /usr/src/app
USER node
CMD ["npm", "start"]
