require 'import/import'

# We include code from module.
include IMPORT

task :link_committees_to_work_packages => :environment do
  link_committees_to_work_packages
end