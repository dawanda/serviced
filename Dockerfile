FROM rails:4.2

ENV GITHUB_CLIENT_ID "FILL_ME_IN"
ENV GITHUB_CLIENT_SECRET "FILL_ME_IN"
ENV GITHUB_ORG "FILL_ME_IN"

RUN apt-get update \
    && apt-get install -y nodejs --no-install-recommends \
    && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
