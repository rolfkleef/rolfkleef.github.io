FROM ruby:3.2

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs yarn libpq-dev postgresql-client ruby-full
RUN mkdir /app

WORKDIR /app

RUN gem install rails

COPY Gemfile Gemfile.lock ./
RUN --mount=type=secret,id=github_user \
  --mount=type=secret,id=github_token \
  BUNDLE_GITHUB__COM=$(cat /run/secrets/github_user):$(cat /run/secrets/github_token) bundle install
COPY package.json yarn.lock ./
RUN yarn

# Copy the rest of the application code into the container
#COPY . .

# Precompile the assets
# RUN rails assets:precompile

EXPOSE 3000
CMD ["bin/dev"]
