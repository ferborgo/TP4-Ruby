require 'bundler'
Bundler.require
require_relative 'Controllers/ItemController'
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'sample.db'

get '/items.json' do
	content_type :json
	status 200
	Item_Controller.items.to_json
end


get '/items/:id.json' do |id|
	Item_Controller.get_item(id).to_json
end

post '/items.json' do
	Item_Controller.insert_item(params).to_json
	status 201
end
