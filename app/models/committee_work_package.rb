# == Schema Information
#
# Table name: committee_work_packages
#
#  id              :integer          not null, primary key
#  committee_id    :integer          not null
#  work_package_id :integer          not null
#
# Foreign Keys
#
#  fk_committee     (committee_id => committees.id)
#  fk_work_package  (work_package_id => work_packages.id)
#
class CommitteeWorkPackage < ApplicationRecord
  
  belongs_to :committee
  belongs_to :work_package
end
