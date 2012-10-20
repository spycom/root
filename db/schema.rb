# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121014145353) do

  create_table "abilities", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "exp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bots", :force => true do |t|
    t.integer  "exp"
    t.integer  "exp_all"
    t.integer  "hdpts"
    t.integer  "job"
    t.integer  "level"
    t.integer  "money"
    t.string   "name"
    t.integer  "sfpts"
    t.string   "continent"
    t.integer  "progress"
    t.string   "status"
    t.integer  "karma"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "continents", :force => true do |t|
    t.string   "name"
    t.integer  "nodes"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "power"
    t.integer  "karma"
  end

  create_table "environments", :force => true do |t|
    t.integer  "uid"
    t.integer  "memory"
    t.integer  "cpu"
    t.integer  "storage"
    t.integer  "power"
    t.integer  "network"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hardwares", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "exp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.integer  "salary"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "exp"
  end

  create_table "service_stores", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "exp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "services", :force => true do |t|
    t.integer  "uid"
    t.integer  "dhcp"
    t.integer  "dns"
    t.integer  "smtp"
    t.integer  "spam"
    t.integer  "loic"
    t.integer  "hosting"
    t.integer  "botnet"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "nat"
  end

  create_table "softwares", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "exp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "upgrades", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "exp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "exp"
    t.integer  "level"
    t.integer  "money"
    t.integer  "job"
    t.integer  "hdpts"
    t.integer  "sfpts"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "continent"
    t.integer  "progress"
    t.string   "status"
    t.integer  "exp_all"
    t.integer  "experience"
    t.integer  "karma"
    t.integer  "cpu"
    t.integer  "intrusion"
    t.integer  "stockman"
    t.integer  "menial"
    t.integer  "sociology"
    t.integer  "stealth"
    t.integer  "telepresence"
    t.integer  "memory"
    t.integer  "storage"
    t.integer  "power"
    t.integer  "network"
    t.integer  "hosts"
  end

end
