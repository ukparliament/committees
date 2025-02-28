# == Schema Information
#
# Table name: organisations
#
#  id        :integer          not null, primary key
#  name      :string(1000)     not null
#  idms_id   :string(255)
#  system_id :integer          not null
#
class Organisation < ApplicationRecord
  
  has_many :positions, -> { order( :name ) }
end
