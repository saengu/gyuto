# Role to install Sublime on MacOS

```angular2html
$ ansible-playbook test_sublime.yml -c localhost
```

```angular2html
➜ cat test_sublime.yml 
---
- name: Test sublime
  hosts: all

  collections:
    provision.pkg

  roles:
    - sublime
```

```
cd asible_collections/provision/pkg
# or 
cd asible_collections/provision/pkg/roles
ansible localhost -m include_role -a name=sublime
``` 
inspired by
#  - https://github.com/feffi/ansible-macos-sublime