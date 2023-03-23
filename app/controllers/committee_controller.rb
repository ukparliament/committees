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
  
  def all_committees
    Committee.find_by_sql(
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id
        WHERE c1.end_on is null
        ORDER BY c1.name;
      "
    )
  end
  
  def current_committees
    Committee.find_by_sql(
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id
        WHERE c1.end_on is null
        AND c1.parent_committee_id is null
        ORDER BY c1.name;
      "
    )
  end
  
  def show
    committee = params[:committee]
    @committee = Committee.find_by_system_id( committee )
    @page_title = @committee.name
  end
end
