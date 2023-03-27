class JointController < ApplicationController
  
  def index
    @page_title = 'Joint committees'
    @all_committees = all_committees
    @current_committees = current_committees
  end
  
  def current
    @page_title = 'Joint committees'
    @all_committees = all_committees
    @current_committees = current_committees
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
        
        -- We only want joint committees, so we left join to committee houses to get a House count ...
        LEFT JOIN (
          SELECT ch.committee_id as committee_id, COUNT(ch.id) AS house_count
          FROM committee_houses ch
          GROUP BY ch.committee_id
        ) parliamentary_house_count
        ON c1.id = parliamentary_house_count.committee_id
        
        -- ... and only bring back committees belonging to more than one House.
        WHERE parliamentary_house_count.house_count > 1
    
        -- We only want non-sub-committees committees, so we check parent_committee_id is null.
        AND c1.parent_committee_id is null
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

        -- We only want joint committees, so we left join to committee houses to get a House count ...
        LEFT JOIN (
          SELECT ch.committee_id as committee_id, COUNT(ch.id) AS house_count
          FROM committee_houses ch
          GROUP BY ch.committee_id
        ) parliamentary_house_count
        ON c1.id = parliamentary_house_count.committee_id
        
        -- ... and only bring back committees belonging to more than one House.
        WHERE parliamentary_house_count.house_count > 1
        
        -- We only want current committees so we check for a NULL end date or an end date in the future.
        AND ( c1.end_on is NULL OR c1.end_on >= '#{Date.today}' )
        
        -- We only want non-sub-committees committees, so we check parent_committee_id is null.
        AND c1.parent_committee_id is null
        ORDER BY c1.name;
      "
    )
  end
end
