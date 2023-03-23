FROM node:18-alpine3.16 as build

WORKDIR /build

COPY ["package.json", "package-lock.json", "./"]

RUN npm install --quiet

COPY . .

RUN npm run build

FROM node:18-alpine3.16

LABEL org.opencontainers.image.title="Nostream"
LABEL org.opencontainers.image.source=https://github.com/Cameri/nostream
LABEL org.opencontainers.image.description="nostream"
LABEL org.opencontainers.image.authors="Ricardo Arturo Cabral Mejía"
LABEL org.opencontainers.image.licenses=MIT

RUN apk add --no-cache --update git

USER node:node
WORKDIR /app

ADD --chown=node:node resources /app/resources

COPY --chown=node:node --from=build /build/dist .

RUN npm install --omit=dev --quiet

CMD ["node", "src/index.js"]
