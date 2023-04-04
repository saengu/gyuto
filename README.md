# Gyuto

Gyuto即牛刀，非杀鸡焉用牛刀的牛刀，而是日本料理中从西式主厨刀演化而来的多功能厨刀。

本项目是使用ansible以及其他工具完成对日常使用的电脑的配置维护，确保在新电脑上能够快速配置好常用工具，与原来的电脑有一样的使用体验。

Inspired by:
1. https://gist.github.com/mrlesmithjr/f3c15fdd53020a71f55c2032b8be2eda

# 安装配置

项目依赖python3以及ansible。

## 创建ansible运行环境
通过隔离的venv环境来运行ansible以及其他脚本，避免污染系统的python3环境.

```
$ python3 -m venv venv
$ source venv/bin/activate.fish
(venv)$ pip install ansible 
(venv)$ pip install -r requirements.txt
```

## 安装Homebrew module (MacOS only)

```
$ ansible-galaxy collection install community.general
```
当ansible homebrew module安装好以后，可以通过homebrew 指令来安装包

```
- name: Install Package via Homebrew on MacOS
  homebrew:
    name: "{{package_name}}"
    state: present
```

如果在多个平台上安装，也可以通过package指令安装包, 前提是预先安装community.general galaxy collection

```
- name: Install Package cross-platform (include MacOS, not include Windows)
  package:
    name: "{{package_name}}"
    state: present
```

## collection说明
```
.
└── provision
    ├── machine
    │   └── playbooks           # collection下面的playbooks可以使用嵌套目录，通过namespace.collection.folder.subfolder.playbook来引用
    │       ├── home
    │       │   ├── mac.yml
    │       │   └── linux.yml
    │       ├── develop.yml
    │       └── termux.yml
    ├── mac                     # MacOS相关的module和playbook，比如DMG安装模块和新电脑初始化配置的playbook
    │   ├── README.md
    │   ├── docs
    │   ├── galaxy.yml
    │   ├── meta
    │   │   └── runtime.yml
    │   ├── playbooks           # MacOS的常用操作playbook
    │   │   ├── backup.yml
    │   │   ├── bootstrap.yml
    │   │   └── restore.yml
    │   ├── plugins
    │   │   ├── README.md
    │   │   └── modules
    │   │       └── dmg.py
    │   └── roles
    └── pkg                     # 多平台常用软件包的安装和配置，每个软件包最好要支持多个平台
        ├── README.md
        ├── docs
        ├── galaxy.yml
        ├── meta
        │   └── runtime.yml
        ├── plugins
        │   └── README.md
        └── roles               # 软件及配置
```

## 查看模块文档

```
# 查看当前可以用模块
$ ansible-doc -l provision.mac

# 查看模块文档
$ ansible-doc provision.mac
```

## 创建collection

```
$ cd ansible_collections
$ ansible-galaxy collection init provision.pkg
```

## 查看本机的facts

```
$ ansible localhost -m setup
```

## 测试模块

```
# run module
ansible-playbook -c localhost  test_dmg.yml

# debug module
ansible-playbook -vvv -c localhost  test_dmg.yml

```

# 集成测试


## 创建

```
$ cd ansible_collections/provision/pkg
$ mkdir -p tests/integration/targets/setup_abstract_service/tasks
$ touch tests/integration/targets/setup_abstract_service/tasks/main.yml
```

## 执行测试

```
$ cd ansible_collections/provision/pkg
$ ansible-test integration --local dmg
$ ansible-test integration -vvv --local dmg
```

## Role开发

```
$ mkdir ansible_collections/provision/pkg/roles/sublime
```

### Role测试
```
$ cd ansible_collections/provision/pkg
# or
$ cd ansible_collections/provision/pkg/roles

# 单独运行roles
$ ansible localhost -m include_role -a name=sublime
# or 
$ ansible all -i hosts.yml -m include_role -a "name=myrole"
```

上面命令在运行的时候是不会执行`gather_facts`, 如果安装的Role依赖`ansible_facts`可以考虑使用根目录下的`ansbible-role.sh`脚本安装

```
$ cd ansible_collections/provision/pkg
$ ../../../ansible-role.sh localhost sublime
```

或者在role的task文件中增加一个`gather_facts`的任务，如

```
- gather_facts:
  when: "'ansible_distribution' not in ansible_facts"
```

## MacOS

MacOS自带Python3，Ensure Apple's command line tools are installed (xcode-select --install to launch the installer). 配置好环境以后即可运行。常用电脑初始化:

```
$ ansible-playbook provision.mac.bootstrap -c localhost
```

## Termux
Termux需要使用ssh key进行登陆，然后ansible自带的apt和pkg无法使用，只能用shell.cmd来安装 
```
$ cd gyuto
$ ansible-playbook provision.machine.termux_develop -i "192.168.1.38:8022," -u u0_a297
```

## 数据备份

```
$ ansible-playbook provision.mac.backup -e "dest=2023.01.01.tar.gz" -c localhost
```

考虑使用ansible提供的ansible.posix.synchronize模块，该模块封装了rsync

安装ansible.posix集合
```
$ ansible-galaxy collection install ansible.posix
```

一旦使用需要把该模块放到galaxy requirements.txt文件中，以方便使用。
## 使用示例

```
# User + Key Setup
    - name: Create a new regular user with sudo privileges
      user:
        name: "{{ create_user }}"
        state: present
        groups: wheel
        append: true
        create_home: true
        shell: /bin/bash

    - name: Execute rsync command so new user has the same authorized keys as root
      ansible.posix.synchronize:
        src: /root/.ssh
        dest: /home/{{ create_user }}
      delegate_to: "{{ inventory_hostname }}"

    - name: Change .ssh file permission
      ansible.builtin.file:
        path: /home/{{ create_user }}/.ssh
        state: directory
        recurse: yes
        owner: "{{ create_user }}"
        group: "{{ create_user }}"

    - name: Set authorized key for remote user
      authorized_key:
        user: "{{ create_user }}"
        state: present
        key: "{{ copy_local_key }}"
```
## 数据恢复

```
$ ansible-playbook provision.mac.backup -e "dest=2023.01.01.tar.gz" -c localhost
```

# 目录说明

```
.
├── README.md
├── ansible.cfg
├── ansible_collections
│   └── provision
│       └── mac
│           ├── README.md
│           ├── playbooks
│           │   ├── backup.yml
│           │   ├── bootstrap.yml
│           │   └── restore.yml
│           ├── plugins
│           │   ├── README.md
│           │   └── modules
│           │       └── dmg.py
│           └── roles
├── inventory
├── playbook.yml
└── requirements.txt
```

# 常用命令


借鉴文档以及macos enable setremotelogin in cli
https://github.com/geerlingguy/mac-dev-playbook
# some thoughts
after gather facts of target machine, confirm if need to init the specific platform and ask for an environment, then include a role in playbook with for the platform and env.

roles/mac-regular
roles/mac-develop
roles/ubuntu-develop
roles/ubuntu-project

- name: Deploying application code
  hosts: uat-aegis

  roles:
    - role: roles/application_code_backup
      vars:
        backup_directory_name: "NAME"
        repo_directory: "/path/to/repo"
      when: var1 | bool
