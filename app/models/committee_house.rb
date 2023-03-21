class CommitteeHouse < ApplicationRecord
  
  belongs_to :committee
  belongs_to :parliamentary_house
end
