require 'import'

# We include code from module.
include Import

task :import_all_written_evidence => :environment do
  import_all_written_evidence(0)
end