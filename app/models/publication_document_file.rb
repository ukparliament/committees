class PublicationDocumentFile < ApplicationRecord
  
  belongs_to :publication_document
  
  def link( publication )
    "https://committees.parliament.uk/publications/#{publication.system_id}/documents/#{self.publication_document_system_id}/default/"
  end
end


