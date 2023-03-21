class Department < ApplicationRecord
  
  def committees
    Committee.find_by_sql(
      "
        SELECT c.*
        FROM committees c, scrutinisings s
        WHERE c.id = s.committee_id
        AND s.department_id = #{self.id}
      "
    )
  end
end
