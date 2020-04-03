# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"
gem "sinatra"
gem "sinatra-contrib"
gem "sinatra-activerecord", :require => 'sinatra/activerecord'
gem "activerecord"
gem "rake"

group :development do
    gem 'sqlite3'
end

group :production do
    gem 'pg'
    gem "activerecord-postgresql-adapter"
end
