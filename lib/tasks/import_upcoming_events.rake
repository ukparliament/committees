require 'import/import'

# We include code from module.
include IMPORT

task :import_upcoming_events => :environment do
  import_upcoming_events( 0 )
end