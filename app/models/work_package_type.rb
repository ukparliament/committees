# == Schema Information
#
# Table name: work_package_types
#
#  id          :integer          not null, primary key
#  description :string(1000)     not null
#  is_inquiry  :boolean          default(FALSE)
#  name        :string(255)      not null
#  system_id   :integer          not null
#
class WorkPackageType < ApplicationRecord
  
  has_many :work_packages, -> { order( 'open_on desc, close_on desc' ) }
  
  def current_work_packages
    WorkPackage.all
      .where( "work_package_type_id = ?", self )
      .where( "close_on is NULL or close_on >= ?", Date.today )
      .order( 'open_on desc, close_on desc' )
  end
  
  def current_work_packages_limited
    WorkPackage.all
      .where( "work_package_type_id = ?", self )
      .where( "close_on is NULL or close_on >= ?", Date.today )
      .order( 'open_on desc, close_on desc' )
      .limit( 20 )
  end
end
