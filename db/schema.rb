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

ActiveRecord::Schema.define(:version => 20101217081912) do

  create_table "rubygems", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "test_results", :force => true do |t|
    t.boolean  "result"
    t.text     "test_output"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version_id"
    t.integer  "rubygem_id"
    t.string   "operating_system"
    t.string   "architecture"
    t.string   "machine_architecture"
    t.string   "vendor"
    t.string   "ruby_version"
    t.string   "platform"
  end

  create_table "versions", :force => true do |t|
    t.string   "number"
    t.integer  "rubygem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "prerelease"
  end

end
