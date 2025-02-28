require 'import'

# We include code from module.
include Import

task :import_work_packages_for_current_committees => :environment do
  import_work_packages_for_current_committees
end