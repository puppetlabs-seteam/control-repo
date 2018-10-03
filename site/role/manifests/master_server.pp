# DEPRECATED; renamed to role::seteam_puppet_master.
# This role retained temporarily for backwards compatiblity.
# Please use the role::seteam_puppet_master instead.
class role::master_server {
  contain role::seteam_puppet_master
}
