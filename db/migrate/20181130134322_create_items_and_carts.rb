class CreateItemsAndCarts < ActiveRecord::Migration[5.2]
	def change
		create_table :items do |t|
	    	t.text :description
	    	t.text :sku
	    	t.float :price
	    	t.integer :stock
			t.timestamps
	    end
	    create_table :carts do |c|
			c.text :username
			c.timestamps
	    end
	end
end
