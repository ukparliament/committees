class WorkPackageController < ApplicationController
  
  def index
    @work_packages = WorkPackage.all.order( 'open_on desc' ).order( 'close_on desc' )
    @page_title = 'Work packages'
  end
  
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find_by_system_id( work_package )
    @page_title = @work_package.title
  end
end
