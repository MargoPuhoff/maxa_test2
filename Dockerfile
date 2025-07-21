# Dockerfile
FROM --platform=linux/amd64 ruby:3.2.2-alpine3.18

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    librsvg2-bin \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile* ./

RUN bundle install

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]

EXPOSE 3000
