#!/usr/bin/python3
print("Content-Type: text/html")
import cgi
import subprocess


print()

mydata  = cgi.FieldStorage()

info  = mydata.getvalue("info")


cmd = subprocess.getoutput("sudo "+ info)


print(cmd)
