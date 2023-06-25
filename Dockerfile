FROM ruby:3.2.2

ENV SECRET_KEY_BASE=$(uuidgen)
ENV RAILS_ENV=production

ARG GOOGLE_CREDS=auth.json
ARG SPREADSHEET_ID

ENV GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_CREDS
ENV SPREADSHEET_ID=$SPREADSHEET_ID

WORKDIR /app

COPY Gemfile* .

RUN gem install bundler -v 2.4.13
RUN bundle install

COPY . .

RUN bundle exec rails db:create; bundle exec rails db:schema:load
RUN bundle exec rails assets:precompile; bundle exec rails tailwindcss:build

EXPOSE 3000
CMD bundle exec rails s

