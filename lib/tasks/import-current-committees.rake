require 'import/import'

# We include code from module.
include IMPORT

task :import_current_committees => :environment do
  import_current_committees( 0 )
end