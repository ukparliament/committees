class DepartmentController < ApplicationController
  
  def index
    @page_title = 'Departments'
    @departments = Department.all.order( 'name' )
  end
  
  def show
    department = params[:department]
    @department = Department.find_by_system_id( department )
    @page_title = @department.name
    @all_committees = @department.all_committees
    @current_committees = @department.current_committees
  end
  
  def current
    department = params[:department]
    @department = Department.find_by_system_id( department )
    @page_title = @department.name
    @all_committees = @department.all_committees
    @current_committees = @department.current_committees
  end
end
