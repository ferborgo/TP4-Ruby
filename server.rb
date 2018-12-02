require 'bundler'
Bundler.require
require './Models/Item.rb'
require './Models/Cart.rb'
require './Exceptions/MyExceptions.rb'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: './db/development.sqlite3'

before do
	content_type :json
end

get '/items.json' do
	status 200
	Item.select(:id, :sku, :description).to_json
end

get '/items/:id.json' do |id|
	begin
		status 200

		Item.find(id).to_json
	rescue ActiveRecord::RecordNotFound
		status 404
	end
end

post '/items.json' do
	begin
		status 201

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

		item = Item.find(id)
		params.delete("id")
		if params.empty?
			status 400
		else
			item.update!(params)
		end
	rescue ActiveRecord::RecordNotFound
		status 404
	rescue ActiveRecord::RecordInvalid, ActiveModel::UnknownAttributeError
		status 400
	end
end

get '/cart/:username.json' do |username|
	begin
		status 200

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
		Item.exists?(params['id_item']) ? (item = Item.find(params['id_item'])) : (raise NoItem)
		if (params['quantity'].to_i.positive?)
			item.stock =  item.stock - params['quantity'].to_i
			params['quantity'].to_i.times {|n| cart.items << item}
			status 200
		else
			status 400
		end
	rescue ActiveRecord::RecordNotFound
		status 201
		Cart.create!(username: username)
		item = Item.find(params['id_item'])
		cart.items << item
	rescue ActiveRecord::RecordInvalid, NoItem
		status 400
	end
end	

delete '/cart/:username/:item_id.json' do
	begin
		cart = Cart.find_by!(username: params['username'])
		Item.exists?(params['item_id']) ? (item = Item.find(params['item_id'])) : (raise NoItem)
		item.update!(stock: (item.stock + cart.items.where(id: params['item_id']).count))
		cart.items.delete(item)
		status 200
	rescue ActiveRecord::RecordNotFound
		status 201
		Cart.create!(username: username).to_json
	rescue NoItem
		status 400
	end
end