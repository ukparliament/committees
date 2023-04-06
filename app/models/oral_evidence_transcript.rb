class OralEvidenceTranscript < ApplicationRecord
  
  belongs_to :event_segment, optional: true
  has_many :oral_evidence_transcript_files
end
