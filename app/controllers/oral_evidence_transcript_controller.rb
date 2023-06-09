class OralEvidenceTranscriptController < ApplicationController
  
  def index
    @page_title = 'Oral evidence transcripts'
    @all_oral_evidence_transcripts = all_oral_evidence_transcripts
    #@upcoming_oral_evidence_transcripts = upcoming_oral_evidence_transcripts
  end
  
  def upcoming
    @page_title = 'Oral evidence transcripts'
    #@all_oral_evidence_transcripts = all_oral_evidence_transcripts
    @upcoming_oral_evidence_transcripts = upcoming_oral_evidence_transcripts
  end
  
  def show
    oral_evidence_transcript = params[:oral_evidence_transcript]
    @oral_evidence_transcript = get_oral_evidence_transcript( oral_evidence_transcript )
    @page_title = 'Oral evidence transcript'
  end
  
  def all_oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet
        ORDER BY oet.published_on desc, oet.start_on desc;
      "
    )
  end
  
  def upcoming_oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet
        WHERE oet.published_on >= '#{Date.today}'
        ORDER BY oet.published_on desc, oet.start_on desc;
      "
    )
  end
  
  def get_oral_evidence_transcript( oral_evidence_transcript )
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet
        WHERE oet.system_id = #{oral_evidence_transcript}
        LIMIT 1;
      "
    ).first
  end
end
