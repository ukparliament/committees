require 'import/import'

# We include code from module.
include IMPORT

task :import_work_package_types => :environment do
  import_work_package_types
end