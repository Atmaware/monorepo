FROM node:22.12 as builder

WORKDIR /app

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
RUN apt-get update && apt-get install -y g++ make python3

COPY package.json .
COPY yarn.lock .
COPY tsconfig.json .
COPY .prettierrc .
COPY .eslintrc .

COPY /packages/readabilityjs/package.json ./packages/readabilityjs/package.json
COPY /packages/api/package.json ./packages/api/package.json
COPY /packages/text-to-speech/package.json ./packages/text-to-speech/package.json
COPY /packages/content-handler/package.json ./packages/content-handler/package.json
COPY /packages/liqe/package.json ./packages/liqe/package.json
COPY /packages/utils/package.json ./packages/utils/package.json

RUN yarn install --pure-lockfile

ADD /packages/readabilityjs ./packages/readabilityjs
ADD /packages/api ./packages/api
ADD /packages/text-to-speech ./packages/text-to-speech
ADD /packages/content-handler ./packages/content-handler
ADD /packages/liqe ./packages/liqe
ADD /packages/utils ./packages/utils

RUN yarn workspace @ruminer/utils build
RUN yarn workspace @ruminer/text-to-speech-handler build
RUN yarn workspace @ruminer/content-handler build
RUN yarn workspace @ruminer/liqe build
RUN yarn workspace @ruminer/api build

# After building, fetch the production dependencies
RUN rm -rf /app/packages/api/node_modules
RUN rm -rf /app/node_modules
RUN yarn install --pure-lockfile --production

FROM node:22.12 as runner
LABEL org.opencontainers.image.source="https://github.com/atmaware/ruminer"

RUN apt-get update && apt-get install -y netcat-openbsd

WORKDIR /app

ENV NODE_ENV production

COPY --from=builder /app/packages/api/dist /app/packages/api/dist
COPY --from=builder /app/packages/readabilityjs/ /app/packages/readabilityjs/
COPY --from=builder /app/packages/api/package.json /app/packages/api/package.json
COPY --from=builder /app/packages/api/node_modules /app/packages/api/node_modules
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/packages/text-to-speech/ /app/packages/text-to-speech/
COPY --from=builder /app/packages/content-handler/ /app/packages/content-handler/
COPY --from=builder /app/packages/liqe/ /app/packages/liqe/
COPY --from=builder /app/packages/utils/ /app/packages/utils/

CMD ["yarn", "workspace", "@ruminer/api", "start_queue_processor"]
