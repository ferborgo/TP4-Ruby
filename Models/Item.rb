class Item < ActiveRecord::Base
	validates :stock, numericality: true
	validates :price, numericality: true
	validates :sku, uniqueness: true
end