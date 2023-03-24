task :setup => [
  :import_committee_types,
  :import_committees,
  :import_work_package_types,
  :import_work_packages] do
end