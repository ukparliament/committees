class Publication < ApplicationRecord
  
  belongs_to :publication_type
  belongs_to :committee
  belongs_to :department, optional: true
  

  
  def paper_series_numbers
    PaperSeriesNumber.find_by_sql(
      "
        SELECT psn.*, s.label AS session_label
        FROM paper_series_numbers psn, sessions s
        WHERE psn.session_id = s.id
        AND psn.publication_id = #{self.id}
      "
    )
  end
  
  def work_packages
    WorkPackage.find_by_sql(
      "
        SELECT wp.*
        FROM work_packages wp
        
        -- We only want work packages associated with this publication, so we inner join.
        INNER JOIN (
          SELECT wpp.publication_id as publication_id, wpp.work_package_id as work_package_id
          FROM work_package_publications wpp
          WHERE wpp.publication_id = #{self.id}
        ) work_package_publication
        ON work_package_publication.work_package_id = wp.id
        
        ORDER BY wp.open_on desc, wp.close_on desc
      "
    )
  end
  
  def publication_document_files
    PublicationDocumentFile.find_by_sql(
      "
        SELECT pdf.*, pd.system_id AS publication_document_system_id
        FROM publication_document_files pdf, publication_documents pd
        WHERE pdf.publication_document_id = pd.id
        AND pd.publication_id = #{self.id}
      "
    )
  end
  
  def has_links?
    has_links = false
    has_links = true unless self.additional_content_url.blank? && self.additional_content_url_2.blank?
    has_links
  end
end
