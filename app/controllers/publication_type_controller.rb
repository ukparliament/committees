class PublicationTypeController < ApplicationController
  
  def index
    @page_title = 'Publication types'
    @publication_types = PublicationType.all.order( 'name' )
    
    @publication_types = PublicationType.find_by_sql(
      "
        SELECT pt.*, count(p.id) AS publication_count
        FROM publication_types pt, publications p
        WHERE p.publication_type_id = pt.id
        GROUP BY pt.id
        ORDER BY pt.name
      "
    )
  end
  
  def show
    publication_type = params[:publication_type]
    @publication_type = PublicationType.find_by_system_id( publication_type )
    @page_title = @publication_type.name
  end
end
