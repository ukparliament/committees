require 'import'

# We include code from module.
include Import

task :import_committees_second_run => :environment do
  import_committees( 0 )
end