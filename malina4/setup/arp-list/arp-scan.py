#!/usr/bin/env python3

import argparse
import logging
import os
import re
import sqlite3
import subprocess
import time
from datetime import datetime

DB_FILE_PATH = '/var/lib/arp-scan'
DB_FILE_PATH = "/tmp"
DB_FILE = DB_FILE_PATH + '/scan.db'


def parseArguments():
    parser = argparse.ArgumentParser(description='ARP scan..')
    parser.add_argument("-p", "--prefix", type=str, required=True, help="Address prefix")
    parser.add_argument("-d", "--db", default=DB_FILE, type=str, required=False, help="DB file")
    parser.add_argument("-t", "--text", type=bool, required=False, help="Output result to stdout")
    parser.add_argument("-w", "--wait", type=int, required=False, default=1,
                        help="Delay between pinging different hosts")
    parser.add_argument("-l", "--logfile", type=str, required=False, default="/var/log/arp-scan.log",
                        help="Logging file")
    #    parser.add_argument('-f', dest='from', required=True, help="From")
    #    parser.add_argument('-t', dest='to', required=True, help="To")

    parser.add_argument('addresses', nargs='+', help='target addresses or ranges')

    args = parser.parse_args()
    #    if (args.add and args.remove):
    #       raise Exception('Invalid parameter usage')

    return args;


def dbconnect():
    return createdb(DB_FILE);


def createdb(filename):
    """
    Create database
    """
    os.makedirs(DB_FILE_PATH, exist_ok=True)
    if not os.path.exists(DB_FILE_PATH):
        raise Exception("DB file path does not exist")
    if not os.path.isdir(DB_FILE_PATH):
        raise Exception("DB file path is not directory")

    logging.info("Connecting to db: %s" % DB_FILE)
    con = sqlite3.connect(DB_FILE)

    con.execute('''CREATE TABLE IF NOT EXISTS ping (
        date text,
        ip text,
        result
        symbol text, qty real, price real)''')
    return con


def insert(con, ip, result):
    """
    Insert record into database.
    """
    date = datetime.now().isoformat()
    cur.execute("INSERT INTO ping VALUES (" + date + "," + ip + "," + result + ")")


def ping(host):
    """
    Returns True if host (str) responds to a ping request.
    Remember that a host may not respond to a ping (ICMP) request even if the host name is valid.
    """
    try:
        command = ['ping', '-q', '-4', '-n', '-w', '2', host]
        return subprocess.call(command, stdout=subprocess.DEVNULL) == 0
    except subprocess.CalledProcessError as e:
        print('Ping failed: ' + e)
        return False


def process(args, addr):
    """
    Perform ping of single address.
    Returns boolean.
    """
    pingres = ping(args.prefix + '.' + addr)
    logging.info(str([addr, pingres]))
    return pingres


def get_arp(addr):
    """
    Load arp list from kernel file
    """
    with open('/proc/net/arp', 'r') as f:
        r = [l.split()[3] for l in f.readlines() if l[:len(addr)].lower() == addr.lower()]
        return r[0] if r else None


def arp_list_call():
    """
    Returns arp list
    """
    try:
        command = ['arp', '-n', 'e']
        result = subprocess.check_output(command)

    except subprocess.CalledProcessError as e:
        return {}

    table = result.decode("utf-8").strip()


def compute_addresses(args):
    logging.debug(f"address list: {args}")
    for a in args:
        if re.match('^[0-9]+$', a):
            yield a
            continue
        rng = re.match('^([0-9]+)-([0-9]+)$', a)
        if rng:
            for i in range(int(rng[1]), int(rng[2]) + 1):
                yield str(i)
            continue
        raise Exception('Invalid value: %s ' % a)


def perform_scan(args):
    """
    Perform scan of all adresses.
    """
    isfirst = [True]

    def f(a):
        if not isfirst[0]:
            time.sleep(args.wait)
        isfirst[0] = True
        process(args, a)

    r = [f(a) for a in compute_addresses(args.addresses)]
    return r


def main():
    """
    Main method
    """
    logging.basicConfig(filename='arp-list.log', level=logging.DEBUG)
    args = parseArguments()
    logging.info(args)
    dbconnect()
    logging.info(args.prefix)
    r = perform_scan(args)
    logging.debug('scanning result: %s' % r)


if __name__ == '__main__':
    main()
