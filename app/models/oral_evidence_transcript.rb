class OralEvidenceTranscript < ApplicationRecord
  
  belongs_to :event_segment, optional: true
  has_many :oral_evidence_transcript_files
  
  def link
    "https://committees.parliament.uk/oralevidence/#{self.system_id}/html"
  end
end
