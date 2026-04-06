FROM ruby:3.2.2-slim

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
