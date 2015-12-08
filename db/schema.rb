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

ActiveRecord::Schema.define(version: 20150905120456) do

  create_table "add_retailer_id_to_award_points", force: :cascade do |t|
    t.integer  "retailer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index"
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index"
  add_index "audits", ["created_at"], name: "index_audits_on_created_at"
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid"
  add_index "audits", ["user_id", "user_type"], name: "user_index"

  create_table "awards", force: :cascade do |t|
    t.integer  "points"
    t.string   "code"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "qr_code_file_name"
    t.string   "qr_code_content_type"
    t.integer  "qr_code_file_size"
    t.datetime "qr_code_updated_at"
    t.string   "status"
    t.integer  "retailer_id"
    t.string   "phone_number"
    t.string   "open_id"
    t.boolean  "is_used",              default: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
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

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "members", force: :cascade do |t|
    t.string   "member_external_id"
    t.string   "gender"
    t.string   "address"
    t.string   "birth_date"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "auth_token"
    t.string   "client_id"
  end

  add_index "members", ["auth_token"], name: "index_members_on_auth_token", unique: true
  add_index "members", ["member_external_id"], name: "index_members_on_member_external_id", unique: true
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true

  create_table "membership_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "retailer_id"
    t.integer  "member_id"
    t.integer  "points",             default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "membership_type_id"
  end

  add_index "memberships", ["member_id"], name: "index_memberships_on_member_id"
  add_index "memberships", ["membership_type_id"], name: "index_memberships_on_membership_type_id"
  add_index "memberships", ["retailer_id"], name: "index_memberships_on_retailer_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "retailer_id"
    t.decimal  "total_charge",        default: 0.0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.decimal  "total_points_charge", default: 0.0
    t.string   "payment_method",      default: "cash"
    t.integer  "member_id"
  end

  add_index "orders", ["member_id"], name: "index_orders_on_member_id"
  add_index "orders", ["retailer_id"], name: "index_orders_on_retailer_id"

  create_table "permissions", force: :cascade do |t|
    t.boolean  "can_manage"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "retailer_id"
    t.string   "module_name"
  end

  create_table "placements", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.decimal  "quantity",   default: 0.0
  end

  add_index "placements", ["order_id"], name: "index_placements_on_order_id"
  add_index "placements", ["product_id"], name: "index_placements_on_product_id"

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.decimal  "price"
    t.text     "description",       default: ""
    t.integer  "barcode",           default: 123
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "retailer_id"
    t.decimal  "quantity_in_stock", default: 0.0
    t.decimal  "point_value",       default: 0.0
  end

  add_index "products", ["barcode"], name: "index_products_on_barcode"
  add_index "products", ["retailer_id"], name: "index_products_on_retailer_id"

  create_table "promoted_orders", force: :cascade do |t|
    t.integer  "promotion_id"
    t.integer  "order_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "promoted_orders", ["order_id"], name: "index_promoted_orders_on_order_id"
  add_index "promoted_orders", ["promotion_id"], name: "index_promoted_orders_on_promotion_id"

  create_table "promotion_sms_messages", force: :cascade do |t|
    t.integer  "promotion_id"
    t.integer  "membership_id"
    t.text     "message"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "promotion_sms_messages", ["membership_id"], name: "index_promotion_sms_messages_on_membership_id"
  add_index "promotion_sms_messages", ["promotion_id"], name: "index_promotion_sms_messages_on_promotion_id"

  create_table "promotion_tags", force: :cascade do |t|
    t.integer  "promotion_id"
    t.string   "tag"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "promotion_tags", ["promotion_id"], name: "index_promotion_tags_on_promotion_id"

  create_table "promotions", force: :cascade do |t|
    t.integer  "retailer_id"
    t.text     "offer"
    t.text     "occation"
    t.date     "expiry_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "promotions", ["retailer_id"], name: "index_promotions_on_retailer_id"

  create_table "reserved_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "retailers", force: :cascade do |t|
    t.string   "user_name",                     default: "",      null: false
    t.string   "encrypted_password",            default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "auth_token",                    default: ""
    t.string   "user_type",                     default: "Owner"
    t.integer  "owner_id"
    t.string   "profile_qr_image_file_name"
    t.string   "profile_qr_image_content_type"
    t.integer  "profile_qr_image_file_size"
    t.datetime "profile_qr_image_updated_at"
  end

  add_index "retailers", ["auth_token"], name: "index_retailers_on_auth_token", unique: true
  add_index "retailers", ["reset_password_token"], name: "index_retailers_on_reset_password_token", unique: true
  add_index "retailers", ["user_name"], name: "index_retailers_on_user_name", unique: true

  create_table "revenue_stats", force: :cascade do |t|
    t.integer  "retailer_id"
    t.float    "new_user_revenue"
    t.float    "regular_user_revenue"
    t.float    "vip_user_revenue"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "revenue_stats", ["retailer_id"], name: "index_revenue_stats_on_retailer_id"

  create_table "settings", force: :cascade do |t|
    t.integer  "retailer_id"
    t.text     "welcome_message"
    t.integer  "no_of_order_to_send_growth_sms"
    t.integer  "no_of_days_to_send_lapse_message"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "test_promotion_contact_no"
    t.text     "growth_message"
    t.text     "risk_message"
    t.string   "qr_image_file_name"
    t.string   "qr_image_content_type"
    t.integer  "qr_image_file_size"
    t.datetime "qr_image_updated_at"
  end

  add_index "settings", ["retailer_id"], name: "index_settings_on_retailer_id"

  create_table "sign_up_progresses", force: :cascade do |t|
    t.integer  "retailer_id"
    t.integer  "sign_up_goal",               default: 100
    t.integer  "sign_up_so_far",             default: 0
    t.integer  "refresh_sign_up_every_days", default: 7
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "sign_up_progresses", ["retailer_id"], name: "index_sign_up_progresses_on_retailer_id"

  create_table "sms_first_visits", force: :cascade do |t|
    t.integer  "membership_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
  end

  add_index "sms_first_visits", ["deleted_at"], name: "index_sms_first_visits_on_deleted_at"

  create_table "sms_growth_visits", force: :cascade do |t|
    t.integer  "membership_id"
    t.integer  "visit_count"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
  end

  add_index "sms_growth_visits", ["deleted_at"], name: "index_sms_growth_visits_on_deleted_at"

  create_table "sms_risk_notifications", force: :cascade do |t|
    t.integer  "membership_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
  end

  add_index "sms_risk_notifications", ["deleted_at"], name: "index_sms_risk_notifications_on_deleted_at"
  add_index "sms_risk_notifications", ["membership_id"], name: "index_sms_risk_notifications_on_membership_id"

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

end
