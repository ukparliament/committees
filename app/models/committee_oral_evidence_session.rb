class CommitteeOralEvidenceSession < ApplicationRecord
  
  belongs_to :committee
  belongs_to :oral_evidence_session
end
