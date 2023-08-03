require 'import/import'

# We include code from module.
include IMPORT

task :import_all_written_evidence => :environment do
  import_all_written_evidence(0)
end