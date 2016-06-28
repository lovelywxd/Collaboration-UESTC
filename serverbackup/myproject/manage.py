#!/usr/bin/env python
import os
import sys
import logging

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "myproject.settings")

    logging.basicConfig(filename='mylog.txt', filemode='w', level=logging.INFO)

    from myapp import crawler

    crawler.start_crawler()

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
