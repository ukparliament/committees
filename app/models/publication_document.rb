# == Schema Information
#
# Table name: publication_documents
#
#  id             :integer          not null, primary key
#  publication_id :integer          not null
#  system_id      :integer          not null
#
# Foreign Keys
#
#  fk_publication  (publication_id => publications.id)
#
class PublicationDocument < ApplicationRecord
  
  belongs_to :publication
end
