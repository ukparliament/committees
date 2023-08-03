class WorkPackagePublication < ApplicationRecord
  
  belongs_to :work_package
  belongs_to :publication
end
