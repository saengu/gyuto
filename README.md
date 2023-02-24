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

## 测试模块

```
# run module
ansible-playbook -c localhost  test_dmg.yml

# debug module
ansible-playbook -vvv -c localhost  test_dmg.yml

```

## MacOS

MacOS自带Python3，配置好环境以后即可运行。常用电脑初始化:

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


