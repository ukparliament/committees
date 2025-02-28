# == Schema Information
#
# Table name: committee_events
#
#  id           :integer          not null, primary key
#  committee_id :integer          not null
#  event_id     :integer          not null
#
# Foreign Keys
#
#  fk_committee  (committee_id => committees.id)
#  fk_event      (event_id => events.id)
#
class CommitteeEvent < ApplicationRecord
  
  belongs_to :committee
  belongs_to :event
end
