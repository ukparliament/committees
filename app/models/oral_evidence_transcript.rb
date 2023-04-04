class OralEvidenceTranscript < ApplicationRecord
  
  belongs_to :event_segment, optional: true
end
