require './Models/Item.rb'

class Item_Controller
	def self.items
		Item.all
	end

	def self.get_item(id)
		Item.find_by(id: id)
	end

	def self.insert_item(params)
		begin
			Item.create!(sku: params['sku'], description: params['description'], price: params['price'], stock: params['stock'])
		rescue ActiveRecord::RecordInvalid
			print "Error en la validacion"
		end
	end
end