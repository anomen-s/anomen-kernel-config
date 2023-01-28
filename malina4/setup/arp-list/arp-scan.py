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
    parser.add_argument("-d", "--db", default=DB_FILE, type=str, required=False, help="DB file")

    parser.add_argument("-m", "--mapping", type=str, required=False, help="add MAC address mapping")

    parser.add_argument("-p", "--prefix", type=str, required=False, help="Address prefix")
    parser.add_argument("-t", "--text", type=bool, required=False, help="Output result to stdout")
    parser.add_argument("-v", "--verbose", type=bool, required=False, help="Verbose output")
    parser.add_argument("-w", "--wait", type=int, required=False, default=1,
                        help="Delay between pinging different hosts")
    parser.add_argument("-W", "--wait-loop", type=int, required=False, default=1,
                        help="Delay between iterations")
    parser.add_argument("-l", "--logfile", type=str, required=False, default="/var/log/arp-scan.log",
                        help="Logging file")

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
        date text NOT NULL DEFAULT CURRENT_TIMESTAMP,
        mac text,
        ip text NOT NULL,
        state int NOT NULL
        )''')

    con.execute('''CREATE TABLE IF NOT EXISTS devices (
        mac text PRIMARY KEY,
        hostname text,
        vendor text
        )''')

    return con


def insert_device(con, mac, hostname):
    """
    Insert record into devices tables.
    """
    if hostname:
        con.execute("INSERT INTO devices (mac, hostname) VALUES (?,?)", (mac, hostname))
    else:
        con.execute("DELETE from devices WHERE mac = ?", (mac,))
    con.commit()


def insert_ping(con, mac, ip, result):
    """
    Insert record into database.
    """
    date = datetime.now().isoformat()
    con.execute("INSERT INTO ping (mac, ip, state) VALUES (?, ?, ?)", (mac, ip, int(result)))
    con.commit()


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


def process(con, args, addr):
    """
    Perform ping of single address.
    Returns boolean.
    """
    ip = args.prefix + '.' + addr
    pingres = ping(ip)
    logging.info(str([ip, pingres]))
    mac = get_arp(ip)
    insert_ping(con, mac, ip, pingres)
    return pingres


def get_arp(addr):
    """
    Load arp list from kernel file
    """
    with open('/proc/net/arp', 'r') as f:
        r = [l.split()[3] for l in f.readlines() if l[:len(addr)].lower() == addr.lower()]
        return r[0] if r and (r[0] != '00:00:00:00:00:00') else None


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


def perform_scan(args, con):
    """
    Perform scan of all addresses.
    """
    isfirst = [True]

    def f(a):
        if not isfirst[0]:
            time.sleep(args.wait)
        isfirst[0] = True
        return process(con, args, a)

    r = [f(a) for a in compute_addresses(args.addresses)]
    return r


def add_device(con, args):
    mac = args.mapping.upper().replace('-', ':')
    hostname = next(iter(args.addresses))
    m = re.match("^[A-F0-9]{2}:[A-F0-9]{2}:[A-F0-9]{2}:[A-F0-9]{2}:[A-F0-9]{2}:[A-F0-9]{2}$", mac)
    if not m:
        raise Exception("Invalid mac address: " + mac)
    insert_device(con, mac, hostname)


def update_vendors(con, filename):
    # read all prefixes
    # scan OUI db
    # for each
    #   con.execute("UPDATE devices SET vendor=? WHERE substring(mac, 1, 8) = ?", (vendor, mac_prefix))
    con.commit()


def main():
    """
    Main method
    """
    logging.basicConfig(filename='arp-list.log', level=logging.DEBUG)
    args = parseArguments()
    logging.info(args)
    conn = dbconnect()
    if args.mapping:
        add_device(conn, args)
    else:
        logging.info(args.prefix)
        r = perform_scan(args, conn)
        logging.debug('scanning result: %s' % r)


if __name__ == '__main__':
    main()
