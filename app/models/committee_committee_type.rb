# == Schema Information
#
# Table name: committee_committee_types
#
#  id                :integer          not null, primary key
#  committee_id      :integer          not null
#  committee_type_id :integer          not null
#
# Foreign Keys
#
#  fk_committee       (committee_id => committees.id)
#  fk_committee_type  (committee_type_id => committee_types.id)
#
class CommitteeCommitteeType < ApplicationRecord
  
  belongs_to :committee
  belongs_to :committee_type
end
