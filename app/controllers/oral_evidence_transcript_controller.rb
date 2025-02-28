class OralEvidenceTranscriptController < ApplicationController
  
  def index
    @page_title = 'Oral evidence transcripts'
    
    @alternate_title = 'Oral evidence transcripts'
    @rss_url = oral_evidence_transcript_list_url( :format => 'rss' )
    

    respond_to do |format|
      format.html {
        @all_oral_evidence_transcripts = all_oral_evidence_transcripts
      }
      format.rss {
        @all_oral_evidence_transcripts = all_oral_evidence_transcripts_limited
      }
    end
  end
  
  def upcoming
    @page_title = 'Oral evidence transcripts'
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
  
  def all_oral_evidence_transcripts_limited
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet
        ORDER BY oet.published_on desc, oet.start_on desc
        LIMIT 20;
      "
    )
  end
  
  def upcoming_oral_evidence_transcripts
    OralEvidenceTranscript.find_by_sql(
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet
        WHERE oet.published_on >= CURRENT_DATE
        ORDER BY oet.published_on desc, oet.start_on desc;
      "
    )
  end
  
  def get_oral_evidence_transcript( oral_evidence_transcript )
    OralEvidenceTranscript.find_by_sql([
      "
        SELECT oet.*
        FROM oral_evidence_transcripts oet
        WHERE oet.system_id = ?
        LIMIT 1;
      ", oral_evidence_transcript
    ]).first
  end
end
