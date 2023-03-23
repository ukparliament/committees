class CommitteeTypeController < ApplicationController
  
  def index
    @page_title = 'Committee types'
    @committee_types = CommitteeType.all.order( 'name' )
  end
  
  def show
    committee_type = params[:committee_type]
    @committee_type = CommitteeType.find_by_system_id( committee_type )
    @page_title = @committee_type.name
    @all_committees = @committee_type.all_committees
    @current_committees = @committee_type.current_committees
  end
  
  def current
    committee_type = params[:committee_type]
    @committee_type = CommitteeType.find_by_system_id( committee_type )
    @page_title = @committee_type.name
    @all_committees = @committee_type.all_committees
    @current_committees = @committee_type.current_committees
  end
end
