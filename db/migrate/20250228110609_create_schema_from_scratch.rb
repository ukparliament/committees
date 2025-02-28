class CreateSchemaFromScratch < ActiveRecord::Migration[7.2]
  def change
    create_schema "heroku_ext"

    # These are extensions that must be enabled in order to support this database
    enable_extension "pg_stat_statements"
    enable_extension "plpgsql"

    create_table "activity_types", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255
    end

    create_table "categories", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255, null: false
      t.integer "system_id", null: false
    end

    create_table "committee_committee_types", id: :serial, force: :cascade do |t|
      t.integer "committee_id", null: false
      t.integer "committee_type_id", null: false
    end

    create_table "committee_events", id: :serial, force: :cascade do |t|
      t.integer "committee_id", null: false
      t.integer "event_id", null: false
    end

    create_table "committee_houses", id: :serial, force: :cascade do |t|
      t.integer "committee_id", null: false
      t.integer "parliamentary_house_id", null: false
    end

    create_table "committee_oral_evidence_transcripts", id: :serial, force: :cascade do |t|
      t.integer "committee_id", null: false
      t.integer "oral_evidence_transcript_id", null: false
    end

    create_table "committee_types", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255, null: false
      t.integer "system_id", null: false
      t.integer "category_id", null: false
    end

    create_table "committee_work_packages", id: :serial, force: :cascade do |t|
      t.integer "committee_id", null: false
      t.integer "work_package_id", null: false
    end

    create_table "committee_written_evidence_publications", id: :serial, force: :cascade do |t|
      t.integer "committee_id", null: false
      t.integer "written_evidence_publication_id", null: false
    end

    create_table "committees", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255, null: false
      t.date "start_on"
      t.date "end_on"
      t.date "commons_appointed_on"
      t.date "lords_appointed_on"
      t.integer "lead_parliamentary_house_id"
      t.string "address", limit: 500
      t.string "phone", limit: 500
      t.string "email", limit: 500
      t.string "contact_disclaimer", limit: 500
      t.boolean "is_shown_on_website", default: false
      t.string "legacy_url", limit: 500
      t.boolean "is_redirect_enabled", default: false
      t.boolean "is_lead_committee", default: false
      t.integer "system_id", null: false
      t.integer "parent_committee_id"
    end

    create_table "departments", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255, null: false
      t.integer "system_id", null: false
    end

    create_table "event_segments", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255
      t.datetime "start_at", precision: nil, null: false
      t.datetime "end_at", precision: nil
      t.boolean "is_private", default: false
      t.integer "system_id", null: false
      t.integer "event_id", null: false
      t.integer "activity_type_id", null: false
    end

    create_table "event_types", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255
      t.boolean "is_visit", default: false
      t.string "description", limit: 5000, null: false
      t.integer "system_id", null: false
    end

    create_table "events", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255
      t.datetime "start_at", precision: nil, null: false
      t.datetime "end_at", precision: nil, null: false
      t.datetime "cancelled_at", precision: nil
      t.string "location_name", limit: 255
      t.string "originating_system", limit: 255, null: false
      t.integer "system_id", null: false
      t.integer "location_id"
      t.integer "event_type_id", null: false
    end

    create_table "locations", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255
      t.integer "system_id", null: false
    end

    create_table "memberships", id: :serial, force: :cascade do |t|
      t.date "start_on", null: false
      t.date "end_on"
      t.boolean "is_lay_member", default: false
      t.boolean "is_ex_officio", default: false
      t.boolean "is_alternate", default: false
      t.boolean "is_co_opted", default: false
      t.integer "system_id", null: false
      t.integer "person_id", null: false
      t.integer "committee_id", null: false
      t.integer "role_id", null: false
    end

    create_table "oral_evidence_transcript_files", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255, null: false
      t.integer "size", null: false
      t.string "format", limit: 255, null: false
      t.string "url", limit: 1000
      t.integer "oral_evidence_transcript_id", null: false
    end

    create_table "oral_evidence_transcripts", id: :serial, force: :cascade do |t|
      t.date "start_on", null: false
      t.date "meeting_on"
      t.date "published_on", null: false
      t.string "legacy_html_url", limit: 255
      t.string "legacy_pdf_url", limit: 255
      t.integer "document_id"
      t.integer "system_id", null: false
      t.integer "event_segment_id"
    end

    create_table "organisations", id: :serial, force: :cascade do |t|
      t.string "name", limit: 1000, null: false
      t.string "idms_id", limit: 255
      t.integer "system_id", null: false
    end

    create_table "paper_series_numbers", id: :serial, force: :cascade do |t|
      t.string "number", limit: 255, null: false
      t.integer "session_id", null: false
      t.integer "parliamentary_house_id", null: false
      t.integer "oral_evidence_transcript_id"
      t.integer "publication_id"
      t.integer "written_evidence_publication_id"
    end

    create_table "parliamentary_houses", id: :serial, force: :cascade do |t|
      t.string "short_label", limit: 255, null: false
      t.string "label", limit: 255, null: false
    end

    create_table "people", id: :serial, force: :cascade do |t|
      t.string "name", limit: 1000, null: false
      t.integer "system_id"
      t.integer "mnis_id"
    end

    create_table "positions", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255, null: false
      t.integer "organisation_id", null: false
    end

    create_table "publication_document_files", id: :serial, force: :cascade do |t|
      t.text "name", null: false
      t.integer "size", null: false
      t.string "format", limit: 255, null: false
      t.string "url", limit: 1000
      t.integer "publication_document_id", null: false
    end

    create_table "publication_documents", id: :serial, force: :cascade do |t|
      t.integer "publication_id", null: false
      t.integer "system_id", null: false
    end

    create_table "publication_types", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255, null: false
      t.string "plural_name", limit: 255, null: false
      t.text "description", null: false
      t.boolean "government_can_respond", default: false
      t.boolean "can_be_response", default: false
      t.string "icon_key", limit: 255
      t.integer "system_id", null: false
    end

    create_table "publications", id: :serial, force: :cascade do |t|
      t.text "description", null: false
      t.datetime "start_at", precision: nil, null: false
      t.datetime "end_at", precision: nil
      t.string "additional_content_url", limit: 500
      t.string "additional_content_url_2", limit: 500
      t.integer "system_id", null: false
      t.integer "committee_id", null: false
      t.integer "publication_type_id", null: false
      t.integer "responded_to_publication_id"
      t.integer "department_id"
    end

    create_table "roles", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255
      t.boolean "is_chair", default: false
      t.integer "system_id", null: false
    end

    create_table "scrutinisings", id: :serial, force: :cascade do |t|
      t.integer "committee_id", null: false
      t.integer "department_id", null: false
    end

    create_table "sessions", id: :serial, force: :cascade do |t|
      t.string "label", limit: 255
      t.integer "system_id", null: false
    end

    create_table "witness_positions", id: :serial, force: :cascade do |t|
      t.integer "witness_id", null: false
      t.integer "position_id", null: false
    end

    create_table "witnesses", id: :serial, force: :cascade do |t|
      t.string "person_name", limit: 3000
      t.integer "system_id"
      t.integer "person_id"
      t.integer "oral_evidence_transcript_id", null: false
    end

    create_table "work_package_oral_evidence_transcripts", id: :serial, force: :cascade do |t|
      t.integer "work_package_id", null: false
      t.integer "oral_evidence_transcript_id", null: false
    end

    create_table "work_package_publications", id: :serial, force: :cascade do |t|
      t.integer "work_package_id", null: false
      t.integer "publication_id", null: false
    end

    create_table "work_package_types", id: :serial, force: :cascade do |t|
      t.string "name", limit: 255, null: false
      t.string "description", limit: 1000, null: false
      t.boolean "is_inquiry", default: false
      t.integer "system_id", null: false
    end

    create_table "work_packages", id: :serial, force: :cascade do |t|
      t.string "title", limit: 1000, null: false
      t.date "open_on", null: false
      t.date "close_on"
      t.integer "system_id", null: false
      t.integer "work_package_type_id", null: false
    end

    create_table "written_evidence_publications", id: :serial, force: :cascade do |t|
      t.string "submission_id", limit: 255, null: false
      t.string "internal_reference", limit: 255, null: false
      t.datetime "published_at", precision: nil, null: false
      t.string "legacy_html_url", limit: 255
      t.string "legacy_pdf_url", limit: 255
      t.boolean "is_anonymous", default: false
      t.string "anonymous_witness_text", limit: 255
      t.integer "work_package_id", null: false
      t.integer "system_id", null: false
    end

    add_foreign_key "committee_committee_types", "committee_types", name: "fk_committee_type"
    add_foreign_key "committee_committee_types", "committees", name: "fk_committee"
    add_foreign_key "committee_events", "committees", name: "fk_committee"
    add_foreign_key "committee_events", "events", name: "fk_event"
    add_foreign_key "committee_houses", "committees", name: "fk_committee"
    add_foreign_key "committee_houses", "parliamentary_houses", name: "fk_parliamentary_house"
    add_foreign_key "committee_oral_evidence_transcripts", "committees", name: "fk_committee"
    add_foreign_key "committee_oral_evidence_transcripts", "oral_evidence_transcripts", name: "fk_oral_evidence_transcript"
    add_foreign_key "committee_types", "categories", name: "fk_category"
    add_foreign_key "committee_work_packages", "committees", name: "fk_committee"
    add_foreign_key "committee_work_packages", "work_packages", name: "fk_work_package"
    add_foreign_key "committee_written_evidence_publications", "committees", name: "fk_committee"
    add_foreign_key "committee_written_evidence_publications", "written_evidence_publications", name: "fk_written_evidence_publication"
    add_foreign_key "committees", "committees", column: "parent_committee_id", name: "fk_parent_committee"
    add_foreign_key "committees", "parliamentary_houses", column: "lead_parliamentary_house_id", name: "fk_lead_parliamentary_house"
    add_foreign_key "event_segments", "activity_types", name: "fk_activity_type"
    add_foreign_key "event_segments", "events", name: "fk_event"
    add_foreign_key "events", "event_types", name: "fk_event_type"
    add_foreign_key "events", "locations", name: "fk_location"
    add_foreign_key "memberships", "committees", name: "fk_committee"
    add_foreign_key "memberships", "people", name: "fk_person"
    add_foreign_key "memberships", "roles", name: "fk_role"
    add_foreign_key "oral_evidence_transcript_files", "oral_evidence_transcripts", name: "fk_oral_evidence_transcript"
    add_foreign_key "oral_evidence_transcripts", "event_segments", name: "fk_event_segment"
    add_foreign_key "paper_series_numbers", "oral_evidence_transcripts", name: "fk_oral_evidence_transcript"
    add_foreign_key "paper_series_numbers", "oral_evidence_transcripts", name: "fk_written_evidence_publication"
    add_foreign_key "paper_series_numbers", "parliamentary_houses", name: "fk_parliamentary_house"
    add_foreign_key "paper_series_numbers", "publications", name: "fk_publication"
    add_foreign_key "paper_series_numbers", "sessions", name: "fk_session"
    add_foreign_key "positions", "organisations", name: "fk_organisation"
    add_foreign_key "publication_document_files", "publication_documents", name: "fk_publication_document"
    add_foreign_key "publication_documents", "publications", name: "fk_publication"
    add_foreign_key "publications", "committees", name: "fk_committee"
    add_foreign_key "publications", "departments", name: "fk_department"
    add_foreign_key "publications", "publication_types", column: "responded_to_publication_id", name: "fk_responded_to_publication_type"
    add_foreign_key "publications", "publication_types", name: "fk_publication_type"
    add_foreign_key "scrutinisings", "committees", name: "fk_committee"
    add_foreign_key "scrutinisings", "departments", name: "fk_department"
    add_foreign_key "witness_positions", "positions", name: "fk_position"
    add_foreign_key "witness_positions", "witnesses", name: "fk_witness"
    add_foreign_key "witnesses", "oral_evidence_transcripts", name: "fk_oral_evidence_transcript"
    add_foreign_key "witnesses", "people", name: "fk_person"
    add_foreign_key "work_package_oral_evidence_transcripts", "oral_evidence_transcripts", name: "fk_oral_evidence_transcript"
    add_foreign_key "work_package_oral_evidence_transcripts", "work_packages", name: "fk_work_package"
    add_foreign_key "work_package_publications", "publications", name: "fk_publication"
    add_foreign_key "work_package_publications", "work_packages", name: "fk_work_package"
    add_foreign_key "work_packages", "work_packages", column: "work_package_type_id", name: "fk_work_package_type"
    add_foreign_key "written_evidence_publications", "work_packages", name: "fk_work_package"
  end
end
