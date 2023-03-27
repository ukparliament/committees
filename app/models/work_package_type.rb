class WorkPackageType < ApplicationRecord
  
  has_many :work_packages, -> { order( 'open_on desc, close_on desc' ) }
  
  def current_work_packages
    WorkPackage.all
      .where( "work_package_type_id = ?", self )
      .where( "close_on is NULL or close_on >= ?", Date.today )
      .order( 'open_on desc, close_on desc' )
  end
end
