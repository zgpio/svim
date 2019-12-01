# -*- coding: utf-8 -*-
import os
import platform
import re
import typing
import json
from pathlib import Path
from urllib import request
import urllib
import sys
import subprocess
from subprocess import PIPE, Popen
import multiprocessing
import time
import datetime
import argparse
from pluginfo import mirror_list


'''
nightly-nvim-build-download.ps1
# Set-ExecutionPolicy RemoteSigned
Invoke-WebRequest -uri https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip -OutFile "$HOME/nvim-win64-$(Get-Date -Format 'yyyy-MM-dd').zip"
'''


def _progress(block_num, block_size, total_size):
    '''回调函数
       @block_num: 已经下载的数据块
       @block_size: 数据块的大小
       @total_size: 远程文件的大小
    '''
    sys.stdout.write('\r>> Downloading %.1f%%' % (
        float(block_num * block_size) / float(total_size) * 100.0))
    sys.stdout.flush()


def download(url, dest_dir: Path):
    try:
        # create the object, assign it to a variable
        # proxy = urllib.request.ProxyHandler({'https': 'socks5://127.0.0.1:1080'})
        # # construct a new opener using your proxy settings
        # opener = urllib.request.build_opener(proxy)
        # # install the openen on the module-level
        # urllib.request.install_opener(opener)
        # make a request
        request.urlretrieve(url , dest_dir, _progress)
    except Exception as e:
        print(f'\tError retrieving the URL:{dest_dir}, {e}')

def download_vim(replace=False):
    start_tim = datetime.datetime.now()
    print('Start time:', start_tim.strftime('%Y-%m-%d %H:%M:%S'))

    tm = time.strftime("%Y-%m-%d", time.localtime())
    # path是下载文件保存的路径
    osName = platform.system()
    path: Path = Path.home()
    dest = Path.home()
    head = r'https://github.com/neovim/neovim/releases/download/nightly'
    if osName == 'Windows':
        path = path.joinpath(f'nvim-win64-{tm}.zip')
        url = rf'{head}/nvim-win64.zip'
    elif osName == 'Linux':
        path = path.joinpath(f'nvim-{tm}.appimage')
        url = rf'{head}/nvim.appimage'
    elif osName == 'Darwin':
        path = path.joinpath(f'nvim-macos-{tm}.tar.gz')
        url = rf'{head}/nvim-macos.tar.gz'

    print(path)
    if not path.exists():
        download(url, path)
    if replace and osName == 'Darwin':
        old: Path = Path.home().joinpath('nvim-osx64')
        backup: Path = Path.home().joinpath('nvim-osx64.before')
        if old.exists():
            os.system(f'mv {old} {backup}')
        cmd = f'tar xzvf {path} -C {dest}'
        print(f'Execute cmd: {cmd}')
        os.system(cmd)

    end_tim = datetime.datetime.now()
    print('End time:', end_tim.strftime('%Y-%m-%d %H:%M:%S'))
    total_tim = end_tim - start_tim  # timedelta
    print('Total time:', str(total_tim))


submodule_list = ['YouCompleteMe',
                  'YouCompleteMe/third_party/ycmd',
                  'YouCompleteMe/third_party/ycmd/third_party/OmniSharpServer',
                  'python-mode',
                  ]


