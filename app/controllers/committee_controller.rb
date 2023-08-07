class CommitteeController < ApplicationController
  
  def index
    @page_title = 'Committees'
    @all_committees = all_committees
    @current_committees = current_committees
  end
  
  def current
    @page_title = 'Committees'
    @all_committees = all_committees
    @current_committees = current_committees
  end
  
  def show
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
  end
  
  def memberships
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @all_memberships = @committee.all_memberships
    @current_memberships = @committee.current_memberships
  end
  
  def current_memberships
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @all_memberships = @committee.all_memberships
    @current_memberships = @committee.current_memberships
  end
  
  def contact
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
  end
  
  def work_package_list
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @all_work_packages = @committee.all_work_packages
    @current_work_packages = @committee.current_work_packages
  end
  
  def work_package_current
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @all_work_packages = @committee.all_work_packages
    @current_work_packages = @committee.current_work_packages
  end
  
  def event_list
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @all_events = @committee.all_events
    @upcoming_events = @committee.upcoming_events
  end
  
  def event_upcoming
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @all_events = @committee.all_events
    @upcoming_events = @committee.upcoming_events
  end
  
  def oral_evidence_transcripts
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @oral_evidence_transcripts = @committee.oral_evidence_transcripts
  end
  
  def publications
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @publications = @committee.publications
  end
  
  def all_committees
    Committee.find_by_sql(
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        
        -- We want a count of sub-commitees, if any, so we left join.
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id
        
        -- We only want non-sub-committees committees, so we check parent_committee_id is null.
        WHERE c1.parent_committee_id is null
        ORDER BY c1.name;
      "
    )
  end
  
  def current_committees
    Committee.find_by_sql(
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        
        -- We want a count of sub-commitees, if any, so we left join.
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id
        
        -- We only want current committees so we check for a NULL end date or an end date in the future.
        WHERE ( c1.end_on is NULL OR c1.end_on >= '#{Date.today}' )
        
        -- We only want non-sub-committees, so we check parent_committee_id is null.
        AND c1.parent_committee_id is null
        ORDER BY c1.name;
      "
    )
  end
end
