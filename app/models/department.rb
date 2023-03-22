class Department < ApplicationRecord
  
  def committees
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
        
        INNER JOIN (
          SELECT s.committee_id as committee_id
          FROM scrutinisings s
          WHERE s.department_id = #{self.id}
        ) scrutiny
        ON c1.id = scrutiny.committee_id
        
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
        
        LEFT JOIN (
          SELECT c2.parent_committee_id, count(c2.id) as sub_committee_count
          FROM committees c2
          GROUP BY c2.parent_committee_id
        ) sub_committees
        ON c1.id = sub_committees.parent_committee_id
        
        INNER JOIN (
          SELECT s.committee_id as committee_id
          FROM scrutinisings s
          WHERE s.department_id = #{self.id}
        ) scrutiny
        ON c1.id = scrutiny.committee_id
        
        WHERE c1.end_on is null
        AND c1.parent_committee_id is null
        ORDER BY c1.name;
      "
    )
  end
end
