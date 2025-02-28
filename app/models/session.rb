# == Schema Information
#
# Table name: sessions
#
#  id        :integer          not null, primary key
#  label     :string(255)
#  system_id :integer          not null
#
class Session < ApplicationRecord
end
