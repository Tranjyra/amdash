ActiveRecord::Schema.define(version: 2023_05_26_103959) do

  create_table "action_text_rich_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", limit: 16777215
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.string "serialized_subject"
    t.integer "event_type"
    t.integer "from_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "readed"
    t.text "comment"
  end

  create_table "infodbs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "category_id"
    t.integer "subcategory_id"
    t.integer "base_type"
    t.string "name"
    t.string "desc"
    t.string "source_url"
    t.string "source_type"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status_id"
    t.integer "job_type_id"
    t.string "store_code"
    t.boolean "accepted"
    t.boolean "historical", default: false
    t.text "description"
    t.string "sn_sys_id"
    t.string "sn_inc"
    t.string "sn_task_sys_id"
    t.string "sn_task"
    t.integer "islatest", default: 0
  end

  create_table "patch_panels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "job_id"
    t.integer "staff_id"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "eq_id"
    t.integer "zone_id"
    t.boolean "checked"
    t.integer "subjob_id"
    t.integer "status"
  end

  create_table "ports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "patch_panel_id"
    t.integer "port_number"
    t.integer "zone_id"
    t.integer "eq_id"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "used", null: false
    t.string "short_description"
    t.boolean "empty", default: false
  end

  create_table "registrators", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "model_id"
    t.integer "cum_count"
    t.string "ip_address"
  end

  create_table "staffs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "staff_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "zone_id"
    t.boolean "required"
    t.integer "report_id"
    t.boolean "supervised"
  end

  create_table "statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "baseidd"
    t.string "region"
    t.string "idd"
    t.string "time_start"
    t.string "time_end"
    t.string "opening_date"
    t.string "zone"
    t.string "s_stat"
    t.string "phone"
    t.string "phoneext"
    t.string "email"
    t.string "addr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end


  create_table "test_ars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_models", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_default_queries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "query_type"
    t.string "query_data"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "username", null: false
    t.string "fullname"
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id"
    t.boolean "supervisor"
    t.string "password"
    t.boolean "flocal", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
