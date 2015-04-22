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

ActiveRecord::Schema.define(:version => 20150422123522) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "lentil_admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "lentil_admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "lentil_admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "lentil_battles", :force => true do |t|
    t.integer  "image_id"
    t.integer  "loser_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lentil_flags", :force => true do |t|
    t.integer  "image_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lentil_flags", ["image_id"], :name => "index_flags_on_image_id"

  create_table "lentil_images", :force => true do |t|
    t.text     "description"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.integer  "like_votes_count",                  :default => 0
    t.string   "url"
    t.integer  "user_id"
    t.integer  "state",                             :default => 0
    t.string   "external_identifier"
    t.string   "long_url"
    t.text     "original_metadata"
    t.datetime "original_datetime"
    t.boolean  "staff_like",                        :default => false
    t.integer  "moderator_id"
    t.datetime "moderated_at"
    t.boolean  "second_moderation",                 :default => false
    t.integer  "wins_count",                        :default => 0
    t.integer  "losses_count",                      :default => 0
    t.float    "win_pct"
    t.integer  "popular_score",                     :default => 0
    t.datetime "file_harvested_date"
    t.integer  "file_harvest_failed",               :default => 0
    t.datetime "donor_agreement_submitted_date"
    t.integer  "donor_agreement_failed",            :default => 0
    t.integer  "failed_file_checks",                :default => 0
    t.datetime "file_last_checked"
    t.datetime "donor_agreement_rejected"
    t.boolean  "do_not_request_donation",           :default => false
    t.datetime "last_donor_agreement_failure_date"
    t.string   "media_type"
    t.string   "video_url"
    t.boolean  "suppressed",                        :default => false
  end

  add_index "lentil_images", ["created_at"], :name => "index_lentil_images_on_created_at"
  add_index "lentil_images", ["do_not_request_donation"], :name => "index_lentil_images_on_do_not_request_donation"
  add_index "lentil_images", ["external_identifier"], :name => "index_images_on_external_identifier"
  add_index "lentil_images", ["failed_file_checks"], :name => "index_lentil_images_on_failed_file_checks"
  add_index "lentil_images", ["file_last_checked"], :name => "index_lentil_images_on_file_last_checked"
  add_index "lentil_images", ["last_donor_agreement_failure_date"], :name => "index_lentil_images_on_last_donor_agreement_failure_date"
  add_index "lentil_images", ["moderator_id"], :name => "index_images_on_moderator_id"
  add_index "lentil_images", ["original_datetime"], :name => "index_lentil_images_on_original_datetime"
  add_index "lentil_images", ["staff_like"], :name => "index_lentil_images_on_staff_like"
  add_index "lentil_images", ["state"], :name => "index_lentil_images_on_state"
  add_index "lentil_images", ["suppressed"], :name => "index_lentil_images_on_suppressed"
  add_index "lentil_images", ["updated_at"], :name => "index_lentil_images_on_updated_at"
  add_index "lentil_images", ["user_id"], :name => "index_lentil_images_on_user_id"

  create_table "lentil_licenses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "short_name"
  end

  add_index "lentil_licenses", ["short_name"], :name => "index_licenses_on_short_name"

  create_table "lentil_licensings", :force => true do |t|
    t.integer  "image_id"
    t.integer  "license_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lentil_licensings", ["image_id"], :name => "index_licensings_on_image_id"
  add_index "lentil_licensings", ["license_id"], :name => "index_licensings_on_license_id"

  create_table "lentil_like_votes", :force => true do |t|
    t.integer  "image_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lentil_like_votes", ["image_id"], :name => "index_like_votes_on_image_id"

  create_table "lentil_services", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lentil_services", ["name"], :name => "index_services_on_name"

  create_table "lentil_taggings", :force => true do |t|
    t.integer  "image_id"
    t.integer  "tag_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "staff_tag",  :default => false
  end

  add_index "lentil_taggings", ["image_id"], :name => "index_taggings_on_image_id"
  add_index "lentil_taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

  create_table "lentil_tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lentil_tags", ["name"], :name => "index_tags_on_name"

  create_table "lentil_tagset_assignments", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "tagset_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lentil_tagset_assignments", ["tag_id"], :name => "index_tagset_assignments_on_tag_id"
  add_index "lentil_tagset_assignments", ["tagset_id"], :name => "index_tagset_assignments_on_tagset_id"

  create_table "lentil_tagsets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "harvest",     :default => false
  end

  create_table "lentil_users", :force => true do |t|
    t.string   "user_name"
    t.string   "full_name"
    t.boolean  "banned"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "service_id"
    t.text     "bio"
    t.integer  "images_count", :default => 0
  end

  add_index "lentil_users", ["user_name"], :name => "index_users_on_user_name"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
