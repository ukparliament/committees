# == Schema Information
#
# Table name: work_package_publications
#
#  id              :integer          not null, primary key
#  publication_id  :integer          not null
#  work_package_id :integer          not null
#
# Foreign Keys
#
#  fk_publication   (publication_id => publications.id)
#  fk_work_package  (work_package_id => work_packages.id)
#
class WorkPackagePublication < ApplicationRecord
  
  belongs_to :work_package
  belongs_to :publication
end
