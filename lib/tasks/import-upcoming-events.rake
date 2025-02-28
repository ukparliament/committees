require 'import'

# We include code from module.
include Import

task :import_upcoming_events => :environment do
  import_upcoming_events( 0 )
end