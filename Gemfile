# http is more reliable than https, keep
source 'http://rubygems.org'

# ruby '2.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# basics
gem 'rails', '5.0.1'
gem 'pg'
gem 'hashie'
gem 'flowcommerce'
# gem 'redcarpet'              # abandoned

# solidus fw
gem 'solidus', '2.1.0'
gem 'solidus_auth_devise'

group :manual_load do
  gem 'dotenv'
  gem 'faraday'
  gem 'thread'
end

group :development, :test do
  gem 'awesome_print'
end

group :development do
  gem 'spring'                           # fast console and tests
  gem 'pry-rails'                        # better console
  gem 'puma'
  gem 'listen', '~> 3.0.5'

  # css and js block
  gem 'therubyracer', platforms: :ruby
  gem 'sass-rails', '~> 5.0'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.2'
  gem 'turbolinks', '~> 5'

  # gem 'smarter_csv'
end

group :production do
  gem 'newrelic_rpm'
  gem 'rack-timeout', require: 'rack/timeout/base' # Rack::Timeout is important for avoiding stuck Puma workers/threads on server:
end

group :test do
  gem 'rspec-rails'
end