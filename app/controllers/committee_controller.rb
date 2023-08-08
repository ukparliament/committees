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
    @alternate_title = "Current work packages for the #{@committee.name}"
    @rss_url = committee_work_package_current_url( :format => 'rss' )
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
    @alternate_title = "Upcoming events for the #{@committee.name}"
    @ics_url = committee_event_upcoming_url( :format => 'ics' )
  end
  
  def oral_evidence_transcripts
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @oral_evidence_transcripts = @committee.oral_evidence_transcripts
    @alternate_title = "Oral evidence transcripts for the #{@committee.name}"
    @rss_url = committee_oral_evidence_transcripts_url( :format => 'rss' )
  end
  
  def publications
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @publications = @committee.publications
    @alternate_title = "Publications for the #{@committee.name}"
    @rss_url = committee_publications_url( :format => 'rss' )
  end
  
  def publication_type_list
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
    @publication_types = @committee.publication_types
  end
  
  def publication_type_show
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    publication_type = params[:publication_type]
    @publication_type = PublicationType.find_by_system_id( publication_type )
    @page_title = @committee.name
    @publications = @committee.publications_of_type( @publication_type )
    @alternate_title = "Publications for the #{@committee.name} - #{@publication_type.name}"
    @rss_url = committee_publication_type_show_url( :format => 'rss' )
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
