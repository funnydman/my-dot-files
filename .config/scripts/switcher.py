#!/usr/bin/python
import argparse
import sys

# too slow?

from i3ipc import Connection

parser = argparse.ArgumentParser()
parser.add_argument('--name', type=str, help='name of the scratchpad', required=True)
args = parser.parse_args()

i3 = Connection()

programs = ['TelegramDesktop', 'Skype']

prog_name = vars(args)['name']

scratchpad_windows = [leaf.window_class for leaf in i3.get_tree().scratchpad().leaves()]

if __name__ == '__main__':
    if prog_name not in programs:
        print('unknown program name')
        sys.exit(0)

    if prog_name in scratchpad_windows:
        # show prog name
        programs.remove(prog_name)
        for name in programs:
            i3.command(f'[class="{name}"] move scratchpad')
        i3.command(f'[class="{prog_name}"] scratchpad show')
    else:
        i3.command(f'[class="{prog_name}"] move scratchpad')

