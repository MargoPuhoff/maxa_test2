# SVG to PDF Converter

Веб-приложение для конвертации SVG файлов в PDF формат с современным минималистичным интерфейсом.

## 🚀 Возможности

- **Загрузка SVG файлов** - поддержка файлов до 10MB
- **Конвертация в PDF** - высококачественная конвертация с помощью rsvg-convert
- **Современный UI** - минималистичный дизайн на Vue.js
- **REST API** - полноценный API на Rails
- **Автоматическое скачивание** - готовый PDF сразу скачивается

## 🛠 Технологии

### Backend
- Ruby 3.x
- Rails 7.2.2
- PostgreSQL - база данных
- Active Storage - управление файлами
- Factory Bot - фабрики для тестов
- rsvg-convert - конвертация SVG в PDF
- RSpec - тестирование

### Frontend
- Vue.js 3 - реактивный интерфейс
- Vite - сборщик
- CSS3 - стилизация

### Инфраструктура
- Docker - контейнеризация
- Docker Compose - оркестрация

## 📋 Требования

- Ruby 3.0+
- Node.js 16+
- PostgreSQL
- rsvg-convert

## 🚀 Установка и запуск

1. **Клонируйте репозиторий**
 git clone <repository-url> cd maxa_test2

2. **Запустите с Docker Compose**
   docker-compose up --build

3. **Откройте приложение**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:3000

#### Backend

1. **Установите зависимости**
   cd backend
   bundle install

2. **Настройте базу данных**
   rails db:create
   rails db:migrate

3. **Запустите сервер**
   rails server

#### Frontend

1. **Установите зависимости**
   cd frontend
   npm install

2. **Запустите dev сервер**
   npm run dev

## 📖 Использование

1. **Откройте приложение** в браузере
2. **Нажмите "Select File"** для выбора SVG файла
3. **Проверьте файл** - должен быть SVG формат, размер до 10MB
4. **Нажмите "Upload File"** для конвертации
5. **Дождитесь скачивания** готового PDF файла

## 🔧 API Endpoints

### POST /file_pdfs
Загружает SVG файл и конвертирует его в PDF

**Параметры:**
- `file_pdf[original_file]` - SVG файл

**Ответ:**
- `200 OK` - PDF файл для скачивания
- `422 Unprocessable Entity` - ошибка валидации

## 🧪 Тестирование

cd backend
bundle exec rspec