# TODO: apply patch
def install_ycm_pymode():
    base_dir = Path('../.cache/dein/repos/local').resolve()
    os.system(
        f'git clone https://gitee.com/vpr/YouCompleteMe {base_dir}/YouCompleteMe')
    os.system(
        f'git clone https://gitee.com/vpr/python-mode {base_dir}/python-mode')
    for sub in submodule_list:
        path, url = [], []
        fn = base_dir.joinpath(sub, '.gitmodules')
        print(f'>>>>>>>>>>>>>>>>>>>>{sub}<<<<<<<<<<<<<<<<<<<<')
        with open(fn, 'r') as f:
            for line in f:
                # line = line.strip()
                matchObj = re.match(r'\s*(.*) = (.*)', line, re.M | re.I)
                if matchObj:
                    # print(f"matchObj.group(1) : {matchObj.group(1)},  group(2): {matchObj.group(2)}")
                    if matchObj.group(1) == 'path':
                        path.append(matchObj.group(2))
                    elif matchObj.group(1) == 'url':
                        tmp = f"https://gitee.com/vpr/{matchObj.group(2).split('/')[-1]}"
                        url.append(tmp)

        for p, u in zip(path, url):
            at = subprocess.Popen(
                [f'git -C {base_dir}/{sub} submodule status {p}'], stdout=subprocess.PIPE, shell=True).communicate()
            at = bytes.decode(at[0])
            matchObj = re.match(r'\-(.*) (.*).*', at, re.M | re.I)
            print(f"matchObj.group(1) : {matchObj.group(1)}")
            at = matchObj.group(1)
            cmd = f'git clone {u} {base_dir}/{sub}/{p}'
            print(cmd)
            os.system(cmd)
            os.system(f'git -C {base_dir}/{sub}/{p} checkout {at}')
            # print(p, u)
        # print(path, url)
    for sub in submodule_list:
        print(sub)
        os.system(f'git -C {base_dir}/{sub} status')

    os.system(f'python {base_dir}/YouCompleteMe/install.py --clang-completer')


# 优先使用nvim
_alias_vim_cmd = """tee -a ~/.zshrc <<< '
if type nvim > /dev/null 2>&1; then
    alias vim="nvim"
fi
'"""
def vim_deps_install():
    """Install Vim and dependence."""
    ostype = platform.system()
    # TODO: 细化系统发行版
    if ostype == 'Linux':
        # TODO: 使用nvim.appimage
        os.system('sudo pacman --noconfirm -S the_silver_searcher')
        os.system('sudo pacman --noconfirm -S ctags')
        os.system('sudo pacman --noconfirm -S clang')
        os.system('sudo pacman --noconfirm -S cmake')
        os.system('sudo pacman --noconfirm -S python-pip')
        os.system('sudo pacman --noconfirm -S neovim')
        os.system('sudo pacman --noconfirm -S xclip')
        os.system('pip install --user pynvim')
        os.system('pip install --user yapf')
        # 清空垃圾箱 rm -rf /home/zgp/.local/share/Trash/
        os.system('pip install --user send2Trash')
        os.system('ln -s ~/.vim  ~/.config/nvim')

        os.system(_alias_vim_cmd)
    elif ostype == 'Darwin':
        # TODO: install python3
        os.system('brew install python3')
        # https://mirror.tuna.tsinghua.edu.cn/help/homebrew/
        os.system('brew install wget')
        os.system('brew install the_silver_searcher')
        os.system('brew install clang-format')
        # https://github.com/universal-ctags/homebrew-universal-ctags
        # TODO: 下载太慢
        # os.system('brew install --HEAD universal-ctags/universal-ctags/universal-ctags')
        os.system('brew install ctags')

        # 提示 /Users/zgp/Library/Python/3.7/bin is not on PATH
        os.system('pip3 install --upgrade --user autopep8')
        os.system('pip3 install --user pynvim')
        os.system('pip3 install --user send2Trash')

        # remove soft link to vim
        # rm /usr/bin/vi
        # ln -s ~/nvim-osx64/bin/nvim  /usr/bin/vi
        # NOTE brew install vim -> /usr/local/bin/vim

        # TODO 清除默认安装的vim, 待修改
        # rm /usr/bin/vim /usr/bin/ex /usr/bin/rvim /usr/bin/rview /usr/bin/view /usr/bin/vimdiff /usr/bin/vimtutor
        # rm -rf /usr/share/vim/

        # Pre-built archives
        # curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
        # tar xzf nvim-macos.tar.gz
        # ./nvim-osx64/bin/nvim

        # brew install --HEAD neovim


