# == Schema Information
#
# Table name: publication_types
#
#  id                     :integer          not null, primary key
#  can_be_response        :boolean          default(FALSE)
#  description            :text             not null
#  government_can_respond :boolean          default(FALSE)
#  icon_key               :string(255)
#  name                   :string(255)      not null
#  plural_name            :string(255)      not null
#  system_id              :integer          not null
#
class PublicationType < ApplicationRecord
  
  has_many :publications, -> { order( 'start_at desc' ) }
  
  def publications_limited
    Publication.find_by_sql(
      "
        SELECT *
        FROM publications
        ORDER BY start_at DESC
        LIMIT 20
      "
    )
  end
end
