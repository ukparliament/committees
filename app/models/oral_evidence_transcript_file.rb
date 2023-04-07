class OralEvidenceTranscriptFile < ApplicationRecord
  
  belongs_to :oral_evidence_transcript
  
  def format_display
    case self.format
    when 'Html'
      format_display = 'HTML'
    when 'Pdf'
      format_display = 'PDF'
    when 'OriginalFormat'
      format_display = 'Word'
    end
    format_display
  end
  
  def format_extension
    case self.format
    when 'Html'
      format_display = 'html'
    when 'Pdf'
      format_display = 'pdf'
    when 'OriginalFormat'
      format_display = 'docx'
    end
    format_display
  end
  
  def link
    "https://committees.parliament.uk/oralevidence/#{self.oral_evidence_transcript.system_id}/#{self.format_extension}"
  end
end
