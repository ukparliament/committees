require 'import'

# We include code from module.
include Import

task :import_all_memberships => :environment do
  import_all_memberships
end