# == Schema Information
#
# Table name: committee_types
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  category_id :integer          not null
#  system_id   :integer          not null
#
# Foreign Keys
#
#  fk_category  (category_id => categories.id)
#
class CommitteeType < ApplicationRecord
  
  belongs_to :category
  
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
        
        -- We only want committees of this type, so we inner join to committee committee types.
        INNER JOIN (
          SELECT cct.committee_id as committee_id
          FROM committee_committee_types cct
          WHERE cct.committee_type_id = #{self.id}
        ) committee_types
        ON c1.id = committee_types.committee_id
        
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
        
        -- We only want committees of this type, so we inner join to committee committee types.
        INNER JOIN (
          SELECT cct.committee_id as committee_id
          FROM committee_committee_types cct
          WHERE cct.committee_type_id = #{self.id}
        ) committee_types
        ON c1.id = committee_types.committee_id
        
        -- We only want current committees so we check for a NULL end date or an end date in the future.
        WHERE ( c1.end_on is NULL OR c1.end_on >= '#{Date.today}' )
        
        -- We only want non-sub-committees committees, so we check parent_committee_id is null.
        AND c1.parent_committee_id is null
        ORDER BY c1.name;
      "
    )
  end
end
