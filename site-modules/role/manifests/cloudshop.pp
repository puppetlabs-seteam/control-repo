# Cloudshop Demo: This demo demonstrates how Puppet can deploy and configure
# Microsoft SQL Server, IIS, and .NET Framework to stand up a functioning website.
class role::cloudshop {
  include ::profile::platform::baseline
  include ::profile::app::cloudshop
}
