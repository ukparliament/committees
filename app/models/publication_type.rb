class PublicationType < ApplicationRecord
  
  has_many :publications, -> { order( 'start_at desc' ) }
end
