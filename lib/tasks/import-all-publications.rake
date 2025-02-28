require 'import'

# We include code from module.
include Import

task :import_all_publications => :environment do
  import_all_publications( 0 )
end