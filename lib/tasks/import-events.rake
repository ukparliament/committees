require 'import'

# We include code from module.
include Import

task :import_events => :environment do
  import_events( 0 )
end