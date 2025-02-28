require 'import'

# We include code from module.
include Import

task :import_work_package_types => :environment do
  import_work_package_types
end