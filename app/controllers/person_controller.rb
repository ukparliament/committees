class PersonController < ApplicationController
  
  def index
    @page_title = 'People'
    @people = Person.find_by_sql(
      "
        SELECT p.*, witness.oral_evidence_transcript_count AS oral_evidence_transcript_count
        FROM people p
        
        INNER JOIN (
          SELECT w.person_id AS person_id, COUNT(oet.id) AS oral_evidence_transcript_count
          FROM witnesses w, oral_evidence_transcripts oet, people p
          WHERE w.oral_evidence_transcript_id = oet.id
          AND w.person_id = p.id
          GROUP BY w.person_id
        ) witness
        ON witness.person_id = p.id
        
        ORDER BY p.name
      "
    )
  end
  
  def members
    @page_title = 'People'
    @people = Person.find_by_sql(
      "
        SELECT p.*, witness.oral_evidence_transcript_count AS oral_evidence_transcript_count
        FROM people p
        
        INNER JOIN (
          SELECT w.person_id AS person_id, COUNT(oet.id) AS oral_evidence_transcript_count
          FROM witnesses w, oral_evidence_transcripts oet, people p
          WHERE w.oral_evidence_transcript_id = oet.id
          AND w.person_id = p.id
          GROUP BY w.person_id
        ) witness
        ON witness.person_id = p.id
        
        WHERE p.mnis_id IS NOT null
        
        ORDER BY p.name
      "
    )
  end
  
  def non_members
    @page_title = 'People'
    @people = Person.find_by_sql(
      "
        SELECT p.*, witness.oral_evidence_transcript_count AS oral_evidence_transcript_count
        FROM people p
        
        INNER JOIN (
          SELECT w.person_id AS person_id, COUNT(oet.id) AS oral_evidence_transcript_count
          FROM witnesses w, oral_evidence_transcripts oet, people p
          WHERE w.oral_evidence_transcript_id = oet.id
          AND w.person_id = p.id
          GROUP BY w.person_id
        ) witness
        ON witness.person_id = p.id
        
        WHERE p.mnis_id IS null
        
        ORDER BY p.name
      "
    )
  end
  
  def show
    person = params[:person]
    @person = Person.find( person )
    @page_title = @person.name
  end
end