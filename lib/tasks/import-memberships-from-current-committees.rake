require 'import/import'

# We include code from module.
include IMPORT

task :import_memberships_from_current_committees => :environment do
  import_memberships_from_current_committees
end