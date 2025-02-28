# == Schema Information
#
# Table name: committee_oral_evidence_transcripts
#
#  id                          :integer          not null, primary key
#  committee_id                :integer          not null
#  oral_evidence_transcript_id :integer          not null
#
# Foreign Keys
#
#  fk_committee                 (committee_id => committees.id)
#  fk_oral_evidence_transcript  (oral_evidence_transcript_id => oral_evidence_transcripts.id)
#
class CommitteeOralEvidenceTranscript < ApplicationRecord
  
  belongs_to :committee
  belongs_to :oral_evidence_transcript
end
