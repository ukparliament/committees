# == Schema Information
#
# Table name: publication_document_files
#
#  id                      :integer          not null, primary key
#  format                  :string(255)      not null
#  name                    :text             not null
#  size                    :integer          not null
#  url                     :string(1000)
#  publication_document_id :integer          not null
#
# Foreign Keys
#
#  fk_publication_document  (publication_document_id => publication_documents.id)
#
class PublicationDocumentFile < ApplicationRecord
  
  belongs_to :publication_document
  
  def link( publication )
    "https://committees.parliament.uk/publications/#{publication.system_id}/documents/#{self.publication_document_system_id}/default/"
  end
end


