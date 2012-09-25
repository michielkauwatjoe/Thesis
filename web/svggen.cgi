#!/usr/bin/python
# Colour testing

import cgitb; cgitb.enable()
# from types import *

def main():
	import cgi
	import string
	import commands
	import os


	path = '../svggen/'
	depth = -1
	width = 1024
        height= 768

	form = cgi.FieldStorage()
	if form.has_key('program')	: program=form["program"].value
	if form.has_key('depth')	: depth=form["depth"].value
	if form.has_key('width')	: width=form["width"].value
	if form.has_key('height')	: height=form["height"].value

	cmd="/usr/local/bin/swipl -e \"['%s%s'],run_noguides_polygons(%s,%s,%s).\""%(path,program,depth,width,height)
	
	retvalue = os.system(cmd)
	fd=open('/tmp/svggen.svg')
	lines = fd.readlines()
	fd.close()
	lines="\r\n".join(lines)
	print 'Content-type: image/svg+xml\r\n'
	print lines
	print '<!-- Command: %s -->'%cmd


if __name__ == '__main__':         # Only do this when run as a script
        import sys, traceback          # Be prepared!
        try:
                main()
	except: 
		print 'Content-type: text/html\r\n'
		cgitb.handler()
