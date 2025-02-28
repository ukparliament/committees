# == Schema Information
#
# Table name: categories
#
#  id        :integer          not null, primary key
#  name      :string(255)      not null
#  system_id :integer          not null
#
class Category < ApplicationRecord
  
  has_many :committee_types, -> { order( :name ) }
end
