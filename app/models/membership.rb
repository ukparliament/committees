# == Schema Information
#
# Table name: memberships
#
#  id            :integer          not null, primary key
#  end_on        :date
#  is_alternate  :boolean          default(FALSE)
#  is_co_opted   :boolean          default(FALSE)
#  is_ex_officio :boolean          default(FALSE)
#  is_lay_member :boolean          default(FALSE)
#  start_on      :date             not null
#  committee_id  :integer          not null
#  person_id     :integer          not null
#  role_id       :integer          not null
#  system_id     :integer          not null
#
# Foreign Keys
#
#  fk_committee  (committee_id => committees.id)
#  fk_person     (person_id => people.id)
#  fk_role       (role_id => roles.id)
#
class Membership < ApplicationRecord
  
  belongs_to :committee
  belongs_to :person
  belongs_to :role
  
  def lifespan
    lifespan = self.start_on.strftime( '%e %B %Y' ) + ' - '
    lifespan += self.end_on.strftime( '%e %B %Y' ) if self.end_on
    lifespan
  end
end