# TODO: 未完成
def update_gitee_mirror_repo():

    cmd = "curl -X GET --header 'Content-Type: application/json;charset=UTF-8' 'https://gitee.com/api/v5/users/zgpio/repos?type=all&sort=full_name&page=1&per_page=100'"  # 可以直接在命令行中执行的命令
    r = os.popen(cmd)
    info = r.readlines()[0]  # 读取命令行的输出到一个list
    info: str
    # info = info.strip('\r\n')
    # for line in info:  # 按行遍历
    #     line = line.strip('\r\n')
    #     print(line)

    print(info)
    conf = json.loads(info)
    for k in conf:
        if k['description'] == 'Mirror':
            print(k['full_name'])


def update_repo(uri: str, branch):
    # TODO: git repo 完整性检查
    user, name = uri.split('/')
    des = f'~/Documents/dev/{name}'
    cmd1 = f'git clone -b {branch} https://gitee.com/zgpio/{name} {des}'
    cmd2 = f'git -C {des} remote add upstream https://github.com/{uri}.git'
    cmd3 = f'git -C {des} pull upstream {branch}'
    cmd4 = f'git -C {des} push origin {branch}'
    rev = f'git -C {des} rev-parse HEAD'

    p1 = Popen(cmd1, stdout=PIPE, stderr=PIPE, shell=True)
    p1.wait()

    p0 = Popen(rev, stdout=PIPE, stderr=PIPE, shell=True)
    p0.wait()
    pre = p0.stdout.read()

    p2 = Popen(cmd2, stdout=PIPE, stderr=PIPE, shell=True)
    p2.wait()

    p3 = Popen(cmd3, stdout=PIPE, stderr=PIPE, shell=True)
    p3.wait()

    p4 = Popen(cmd4, stdout=PIPE, stderr=PIPE, shell=True)
    p4.wait()

    p5 = Popen(rev, stdout=PIPE, stderr=PIPE, shell=True)
    p5.wait()
    after = p5.stdout.read()
    # print(pre, after)
    if pre != after:
        print(f'{uri:>40} update')

def update(mirror_list):
    # Single process (one by one) Total time: 294s
    # Multi process Total time: 103s
    start_tim = datetime.datetime.now()
    print('Start time:', start_tim.strftime('%Y-%m-%d %H:%M:%S'))
    pool = multiprocessing.Pool(processes = 4)

    for plug in mirror_list:
        uri = plug.uri
        branch = plug.rev
        # 维持执行的进程总数为processes, 当一个进程执行完毕后会添加新的进程进去
        pool.apply_async(update_repo, (uri, branch, ))

    print("~"*40)
    pool.close()
    # 调用join之前, 先调用close函数, 否则会出错.
    # 执行完close后不会有新的进程加入到pool, join函数等待所有子进程结束
    pool.join()
    print("~"*40)

    print("Sub-process(es) done.")

    end_tim = datetime.datetime.now()
    print('End time:', end_tim.strftime('%Y-%m-%d %H:%M:%S'))
    total_tim = end_tim - start_tim  # timedelta
    print('Total time:', str(total_tim))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Install Scripts')
    parser.add_argument('--uri', type=str, nargs='+', help='specific update uri')
    parser.add_argument('-d', '--download-vim', action='store_true', default=False,
                        help='download nvim from release.')
    parser.add_argument('-r', action='store_true', default=False,
                        help='Replace nvim.')
    parser.add_argument('--deps', action='store_true', default=False)
    args = parser.parse_args()
    # TODO: 导出
    # install_ycm_pymode()

    # NOTE: Cannot use abbr
    if args.download_vim and args.r:
        download_vim(replace=True)
    elif args.download_vim:
        download_vim()
    elif args.deps:
        vim_deps_install()
    else:
        if args.uri:
            mirror_list = [i for i in mirror_list if i.uri in args.uri]
            _ = [i.uri for i in mirror_list]
            # print(args.uri)
            print(_)

        update(mirror_list)
