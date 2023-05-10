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
