from subprocess import PIPE, Popen
import multiprocessing
import datetime
import argparse
from pluginfo import mirror_list


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

def update(uri=None):
    global mirror_list
    if uri:
        mirror_list = [i for i in mirror_list if i.uri in uri]
        _ = [i.uri for i in mirror_list]
        # print(uri)
        print(_)
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
    parser = argparse.ArgumentParser(description='Update Scripts')
    parser.add_argument('--uri', type=str, nargs='+', help='specific update uri')
    args = parser.parse_args()
    update(args.uri)
