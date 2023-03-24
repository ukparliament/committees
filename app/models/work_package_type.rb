class WorkPackageType < ApplicationRecord
  
  has_many :work_packages, -> { order( 'open_on desc' ) }
end
