# == Schema Information
#
# Table name: scrutinisings
#
#  id            :integer          not null, primary key
#  committee_id  :integer          not null
#  department_id :integer          not null
#
# Foreign Keys
#
#  fk_committee   (committee_id => committees.id)
#  fk_department  (department_id => departments.id)
#
class Scrutinising < ApplicationRecord
  
  belongs_to :committee
  belongs_to :department
end
