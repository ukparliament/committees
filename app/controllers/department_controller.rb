class DepartmentController < ApplicationController
  
  def index
    @page_title = 'Departments'
    @departments = Department.all.order( 'name' )
  end
  
  def show
    department = params[:department]
    @department = Department.find_by_system_id( department )
    @page_title = @department.name
  end
  
  def current
    department = params[:department]
    @department = Department.find_by_system_id( department )
    @page_title = @department.name
  end
end
