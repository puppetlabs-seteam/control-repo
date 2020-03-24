# This is used for mocking the existence of puppetlabs-pe_concat module
# resources for tests

define pe_concat (
  $owner,
  $group,
  $force,
  $mode,
  $warn,
  $ensure_newline,
) { }
