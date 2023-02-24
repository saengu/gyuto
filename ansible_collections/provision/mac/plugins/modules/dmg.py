#!/usr/bin/python

from __future__ import absolute_import, division, print_function
__metaclass__ = type

# https://chromeenterprise.google/browser/download/#mac-tab
# https://support.google.com/chrome/answer/95346?hl=en&co=GENIE.Platform%3DDesktop#zippy=%2Cmac
# https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg

DOCUMENTATION = r'''
---
Inspired by:
 - https://github.com/sandstorm/macosx-with-ansible/blob/2f804cd2cb91007693931a6b1b6458573428364f/tasks/dmg-install.yml
 - https://gist.github.com/mrlesmithjr/f3c15fdd53020a71f55c2032b8be2eda
 - https://github.com/ansible/ansible/blob/652a74e0872fa3127c6df12e9ac1cbe0893d0793/lib/ansible/modules/get_url.py
module: dmg

short_description: Install application of DMG format on MacOS

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "0.1.0"

description: Install DMG file on local machine or remote server on MacOS

options:
    name:
        description: Installed application name in /Applications folder. could contains space and not required to be same name as in DMG file.
        required: true
        type: str
    path:
        description: DMG filepath on local machine
        required: false
        type: path
    url:
        description: Download url of DMG file.
        required: false
        type: str
author:
    - Haoran
notes:
    - Require either path or url.
    - Prefer path if both path and url provided.
    - Use url if path not exists and url provided.
todo:
    - support checksum.
    - force install even app already installed.
'''

EXAMPLES = r'''
# Pass in a message
# if exists will not changed
- name: Install Motrix
  dmg:
    name: Motrix
    path: ~/Downloads/Motrix-1.6.11.dmg

- name: Install Google Chrome
  dmg:
    name: Google Chrome
    path: ~/Downloads/googlechrome.dmg

- name: Install Google Chrome
  dmg:
    name: Motrix
    url: https://dl.moapp.me/https://github.com/agalwood/Motrix/releases/download/v1.6.11/Motrix-1.6.11.dmg

- name: Install multiple applications
  dmg:
    name: "{{ item.name }}"
    path: "{{ item.path }}"
  with_items:
    - { name: "Motrix", path: "~/Downloads/Motrix-1.6.11.dmg"}
    - { name: "Google Chrome", path: "~/Downloads/googlechrome.dmg"}    
'''

RETURN = r'''
no_value_returned:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
'''

import datetime
import os
import pathlib
import shutil
import tempfile
from contextlib import contextmanager

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils.six.moves.urllib.parse import urlsplit
from ansible.module_utils.urls import fetch_url, url_argument_spec

# Cannot remove below import statement otherwise raise error 'No module named 'ansible.module_utils.compat.typing'
# because The ansible.module_utils namespace is not a plain Python package: it is constructed dynamically for each task invocation, by extracting imports and resolving those matching the namespace against a search path derived from the active configuration
# from: https://docs.ansible.com/ansible/latest/dev_guide/developing_module_utilities.html


def is_url(checksum):
    """
    Returns True if checksum value has supported URL scheme, else False."""
    supported_schemes = ('http', 'https', 'ftp', 'file')

    return urlsplit(checksum).scheme in supported_schemes

def is_dmg_file(obj):
    """
    obj file-like object or filepath. find some dmg files are not use magic number
    Rerence:
    1. https://github.com/h2non/filetype.py/blob/master/filetype/types/image.py
    2. https://www.garykessler.net/library/file_sigs.html
    """
    NUM_SIGNATURE_BYTES = 10
    if isinstance(obj, str) or isinstance(obj, pathlib.PurePath):
        with open(obj, 'rb') as fp:
            buf = fp.read(NUM_SIGNATURE_BYTES)
    elif hasattr(obj, 'read'):
        if hasattr(obj, 'tell') and hasattr(obj, 'seek'):
            cursor = obj.tell()
            obj.seek(0)
            buf = obj.read(NUM_SIGNATURE_BYTES)
            obj.seek(cursor)
    else:
        return False

    return len(buf) >= 10 and buf[0] == 0x42 and buf[1] == 0x5A and buf[2] == 0x68


