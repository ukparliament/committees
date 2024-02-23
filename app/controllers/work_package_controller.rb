class WorkPackageController < ApplicationController
  
  def index
    @all_work_packages = WorkPackage.all.order( 'open_on desc' ).order( 'close_on desc' )
    @current_work_packages = WorkPackage.
      all
      .order( 'open_on desc' ).order( 'close_on desc' )
      .where( "close_on is NULL or close_on >= ?", Date.today )
    @page_title = 'Work packages'
  end
  
  def current
    @all_work_packages = WorkPackage.all.order( 'open_on desc' ).order( 'close_on desc' )
    @current_work_packages = WorkPackage.
      all
      .order( 'open_on desc' ).order( 'close_on desc' )
      .where( "close_on is NULL or close_on >= ?", Date.today )
    @page_title = 'Work packages'
  end
  
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find_by_system_id( work_package )
    @page_title = @work_package.title
  end
  
  def oral_evidence_transcripts
    work_package = params[:work_package]
    @work_package = WorkPackage.find_by_system_id( work_package )
    @page_title = @work_package.title
    @alternate_title = "#{@work_package.title} - Oral evidence transcripts"
    @rss_url = work_package_oral_evidence_transcript_list_url( :format => 'rss' )

    respond_to do |format|
      format.html {
        @oral_evidence_transcripts = @work_package.oral_evidence_transcripts
      }
      format.rss {
        @oral_evidence_transcripts = @work_package.oral_evidence_transcripts_limited
      }
    end
  end
  
  def publications
    work_package = params[:work_package]
    @work_package = WorkPackage.find_by_system_id( work_package )
    @page_title = @work_package.title
    @alternate_title = "#{@work_package.title} - Publications"
    @rss_url = work_package_publication_list_url( :format => 'rss' )
    respond_to do |format|
      format.html {
        @publications = @work_package.publications
      }
      format.rss {
        @publications = @work_package.publications_limited
      }
    end
  end
  
  def publication_type_list
    work_package = params[:work_package]
    @work_package = WorkPackage.find_by_system_id( work_package )
    @page_title = @work_package.title
  end
  
  def publication_type_show
    work_package = params[:work_package]
    @work_package = WorkPackage.find_by_system_id( work_package )
    publication_type = params[:publication_type]
    @publication_type = PublicationType.find_by_system_id( publication_type )
    @page_title = @work_package.title
    
    @alternate_title = "#{@work_package.title} - Publications - #{@publication_type.name}"
    @rss_url = work_package_publication_type_show_url( :format => 'rss' )

    respond_to do |format|
      format.html {
        @publications = @work_package.publications_of_type( @publication_type )
      }
      format.rss {
        @publications = @work_package.publications_of_type_limited( @publication_type )
      }
    end
  end
end
