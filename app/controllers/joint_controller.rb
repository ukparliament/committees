class JointController < ApplicationController
  
  def index
    @page_title = 'All joint committees'
    
    @committees = Committee.find_by_sql(
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id

        LEFT JOIN (
          SELECT ch.committee_id as committee_id, COUNT(ch.id) AS house_count
          FROM committee_houses ch
          GROUP BY ch.committee_id
        ) parliamentary_house_count
        ON c1.id = parliamentary_house_count.committee_id
        
        WHERE c1.parent_committee_id is null
        AND parliamentary_house_count.house_count > 1
        ORDER BY c1.name;
      "
    )
  end
  
  def current
    @page_title = 'Current joint committees'
    
    @committees = Committee.find_by_sql(
      "
        SELECT c1.*, sub_committees.sub_committee_count
        FROM committees c1
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id

        LEFT JOIN (
          SELECT ch.committee_id as committee_id, COUNT(ch.id) AS house_count
          FROM committee_houses ch
          GROUP BY ch.committee_id
        ) parliamentary_house_count
        ON c1.id = parliamentary_house_count.committee_id
        
        WHERE c1.parent_committee_id is null
        AND parliamentary_house_count.house_count > 1
        AND c1.end_on is null
        ORDER BY c1.name;
      "
    )
  end
end
