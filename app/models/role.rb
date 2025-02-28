# == Schema Information
#
# Table name: roles
#
#  id        :integer          not null, primary key
#  is_chair  :boolean          default(FALSE)
#  name      :string(255)
#  system_id :integer          not null
#
class Role < ApplicationRecord
  
  def all_memberships
    Membership.find_by_sql(
      "
        SELECT m.*, p.name AS person_name, c.name AS committee_name, c.system_id AS committee_system_id
        FROM memberships m, people p, committees c
        WHERE m.person_id = p.id
        AND m.committee_id = c.id
        AND m.role_id = #{self.id}
        ORDER BY m.start_on, m.end_on, person_name
      "
    )
  end
  
  def current_memberships
    Membership.find_by_sql(
      "
        SELECT m.*, p.name AS person_name, c.name AS committee_name, c.system_id AS committee_system_id
        FROM memberships m, people p, committees c
        WHERE m.person_id = p.id
        AND m.committee_id = c.id
        AND m.role_id = #{self.id}
        AND ( m.end_on IS NULL OR m.end_on > '#{Date.today}' )
        ORDER BY m.start_on, m.end_on, person_name
      "
    )
  end
end
