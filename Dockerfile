# Используем официальный образ Node.js как базовый
FROM node:18 AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы приложения
COPY . .

# Собираем Angular приложение
RUN npm run build -- --configuration=production

# Используем официальный образ Nginx для сервировки статических файлов
FROM nginx:alpine

# Копируем собранные файлы из предыдущего этапа
COPY --from=build /app/dist/admin-panel-front /usr/share/nginx/html

# Копируем конфигурацию Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открываем порт 80
EXPOSE 80
EXPOSE 3000

# Запускаем Nginx
CMD ["nginx", "-g", "daemon off;"]

# FROM node:18 as build-stage
# WORKDIR /app
# COPY package.json package-lock.json ./
# RUN npm install
# COPY . .
# RUN npm run build --prod

# FROM nginx:alpine as production-stage
# COPY --from=build-stage /app/dist/angular-app /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/nginx.conf

# CMD ["nginx", "-g", "daemon off;"]