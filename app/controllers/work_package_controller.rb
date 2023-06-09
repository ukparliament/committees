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
  end
end
