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

ActiveRecord::Schema.define(version: 2021_01_23_005838) do

  create_table "connections", force: :cascade do |t|
    t.text "mac"
    t.text "user"
    t.text "pass"
    t.text "ip"
    t.datetime "tod"
  end

  create_table "cpus", force: :cascade do |t|
    t.integer "inventory_id"
    t.text "product"
    t.text "slot"
    t.datetime "timestamp"
  end

  create_table "disks", force: :cascade do |t|
    t.integer "inventory_id"
    t.text "description"
    t.text "product"
    t.text "version"
    t.text "serial"
    t.text "businfo"
    t.datetime "timestamp"
  end

  create_table "inventories", force: :cascade do |t|
    t.text "bmc_mac"
  end

  create_table "mems", force: :cascade do |t|
    t.integer "inventory_id"
    t.text "description"
    t.text "product"
    t.text "vendor"
    t.text "physid"
    t.text "serial"
    t.text "slot"
    t.text "size"
    t.datetime "timestamp"
  end

  create_table "nics", force: :cascade do |t|
    t.integer "inventory_id"
    t.text "product"
    t.text "vendor"
    t.text "physid"
    t.text "serial"
    t.text "businfo"
    t.datetime "timestamp"
  end

  create_table "nvmes", force: :cascade do |t|
    t.integer "inventory_id"
    t.text "model"
    t.text "serial"
    t.text "firmware_rev"
    t.text "address"
    t.datetime "timestamp"
  end

  create_table "sels", force: :cascade do |t|
    t.integer "system_id"
    t.text "sel_record_id"
    t.text "record_type"
    t.datetime "timestamp"
    t.text "generator_id"
    t.text "evm_revision"
    t.text "sensor_type"
    t.text "sensor_number"
    t.text "event_type"
    t.text "event_direction"
    t.text "event_data"
    t.text "description"
    t.text "manufactacturer_id"
    t.text "oem_defined"
    t.text "panic_string"
  end

  create_table "storages", force: :cascade do |t|
    t.integer "inventory_id"
    t.text "description"
    t.text "product"
    t.text "vendor"
    t.text "businfo"
    t.datetime "timestamp"
  end

  create_table "systems", force: :cascade do |t|
    t.text "username"
    t.text "password"
    t.text "model"
    t.text "comments"
    t.text "bmc_mac"
    t.index ["bmc_mac"], name: "index_systems_on_bmc_mac", unique: true
  end

end
