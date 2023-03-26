class CommitteeWorkPackage < ApplicationRecord
  
  belongs_to :committee
  belongs_to :work_package
end
