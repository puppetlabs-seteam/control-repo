function role::require_kernel(
  String[1] $kernel,
) {

  if $::facts['kernel'] != $kernel {
    fail('Unsupported OS!')
  }

}
