#!/usr/bin/env python
# To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.py
# In the 'bar' section.
#

import sys
import json
import requests

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()

if __name__ == '__main__':
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())
    i = 0
    while True:
        line, prefix = read_line(), ''
        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','

        j = json.loads(line)
        # insert information into the start of the json, but could be anywhere
        # CHANGE THIS LINE TO INSE
        try:
            req = requests.get("http://129.151.235.128:8080/data", timeout=3)
            data = json.loads(req.text)
            temp = float("{:.2f}".format(data["temperature"]))
            humidity = data["humidity"]
            timer = data["time"]
            j.insert(0, {'full_text' : f'T: {temp}C | H: {humidity}%', 'name' : 'gov'})
            print_line(prefix+json.dumps(j))
        except requests.exceptions.Timeout:
            j.insert(0, {'full_text' : f'Server out', 'name' : 'gov'})
            print_line(prefix+json.dumps(j))
            continue
        except requests.exceptions.ConnectionError:
            j.insert(0, {'full_text' : f'Server out', 'name' : 'gov'})
            print_line(prefix+json.dumps(j))
            continue
        # and echo back new encoded json
