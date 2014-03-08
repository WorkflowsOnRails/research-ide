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

ActiveRecord::Schema.define(version: 20140309005413) do

  create_table "attachments", force: true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "task_id",           null: false
    t.integer  "uploader_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["task_id", "file_file_name"], name: "index_attachments_on_task_id_and_file_file_name", unique: true
  add_index "attachments", ["task_id"], name: "index_attachments_on_task_id"
  add_index "attachments", ["uploader_id"], name: "index_attachments_on_uploader_id"

  create_table "projects", force: true do |t|
    t.string   "aasm_state",      null: false
    t.string   "name",            null: false
    t.integer  "owner_id",        null: false
    t.integer  "last_updater_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["last_updater_id"], name: "index_projects_on_last_updater_id"
  add_index "projects", ["owner_id"], name: "index_projects_on_owner_id"

  create_table "projects_users", force: true do |t|
    t.integer "project_id", null: false
    t.integer "user_id",    null: false
  end

  add_index "projects_users", ["project_id", "user_id"], name: "index_projects_users_on_project_id_and_user_id", unique: true

  create_table "roles", force: true do |t|
    t.string  "name",          null: false
    t.integer "user_id",       null: false
    t.integer "resource_id"
    t.string  "resource_type"
    t.string  "value"
  end

  add_index "roles", ["name"], name: "index_roles_on_name"
  add_index "roles", ["user_id", "resource_type", "resource_id", "name"], name: "unique_role_name_per_user_resource_pair", unique: true

  create_table "tasks", force: true do |t|
    t.string   "task_type",            null: false
    t.text     "content",              null: false
    t.integer  "project_id",           null: false
    t.integer  "last_updater_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cached_latex_content"
  end

  add_index "tasks", ["last_updater_id"], name: "index_tasks_on_last_updater_id"
  add_index "tasks", ["project_id", "task_type"], name: "index_tasks_on_project_id_and_task_type", unique: true
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id"

  create_table "users", force: true do |t|
    t.string   "full_name",                           null: false
    t.string   "affiliation",                         null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
