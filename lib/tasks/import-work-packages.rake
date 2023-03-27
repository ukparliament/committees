require 'import/import'

# We include code from module.
include IMPORT

task :import_work_packages => :environment do
  import_work_packages(0)
end