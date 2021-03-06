class Item < ActiveRecord::Base
	validates :stock, numericality: {greater_than: -1}
	validates :price, numericality: {greater_than: 0}
	validates :sku, uniqueness: true
	has_and_belongs_to_many :carts
end