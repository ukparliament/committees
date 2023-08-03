require 'import/import'

# We include code from module.
include IMPORT

task :import_recent_publications => :environment do
  import_recent_publications(0)
end