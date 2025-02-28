# == Schema Information
#
# Table name: oral_evidence_transcript_files
#
#  id                          :integer          not null, primary key
#  format                      :string(255)      not null
#  name                        :string(255)      not null
#  size                        :integer          not null
#  url                         :string(1000)
#  oral_evidence_transcript_id :integer          not null
#
# Foreign Keys
#
#  fk_oral_evidence_transcript  (oral_evidence_transcript_id => oral_evidence_transcripts.id)
#
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
