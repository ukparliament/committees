class CommitteeCategoryController < ApplicationController
  
  def index
    @page_title = 'Committee categories'
    @committee_categories = Category.all.order( 'name' )
  end
  
  def show
    committee_category = params[:committee_category]
    @committee_category = Category.find_by_system_id( committee_category )
    @page_title = @committee_category.name
  end
end
