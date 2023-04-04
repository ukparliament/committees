class OralEvidenceSessionController < ApplicationController
  
  def index
    @page_title = 'Oral evidence sessions'
    @all_oral_evidence_sessions = all_oral_evidence_sessions
    @upcoming_oral_evidence_sessions = upcoming_oral_evidence_sessions
  end
  
  def upcoming
    @page_title = 'Oral evidence sessions'
    @all_oral_evidence_sessions = all_oral_evidence_sessions
    @upcoming_oral_evidence_sessions = upcoming_oral_evidence_sessions
  end
  
  def show
    oral_evidence_session = params[:oral_evidence_session]
    @oral_evidence_session = get_oral_evidence_session( oral_evidence_session )
    @page_title = 'Oral evidence session'
  end
  
  def all_oral_evidence_sessions
    OralEvidenceSession.find_by_sql(
      "
        SELECT oes.*
        FROM oral_evidence_sessions oes
        ORDER BY oes.start_on desc, oes.start_at desc;
      "
    )
  end
  
  def upcoming_oral_evidence_sessions
    OralEvidenceSession.find_by_sql(
      "
        SELECT oes.*
        FROM oral_evidence_sessions oes
        WHERE oes.start_at >= '#{Time.now}'
        ORDER BY oes.start_on desc, oes.start_at desc;
      "
    )
  end
  
  def get_oral_evidence_session( oral_evidence_session )
    OralEvidenceSession.find_by_sql(
      "
        SELECT oes.*
        FROM oral_evidence_sessions oes
        WHERE oes.system_id = #{oral_evidence_session}
        LIMIT 1;
      "
    ).first
  end
end
