require 'import'

# We include code from module.
include Import

task :import_all_publication_types => :environment do
  import_all_publication_types
end