class Membership < ApplicationRecord
  
  belongs_to :committee
  belongs_to :person
  belongs_to :role
end
