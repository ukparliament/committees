require 'import/import'

# We include code from module.
include IMPORT

task :import_oral_evidence_sessions => :environment do
  import_oral_evidence_sessions(0)
end