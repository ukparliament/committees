require 'import'

# We include code from module.
include Import

task :import_current_committees => :environment do
  import_current_committees( 0 )
end