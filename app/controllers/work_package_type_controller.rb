class WorkPackageTypeController < ApplicationController
  
  def index
    @page_title = 'Work package types'
    @work_package_types = WorkPackageType.all.order( 'name' )
  end
  
  def show
    work_package_type = params[:work_package_type]
    @work_package_type = WorkPackageType.find_by_system_id( work_package_type )
    @page_title = @work_package_type.name
  end
  
  def current
    work_package_type = params[:work_package_type]
    @work_package_type = WorkPackageType.find_by_system_id( work_package_type )
    @page_title = @work_package_type.name
  end
end
