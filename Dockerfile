FROM ruby:4.0.7-slim

ENV BUNDLE_WITHOUT=development
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN useradd --create-home app
USER app

CMD ["bundle", "exec", "rspec"]
