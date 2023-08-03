require 'import/import'

# We include code from module.
include IMPORT

task :import_all_publications => :environment do
  import_all_publications( 0 )
end