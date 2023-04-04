require 'import/import'

# We include code from module.
include IMPORT

task :import_oral_evidence_transcripts => :environment do
  import_oral_evidence_transcripts(0)
end