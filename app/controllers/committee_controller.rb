class CommitteeController < ApplicationController
  
  def index
    @page_title = 'Committees'
    @committees = Committee.all.order( 'name' )
  end
  
  def show
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
  end
end
