#
# Copyright (c) Minimouli
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

FROM node:17-alpine as deps
RUN apk add g++ make python3
WORKDIR /app
COPY ./api/package.json ./api/yarn.lock ./
RUN yarn install

FROM node:17-alpine as builder
WORKDIR /app
COPY ./api .
COPY --from=deps /app/node_modules ./node_modules
RUN yarn run build && yarn install --production --ignore-scripts

FROM node:17-alpine as runner
WORKDIR /app
ENV NODE_ENV production
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["node", "./dist/main"]
