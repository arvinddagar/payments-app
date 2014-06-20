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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140620055341) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "payments", force: true do |t|
    t.decimal  "amount",           precision: 19, scale: 2,                 null: false
    t.boolean  "charged",                                   default: false, null: false
    t.integer  "sessions_count",                            default: 1,     null: false
    t.integer  "user_id",                                   default: 0,     null: false
    t.string   "paypal_payer_id"
    t.string   "paypal_token"
    t.string   "payment_method"
    t.string   "stripe_token"
    t.string   "stripe_charge_id"
    t.string   "currency",                                  default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pricing_tiers", force: true do |t|
    t.integer  "min_sessions",                              null: false
    t.integer  "max_sessions",                              null: false
    t.integer  "default_sessions",                          null: false
    t.decimal  "usd_price",        precision: 19, scale: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sessions_count",         default: 0,     null: false
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
