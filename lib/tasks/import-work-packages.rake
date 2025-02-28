require 'import'

# We include code from module.
include Import

task :import_work_packages => :environment do
  import_work_packages(0)
end