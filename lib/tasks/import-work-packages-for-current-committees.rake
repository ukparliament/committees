require 'import/import'

# We include code from module.
include IMPORT

task :import_work_packages_for_current_committees => :environment do
  import_work_packages_for_current_committees
end