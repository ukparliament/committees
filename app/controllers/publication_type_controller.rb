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
    @alternate_title = "Publications of type #{@publication_type.name}"
    @rss_url = publication_type_show_url( :format => 'rss' )
    respond_to do |format|
      format.html {
        @publications = @publication_type.publications
      }
      format.rss {
        @publications = @publication_type.publications_limited
      }
    end
  end
end
