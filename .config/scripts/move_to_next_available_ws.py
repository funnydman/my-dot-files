#!/usr/bin/python
import sys
from i3ipc import Connection, Event

i3 = Connection()

next_num = next(i for i in range(1, 100) if not [ws for ws in i3.get_workspaces() if int(ws.name) == i])

i3.command(f'workspace number {next_num}; exec code {sys.argv[1]}')
