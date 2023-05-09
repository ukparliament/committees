require 'import/import'

# We include code from module.
include IMPORT

task :import_recent_oral_evidence_transcripts => :environment do
  import_recent_oral_evidence_transcripts(0)
end