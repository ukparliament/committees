# == Schema Information
#
# Table name: witness_positions
#
#  id          :integer          not null, primary key
#  position_id :integer          not null
#  witness_id  :integer          not null
#
# Foreign Keys
#
#  fk_position  (position_id => positions.id)
#  fk_witness   (witness_id => witnesses.id)
#
class WitnessPosition < ApplicationRecord
  
  belongs_to :witness
  belongs_to :position
end
