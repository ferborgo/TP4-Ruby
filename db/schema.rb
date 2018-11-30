# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_30_185111) do

  create_table "carts", force: :cascade do |t|
    t.text "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts_items", id: false, force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "cart_id", null: false
    t.integer "quantity"
    t.index ["cart_id", "item_id"], name: "index_carts_items_on_cart_id_and_item_id"
    t.index ["item_id", "cart_id"], name: "index_carts_items_on_item_id_and_cart_id"
  end

  create_table "items", force: :cascade do |t|
    t.text "description"
    t.text "sku"
    t.float "price"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
