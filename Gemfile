source 'https://rubygems.org'

ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7'
gem 'arel'

# Subset of a normal Rails application, created for applications that don't require all functionalities
gem 'rails-api'

gem 'resque', '~> 1.25.2'
gem 'resque-pool'
gem 'resque-scheduler'
# A wrapper for scheduling jobs through ActiveJob
gem 'active_scheduler'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
gem 'pg_search'

gem 'rack-timeout'
gem 'puma'
gem 'puma_worker_killer'

# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 3.5'

# Use jsonapi-resources to serialize JSON API responses and follow JSPON-API standard
gem 'jsonapi-resources', '~> 0.7.0'

# pub/sub for Ruby objects
gem 'wisper'

# tracks changes to your models' data
gem 'paper_trail', '~> 5.2.0'

# creates pretty URL’s and work with human-friendly strings
gem 'friendly_id', '~> 5.1.0'

# Easy file upload management for ActiveRecord and to AWS S3
gem 'paperclip', '~> 4.3'
gem 'aws-sdk', '~> 1.64'

# Used for memcached
gem 'dalli'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'awesome_print', '~> 1.6.1'
  gem 'dotenv-rails'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker'
  gem 'hirb', '~> 0.7.2'
  gem 'phantomjs', '>= 1.8.1.1'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rb-readline'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'parallel_tests'
end

group :test do
  gem 'database_cleaner', '~> 1.5.0'
  gem 'resque_spec'
  gem 'rspec-activejob'
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
  gem 'test_after_commit'
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
  gem 'wisper-rspec', require: false
  gem 'fakeweb'
end
