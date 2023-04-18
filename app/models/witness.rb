class Witness < ApplicationRecord
  
  belongs_to :oral_evidence_transcript
  belongs_to :person, optional: true
  belongs_to :position
end
