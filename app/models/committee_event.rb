class CommitteeEvent < ApplicationRecord
  
  belongs_to :committee
  belongs_to :event
end
