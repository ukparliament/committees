# == Schema Information
#
# Table name: work_package_oral_evidence_transcripts
#
#  id                          :integer          not null, primary key
#  oral_evidence_transcript_id :integer          not null
#  work_package_id             :integer          not null
#
# Foreign Keys
#
#  fk_oral_evidence_transcript  (oral_evidence_transcript_id => oral_evidence_transcripts.id)
#  fk_work_package              (work_package_id => work_packages.id)
#
class WorkPackageOralEvidenceTranscript < ApplicationRecord
  
  belongs_to :work_package
  belongs_to :oral_evidence_transcript
end
