# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_10_31_072601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "admin_users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "enterprise_field_records", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "record_id"
    t.string "table_id"
    t.string "batch"
    t.string "code"
    t.string "name"
    t.jsonb "base_fields"
    t.datetime "batch_updated_at"
    t.string "acknowledgment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch"], name: "index_enterprise_field_records_on_batch"
    t.index ["code"], name: "index_enterprise_field_records_on_code"
    t.index ["record_id"], name: "index_enterprise_field_records_on_record_id"
  end

  create_table "feishu_excel_imports", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "file"
    t.integer "enterprise_status", default: 0
    t.integer "talent_status", default: 0
    t.integer "round_status", default: 0
    t.integer "trend_status", default: 0
    t.integer "innovation_status", default: 0
    t.integer "graph_status", default: 0
    t.integer "product_status", default: 0
    t.text "remark"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "graph_field_records", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "record_id"
    t.string "table_id"
    t.string "batch"
    t.string "enterprise_record_id"
    t.string "level1"
    t.string "level2"
    t.jsonb "base_fields"
    t.datetime "batch_updated_at"
    t.string "acknowledgment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch"], name: "index_graph_field_records_on_batch"
    t.index ["enterprise_record_id"], name: "index_graph_field_records_on_enterprise_record_id"
    t.index ["record_id"], name: "index_graph_field_records_on_record_id"
  end

  create_table "industry_analysis_tasks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "batch"
    t.string "api_method", default: "enterprise_info"
    t.jsonb "data"
    t.string "send_status", default: "pending"
    t.string "acknowledgment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "innovation_field_records", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "record_id"
    t.string "table_id"
    t.string "batch"
    t.string "name"
    t.jsonb "base_fields"
    t.datetime "batch_updated_at"
    t.string "acknowledgment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch"], name: "index_innovation_field_records_on_batch"
    t.index ["record_id"], name: "index_innovation_field_records_on_record_id"
  end

  create_table "macro_field_records", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "record_id"
    t.string "table_id"
    t.string "batch"
    t.string "file"
    t.integer "sector", default: 1
    t.string "title"
    t.string "source"
    t.string "author"
    t.datetime "publishDate"
    t.datetime "batch_updated_at"
    t.string "acknowledgment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch"], name: "index_macro_field_records_on_batch"
    t.index ["record_id"], name: "index_macro_field_records_on_record_id"
  end

  create_table "product_field_records", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "record_id"
    t.string "table_id"
    t.string "batch"
    t.string "enterprise_record_id"
    t.string "name"
    t.jsonb "base_fields"
    t.datetime "batch_updated_at"
    t.string "acknowledgment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch"], name: "index_product_field_records_on_batch"
    t.index ["enterprise_record_id"], name: "index_product_field_records_on_enterprise_record_id"
    t.index ["record_id"], name: "index_product_field_records_on_record_id"
  end

  create_table "round_field_records", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "record_id"
    t.string "table_id"
    t.string "enterprise_record_id"
    t.string "batch"
    t.string "name"
    t.jsonb "base_fields"
    t.datetime "batch_updated_at"
    t.string "acknowledgment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch"], name: "index_round_field_records_on_batch"
    t.index ["enterprise_record_id"], name: "index_round_field_records_on_enterprise_record_id"
    t.index ["record_id"], name: "index_round_field_records_on_record_id"
  end

  create_table "talent_field_records", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "record_id"
    t.string "table_id"
    t.string "enterprise_record_id"
    t.string "batch"
    t.string "name"
    t.jsonb "base_fields"
    t.datetime "batch_updated_at"
    t.string "acknowledgment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch"], name: "index_talent_field_records_on_batch"
    t.index ["enterprise_record_id"], name: "index_talent_field_records_on_enterprise_record_id"
    t.index ["record_id"], name: "index_talent_field_records_on_record_id"
  end

  create_table "trend_field_records", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "record_id"
    t.string "table_id"
    t.string "batch"
    t.string "enterprise_record_id"
    t.string "name"
    t.jsonb "base_fields"
    t.datetime "batch_updated_at"
    t.string "acknowledgment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["batch"], name: "index_trend_field_records_on_batch"
    t.index ["enterprise_record_id"], name: "index_trend_field_records_on_enterprise_record_id"
    t.index ["record_id"], name: "index_trend_field_records_on_record_id"
  end

end
