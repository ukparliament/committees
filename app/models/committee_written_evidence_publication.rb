# == Schema Information
#
# Table name: committee_written_evidence_publications
#
#  id                              :integer          not null, primary key
#  committee_id                    :integer          not null
#  written_evidence_publication_id :integer          not null
#
# Foreign Keys
#
#  fk_committee                     (committee_id => committees.id)
#  fk_written_evidence_publication  (written_evidence_publication_id => written_evidence_publications.id)
#
class CommitteeWrittenEvidencePublication < ApplicationRecord
  
  belongs_to :committee
  belongs_to :written_evidence_publication
end
