# Gyuto

Gyuto即牛刀，非杀鸡焉用牛刀的牛刀，而是日本料理中从西式主厨刀演化而来的多功能厨刀。

本项目是使用ansible以及其他工具完成对日常使用的电脑的配置维护，确保在新电脑上能够快速配置好常用工具，与原来的电脑有一样的使用体验。


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

## collection说明
```
.
└── provision
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

## MacOS

MacOS自带Python3，Ensure Apple's command line tools are installed (xcode-select --install to launch the installer). 配置好环境以后即可运行。常用电脑初始化:

```
$ ansible-playbook provision.mac.bootstrap -c localhost
```

## 数据备份

```
$ ansible-playbook provision.mac.backup -e "dest=2023.01.01.tar.gz" -c localhost
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