def execute(module, cmd, shell=False):
    # reference to https://github.com/ansible/ansible/blob/devel/lib/ansible/modules/command.py
    print("execute command: %s" % cmd)
    rc, out, err = module.run_command(cmd, use_unsafe_shell=shell)
    if rc != 0:
        module.fail_json(cmd=cmd, msg=(err or out))
    return out


def install(module, name, dmg_path, install_path):
    # reference to https://github.com/ansible/ansible/blob/devel/lib/ansible/modules/command.py
    if not os.path.exists(dmg_path):
        module.fail_json(msg="DMG file %s not exists" % dmg_path)

    # shoud use 
    #if not is_dmg_file(dmg_path):
    #    module.fail_json(msg='Invalid DMG format, filename should endswith .dmg', file=dmg_path)

    with tempfile.TemporaryDirectory() as mountpoint:
        execute(module, 'hdiutil attach %s -nobrowse -mountpoint %s' % (dmg_path, mountpoint))   
        execute(module, 'cp -aR %s/*.app "%s"' % (mountpoint, install_path), shell=True)
        execute(module, 'hdiutil detach %s' % mountpoint) 


@contextmanager
def fetch_file(module, url):
    """
    Download data from the url and store in a temporary file with context.
    Return (tempfile, absolute file path)
    """
    if not is_url(url):
        module.fail_json(msg="Invalid URL", url=url)

    start = datetime.datetime.utcnow()
    rsp, info = fetch_url(module, url)
    elapsed = (datetime.datetime.utcnow() - start).seconds

    if info['status'] == 304:
        module.fail_json(url=url, changed=False, msg=info.get('msg', ''), status_code=info['status'], elapsed=elapsed)

    # Exceptions in fetch_url may result in a status -1, the ensures a proper error to the user in all cases
    if info['status'] == -1:
        module.fail_json(msg=info['msg'], url=url, elapsed=elapsed)

    if info['status'] != 200 and not url.startswith('file:/') and not (url.startswith('ftp:/') and info.get('msg', '').startswith('OK')):
        module.fail_json(msg="Request failed", status_code=info['status'], response=info['msg'], url=url, elapsed=elapsed)

    fd, tempname = tempfile.mkstemp()
    f = os.fdopen(fd, 'wb')
    try:
        shutil.copyfileobj(rsp, f)
        yield (fd, tempname)
    except Exception as e:
        module.fail_json(msg="Fail to store or process downdloaded content: %s" % str(e), elapsed=elapsed, url=url)
    finally:
        f.close()
        os.remove(tempname)
        rsp.close()


def main():
    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=dict(
            name=dict(type='str', required=True),
            path=dict(type='path'),
            url=dict(type='str'),
            checksum=dict(type='str', default=''),
        ),
        #mutually_exclusive=[['path', 'url']],
        required_one_of=[['path', 'url']],
        supports_check_mode=True
    )    

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(msg="check mode, do nothing")

    name = module.params['name']
    path = module.params['path']
    url  = module.params['url']


    install_path = "/Applications/%s.app" % name

    # check if there is no dest file
    if os.path.exists(install_path):
        module.exit_json(msg="%s has already been installed" % name)

    if url and (not path or not os.path.exists(path)):
        # download file to tmp folder and set path
        # use path as dest if both url and path exists
        # reference https://github.com/ansible/ansible/blob/652a74e0872fa3127c6df12e9ac1cbe0893d0793/lib/ansible/modules/get_url.py#L390
        with fetch_file(module, url) as (fd, tempname):
            install(module, name, tempname, install_path)
            module.exit_json(changed=True, msg="Install %s successfully" % name, source=url)
    elif path and os.path.exists(path):
        install(module, name, path, install_path)
        module.exit_json(changed=True, msg="Install %s successfully" % name, source=path)
    else:
        module.fail_json(msg="File not exists, change path or set url as secondary option", file=path)


if __name__ == '__main__':
    main()
