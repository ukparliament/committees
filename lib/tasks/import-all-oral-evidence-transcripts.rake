require 'import'

# We include code from module.
include Import

task :import_all_oral_evidence_transcripts => :environment do
  import_all_oral_evidence_transcripts(0)
end