#
# @param image_name     The name to use for the containerlab image.
# @param image_tag      The tag to use for the containerlab image.
# @param image_filename The filename of the container image to be imported.
# @param image_source   The URL to download the container image from.
# @param image_checksum_url The URL to download the checksum for the container image.
#
class profile::app::containerlab (
  String[1] $image_name         = 'ceos',
  String[1] $image_tag          = '4.34.2F',
  String[1] $image_filename     = 'cEOS64-lab-4.34.2F.tar.xz',
  String[1] $image_source       = 'https://downloads.arista.com/cEOS-lab/4.34/EOS-4.34.2F/cEOS64-lab-4.34.2F.tar.xz',
  String[1] $image_checksum_url = 'https://downloads.arista.com/cEOS-lab/4.34/EOS-4.34.2F/cEOS64-lab-4.34.2F.tar.xz.sha512sum',
) {
  archive { "/tmp/${image_filename}":
    ensure      => present,
    source      => $image_source,
    digest_type => 'sha512',
    digest_url  => $image_checksum_url,
    before      => Class['containerlab'],
  }

# Apply the containerlab class with specific parameters
  class { 'containerlab':
    manage_install       => true,
    manage_image_imports => true,
    manage_topologies    => true,
    image_imports        => {
      'arista_ceos' => {
        'image_file' => "/tmp/${image_filename}",
        'image_name' => $image_name,
        'image_tag'  => $image_tag,
      },
    },
    topologies           => {
      'arista_ceos' => {
        'topology_file' => '/etc/containerlab/arista_ceos-topology.yml',
        'topology'      => {
          'name'      => 'arista',
          'kinds'     => {
            'ceos' => {
              'image' => 'ceos',
              'tag'   => '4.34.2F',
            },
          },
          'nodes'     => {
            'ceos1' => { 'kind' => 'ceos' },
            'ceos2' => { 'kind' => 'ceos' },
          },
          'endpoints' => ['ceos1:eth1', 'ceos2:eth1'],
        },
      },
    },
  }
}
