require 'bundler'
Bundler.require
require_relative 'models/Item'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'sample.db'

Item.all.each do |item|
  p item.description
end
