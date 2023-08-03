class Publication < ApplicationRecord
  
  belongs_to :publication_type
  belongs_to :committee
  belongs_to :department, optional: true
end
