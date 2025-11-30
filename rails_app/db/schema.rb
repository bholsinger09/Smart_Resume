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

ActiveRecord::Schema[7.1].define(version: 2023_11_30_000008) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "job_skills", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "skill_id", null: false
    t.boolean "required", default: false
    t.integer "importance", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "skill_id"], name: "index_job_skills_on_job_id_and_skill_id", unique: true
    t.index ["job_id"], name: "index_job_skills_on_job_id"
    t.index ["skill_id"], name: "index_job_skills_on_skill_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title", null: false
    t.string "company", null: false
    t.text "description", null: false
    t.text "requirements"
    t.string "location"
    t.string "employment_type"
    t.decimal "salary_min", precision: 10, scale: 2
    t.decimal "salary_max", precision: 10, scale: 2
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_jobs_on_active"
    t.index ["company"], name: "index_jobs_on_company"
    t.index ["title"], name: "index_jobs_on_title"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "resume_id", null: false
    t.bigint "job_id", null: false
    t.decimal "score", precision: 5, scale: 2, null: false
    t.json "matched_skills", default: []
    t.json "missing_skills", default: []
    t.text "recommendations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_matches_on_job_id"
    t.index ["resume_id", "job_id"], name: "index_matches_on_resume_id_and_job_id", unique: true
    t.index ["resume_id"], name: "index_matches_on_resume_id"
    t.index ["score"], name: "index_matches_on_score"
  end

  create_table "resume_skills", force: :cascade do |t|
    t.bigint "resume_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resume_id", "skill_id"], name: "index_resume_skills_on_resume_id_and_skill_id", unique: true
    t.index ["resume_id"], name: "index_resume_skills_on_resume_id"
    t.index ["skill_id"], name: "index_resume_skills_on_skill_id"
  end

  create_table "resumes", force: :cascade do |t|
    t.string "filename", null: false
    t.string "content_type"
    t.text "extracted_text"
    t.text "summary"
    t.json "extracted_skills", default: []
    t.json "entities", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "processing_status", default: "pending"
    t.text "processing_error"
    t.index ["created_at"], name: "index_resumes_on_created_at"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name", null: false
    t.string "category"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_skills_on_category"
    t.index ["name"], name: "index_skills_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "job_skills", "jobs"
  add_foreign_key "job_skills", "skills"
  add_foreign_key "matches", "jobs"
  add_foreign_key "matches", "resumes"
  add_foreign_key "resume_skills", "resumes"
  add_foreign_key "resume_skills", "skills"
end
