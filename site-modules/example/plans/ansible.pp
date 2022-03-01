plan example::ansible (
  TargetSpec $ansible_host,
  Enum['nix_playbook.yml', 'win_playbook.yml'] $playbook_file,
  Enum['nix_inventory.yml', 'win_inventory.yml'] $inventory_file,
  Boolean $with_facts = true
){
  upload_file("ansible/${playbook_file}", "/root/${playbook_file}", $ansible_host)
  upload_file("ansible/${inventory_file}", '/etc/ansible/hosts', $ansible_host)
  $result = run_playbook("/root/${playbook_file}", $ansible_host, 'with_facts' => $with_facts)

  out::message($result)
}
