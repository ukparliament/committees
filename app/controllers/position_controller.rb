class PositionController < ApplicationController
  
  def index
    @page_title = 'Positions'
    @positions = Position.find_by_sql(
      "
        SELECT p.*, organisation.organisation_name AS organisation_name, witness.oral_evidence_transcript_count AS oral_evidence_transcript_count
        FROM positions p
        
        INNER JOIN (
          SELECT o.id as organisation_id, o.name as organisation_name
          FROM organisations o
        ) organisation
        ON organisation.organisation_id = p.organisation_id
        
        INNER JOIN (
          SELECT wp.position_id AS position_id, COUNT(oet.id) AS oral_evidence_transcript_count
          FROM witnesses w, oral_evidence_transcripts oet, witness_positions wp
          WHERE w.oral_evidence_transcript_id = oet.id
          AND w.id = wp.witness_id
          GROUP BY wp.position_id
        ) witness
        ON witness.position_id = p.id
        
        ORDER BY organisation.organisation_name, p.name
      "
    )
  end
  
  def show
    position = params[:position]
    @position = Position.find_by_sql(
      "
        SELECT p.*, o.name AS organisation_name
        FROM positions p, organisations o
        WHERE p.organisation_id = o.id
        AND p.id = #{position}
      "
    ).first
    @page_title = "#{@position.name} - #{@position.organisation_name}"
    @alternate_title = "Oral evidence transcripts for #{@position.name} - #{@position.organisation_name}"
    @rss_url = position_oral_evidence_transcripts_url( :format => 'rss' )
    @witnesses = @position.witnesses
  end
  
  def oral_evidence_transcripts
    position = params[:position]
    @position = Position.find_by_sql(
      "
        SELECT p.*, o.name AS organisation_name
        FROM positions p, organisations o
        WHERE p.organisation_id = o.id
        AND p.id = #{position}
      "
    ).first
    @alternate_title = "Oral evidence transcripts for #{@position.name} - #{@position.organisation_name}"
    @rss_url = position_oral_evidence_transcripts_url( :format => 'rss' )
    

    respond_to do |format|
      format.html {
        @witnesses = @position.witnesses
      }
      format.rss {
        @oral_evidence_transcripts = @position.oral_evidence_transcripts_limited
      }
    end
  end
end
