task :setup => [
  :import_committee_types,
  :import_work_package_types,
  # Sub-committees are linked to their parent committee by means of the parent_committee_id attribute.
  # We can't create a sub-committee without first creating its parent.
  # Sometimes sub-committees appear earlier in the API resultset than their parent, meaning we can't create them on first pass.
  # For that reason, we run the committee import task twice.
  :import_committees_first_run,
  :import_committees_second_run,
  :import_work_packages,
  :link_committees_to_work_packages,
  :import_events,
  :import_oral_evidence_transcripts] do
end