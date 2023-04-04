class OralEvidenceSession < ApplicationRecord
  
  belongs_to :event_segment, optional: true
end
