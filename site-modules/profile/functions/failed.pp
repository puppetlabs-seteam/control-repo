function profile::failed(Array[Hash] $results) >> Boolean {
  $results.any |$r| { $r['_error'] }
}
