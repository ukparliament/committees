require 'import/import'

# We include code from module.
include IMPORT

task :import_all_memberships => :environment do
  import_all_memberships
end