# Cloudshop Demo: This demo demonstrates how Puppet can deploy and configure
# Microsoft SQL Server, IIS, and .NET Framework to stand up a live functioning website.
class role::cloudshop {
  include tse_sqlserver
  include sqlwebapp::db
  include sqlwebapp
}
