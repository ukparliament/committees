class MembershipRoleController < ApplicationController
  
  def index
    @page_title = 'Membership roles'
    @membership_roles = Role.all.order( 'name' )
  end
  
  def show
    membership_role = params[:membership_role]
    @membership_role = Role.find_by_system_id( membership_role )
    @page_title = @membership_role.name
    @all_memberships = @membership_role.all_memberships
    @current_memberships = @membership_role.current_memberships
  end
  
  def current
    membership_role = params[:membership_role]
    @membership_role = Role.find_by_system_id( membership_role )
    @page_title = @membership_role.name
    @all_memberships = @membership_role.all_memberships
    @current_memberships = @membership_role.current_memberships
  end
end
