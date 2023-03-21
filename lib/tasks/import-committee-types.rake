require 'import/import'

# We include code from module.
include IMPORT

task :import_committee_types => :environment do
  import_committee_types
end