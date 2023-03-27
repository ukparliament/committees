require 'import/import'

# We include code from module.
include IMPORT

task :import_events => :environment do
  import_events( 0 )
end