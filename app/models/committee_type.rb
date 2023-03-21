class CommitteeType < ApplicationRecord
  
  belongs_to :category
  
  def committees
    Committee.find_by_sql(
      "
        SELECT c.*
        FROM committees c, committee_committee_types cct
        WHERE c.id = cct.committee_id
        AND cct.committee_type_id = #{self.id}
      "
    )
  end
  
  def current_committees
    Committee.find_by_sql(
      "
        SELECT c.*
        FROM committees c, committee_committee_types cct
        WHERE c.id = cct.committee_id
        AND cct.committee_type_id = #{self.id}
        AND c.end_on < '#{Date.today}'
      "
    )
  end
end
