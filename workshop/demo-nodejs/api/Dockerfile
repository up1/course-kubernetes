FROM node:24
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
# install pm2
RUN npm install pm2 -g
COPY . .
EXPOSE 3000
# Start with 3 processes
CMD ["pm2-runtime", "start", "ecosystem.config.js"]