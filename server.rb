require 'bundler'
Bundler.require
#require_relative 'Controllers/ItemController'
require './Models/Item.rb'
require './Models/Cart.rb'
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: './db/development.sqlite3'

get '/items.json' do
	content_type :json
	status 200
	Item.all.to_json
end

get '/items/:id.json' do |id|
	begin
		status 200
		content_type :json
		Item.find(id).to_json
	rescue ActiveRecord::RecordNotFound
		status 404
	end
end

post '/items.json' do
	begin
		status 201
		content_type :json
		Item.create!(sku: params['sku'], description: params['description'], price: params['price'], stock: params['stock'])
	#La petición es sintácticamente correcta, pero no semántica (por ejemplo, sku no es único)
	rescue ActiveRecord::RecordNotUnique
		status 422
	#El error es sintáctico (por ejemplo, price no es un número)
	rescue ActiveRecord::RecordInvalid
		status 400
	end
end

put '/items/:id.json' do |id|
	begin
		#The server has successfully fulfilled the request and that there is no additional content to send in the response payload body.
		status 204
		content_type :json
		item = Item.find(id)
		params.delete("id")
		if params.empty?
			status 400
		else
			item.update!(params)
		end
	rescue ActiveRecord::RecordNotFound
		status 404
	rescue ActiveRecord::RecordInvalid
		status 400
	end
end

get '/cart/:username.json' do |username|
	begin
		status 200
		content_type :json
		cart = Cart.find_by!(username: username)
		h = Hash.new(0)
		h['items'] = cart.items
		cart.items.each {|item| h['total'] += item.price}
		h['created_at'] = cart.created_at
		h.to_json
	rescue ActiveRecord::RecordNotFound
		status 201
		Cart.create!(username: username).to_json
	end
end

put '/cart/:username.json' do |username|
	begin
		cart = Cart.find_by!(username: username)
		item = Item.find(params['id_item'])
		item.stock =  item.stock - params['quantity'].to_i
		params['quantity'].to_i.times {|n| cart.items << item}
		status 200
	rescue ActiveRecord::RecordNotFound
		status 201
		Cart.create!(username: username)
		item = Item.find(params['id_item'])
		cart.items << item
	rescue ActiveRecord::RecordInvalid
		status 400
	end
end	

delete '/cart/:username/:item_id.json' do
	begin
		cart = Cart.find_by!(username: params['username'])
		item = Item.find(params['item_id'])
		#item.stock = item.stock + cart.items.where(id: params['item_id']).count
		item.update!(stock: (item.stock + cart.items.where(id: params['item_id']).count))
		cart.items.delete(item)
		status 200
	rescue ActiveRecord::RecordNotFound
		status 201
		Cart.create!(username: username).to_json
	end
end

get '/:id' do |id|
	Cart_Item.all.to_json
end