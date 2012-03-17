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

ActiveRecord::Schema.define(:version => 20120316123506) do

  create_table "companies", :force => true do |t|
    t.string   "compname"
    t.text     "compaddress"
    t.string   "comptel"
    t.string   "compfax"
    t.string   "comptax"
    t.string   "compauthor_name"
    t.string   "compauthor_position"
    t.string   "compauthor_tel"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "complogo_file_name"
    t.string   "complogo_content_type"
    t.integer  "complogo_file_size"
    t.datetime "complogo_updated_at"
    t.string   "compauthor_signature_file_name"
    t.string   "compauthor_signature_content_type"
    t.integer  "compauthor_signature_file_size"
    t.datetime "compauthor_signature_updated_at"
    t.string   "compstreet"
    t.string   "compsub_district"
    t.string   "compdistrict"
    t.integer  "province_id"
  end

  create_table "customers", :force => true do |t|
    t.string   "custname"
    t.text     "custaddress"
    t.string   "custtel"
    t.string   "custcontact_name"
    t.string   "custcontact_tel"
    t.string   "custcontact_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "custfax"
    t.string   "custstreet"
    t.string   "custsub_district"
    t.string   "custdistrict"
    t.integer  "province_id"
    t.integer  "company_id"
  end

  create_table "documents", :force => true do |t|
    t.string   "title"
    t.text     "detail"
    t.integer  "terms"
    t.text     "condition"
    t.date     "doc_date"
    t.string   "doc_number"
    t.boolean  "approve"
    t.boolean  "complete"
    t.integer  "customer_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ref_id"
    t.string   "paper_file_name"
    t.string   "paper_content_type"
    t.integer  "paper_file_size"
    t.datetime "paper_updated_at"
    t.boolean  "cancel"
    t.boolean  "tax"
  end

  create_table "items", :force => true do |t|
    t.string   "description"
    t.float    "quantity"
    t.float    "unit_price"
    t.integer  "quotation_id"
    t.integer  "invoice_id"
    t.integer  "bill_id"
    t.integer  "taxinvoice_id"
    t.integer  "receipt_id"
    t.integer  "billtaxinvoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provinces", :force => true do |t|
    t.string   "province_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
