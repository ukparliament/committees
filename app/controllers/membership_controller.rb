class MembershipController < ApplicationController
  
  def index
    @page_title = 'Memberships'
    @all_memberships = all_memberships
    @current_memberships = current_memberships
  end
  
  def current
    @page_title = 'Memberships'
    @all_memberships = all_memberships
    @current_memberships = current_memberships
  end
  
  def show
    membership = params[:membership]
    @membership = Membership.find_by_sql(
      "
        SELECT m.*, p.name AS person_name, c.name AS committee_name, c.system_id AS committee_system_id, r.name AS role_name
        FROM memberships m, people p, committees c, roles r
        WHERE m.id = '#{membership}'
        AND m.person_id = p.id
        AND m.committee_id = c.id
        AND m.role_id = r.id
      "
    ).first
    @page_title = "#{@membership.person_name} - #{@membership.committee_name}"
  end
  
  def all_memberships
    Membership.find_by_sql(
      "
        SELECT m.* , c.system_id AS committee_system_id, c.name AS committee_name, p.name AS person_name, r.name AS role_name
        FROM memberships m, people p, committees c, roles r
        WHERE m.person_id = p.id
        AND m.committee_id = c.id
        AND m.role_id = r.id
        ORDER BY m.start_on, m.end_on, p.name
      "
    )
  end
  
  def current_memberships
    Membership.find_by_sql(
      "
        SELECT m.* , c.system_id AS committee_system_id, c.name AS committee_name, p.name AS person_name, r.name AS role_name
        FROM memberships m, people p, committees c, roles r
        WHERE m.person_id = p.id
        AND m.committee_id = c.id
        AND m.role_id = r.id
        AND ( m.end_on IS NULL OR m.end_on > '#{Date.today}' )
        ORDER BY m.start_on, m.end_on, p.name
      "
    )
  end
end
