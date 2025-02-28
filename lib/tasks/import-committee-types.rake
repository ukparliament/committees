require 'import'

# We include code from module.
include Import

task :import_committee_types => :environment do
  import_committee_types
end