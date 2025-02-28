# == Schema Information
#
# Table name: written_evidence_publications
#
#  id                     :integer          not null, primary key
#  anonymous_witness_text :string(255)
#  internal_reference     :string(255)      not null
#  is_anonymous           :boolean          default(FALSE)
#  legacy_html_url        :string(255)
#  legacy_pdf_url         :string(255)
#  published_at           :datetime         not null
#  submission_id          :string(255)      not null
#  system_id              :integer          not null
#  work_package_id        :integer          not null
#
# Foreign Keys
#
#  fk_work_package  (work_package_id => work_packages.id)
#
class WrittenEvidencePublication < ApplicationRecord
  
  belongs_to :work_package
end
