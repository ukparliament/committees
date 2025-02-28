# == Schema Information
#
# Table name: committee_houses
#
#  id                     :integer          not null, primary key
#  committee_id           :integer          not null
#  parliamentary_house_id :integer          not null
#
# Foreign Keys
#
#  fk_committee            (committee_id => committees.id)
#  fk_parliamentary_house  (parliamentary_house_id => parliamentary_houses.id)
#
class CommitteeHouse < ApplicationRecord
  
  belongs_to :committee
  belongs_to :parliamentary_house
end
