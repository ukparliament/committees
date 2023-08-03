task :topup => [
  :import_committee_types,
  :import_work_package_types,
  :import_current_committees,
  :import_work_packages_for_current_committees,
  :import_upcoming_events,
  :import_recent_oral_evidence_transcripts,
  :import_memberships_from_current_committees,
  :import_all_publication_types,
  :import_recent_publications] do
end