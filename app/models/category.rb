class Category < ApplicationRecord
  
  has_many :committee_types, -> { order( :name ) }
end
