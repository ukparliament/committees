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
  
  def contact
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
  end
  
  def work_package_list
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
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
