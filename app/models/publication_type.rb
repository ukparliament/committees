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
