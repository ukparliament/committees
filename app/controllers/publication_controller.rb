class PublicationController < ApplicationController
  
  def index
    @page_title = 'Publications'
    @publications = Publication.all.order( 'start_at desc' ) 
  end
  
  def show
    publication = params[:publication]
    @publication = Publication.find_by_system_id( publication )
    
    @publication = Publication.find_by_sql(
      "
        SELECT p.*,
          publication_type.publication_type_name,
          publication_type.publication_type_system_id,
          committee.committee_name,
          committee.committee_system_id,
          department.department_name,
          department.department_system_id,
          responded_to_publication.responded_to_publication_description,
          responded_to_publication.responded_to_publication_system_id
        FROM publications p
        LEFT JOIN (
          SELECT c.id AS committee_id, c.name AS committee_name, c.system_id AS committee_system_id
          FROM committees c
        ) as committee
        ON committee.committee_id = p.committee_id
        LEFT JOIN (
          SELECT d.id AS department_id, d.name AS department_name, d.system_id AS department_system_id
          FROM departments d
        ) as department
        ON department.department_id = p.department_id
        

        LEFT JOIN (
          SELECT p2.id AS responded_to_publication_id, p2.description AS responded_to_publication_description, p2.system_id AS responded_to_publication_system_id
          FROM publications p2
        ) as responded_to_publication
        ON responded_to_publication.responded_to_publication_id = p.responded_to_publication_id
        
        
        INNER JOIN (
          SELECT pt.id AS publication_type_id, pt.name AS publication_type_name, pt.system_id AS publication_type_system_id
          FROM publication_types pt
        ) as publication_type
        ON publication_type.publication_type_id = p.publication_type_id
        WHERE p.system_id = #{publication}
      "
    ).first
    
    
    @page_title = @publication.description
  end
end
