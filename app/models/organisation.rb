class Organisation < ApplicationRecord
  
  has_many :positions, -> { order( :name ) }
end
