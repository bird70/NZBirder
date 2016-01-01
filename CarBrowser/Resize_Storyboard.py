import re
import sys
import math

afile = sys.argv[1]

scale = 768./320.

number_pattern = '[-0-9]+(.[0-9]+)?'
#width_pattern = 'width="[-0-9]+( ?px)?"'
width_pattern = 'width="[-0-9]+(.[0-9]+)?( ?px)?"'
height_pattern = 'height="[-0-9]+(.[0-9]+)?( ?px)?"'
x_pattern = 'x="[-0-9]+(.[0-9]+)?( ?px)?"'
y_pattern = 'y="[-0-9]+(.[0-9]+)?( ?px)?"'


def replacescaledvalue(scale,pattern,sometext,replacefmt) :
    ip = re.search(pattern, sometext, re.IGNORECASE)
    if(ip) :
        np = re.search(number_pattern,ip.group(0))
        if(np) :
            val = float(np.group(0))
            val = int(math.floor(val*scale))
            sval = replacefmt+str(val)+'"'#+'px"'
            newtext = re.sub(pattern,sval,sometext)
            return newtext
    else :
        return sometext

fin = open(afile)
fout = open(afile+"_adjusted.storyboard", "wt")
for line in fin:
    newline = line
    newline = replacescaledvalue(scale,width_pattern,newline,'width="')
    newline = replacescaledvalue(scale,height_pattern,newline, 'height="')
    newline = replacescaledvalue(scale,x_pattern,newline, 'x="')
    newline = replacescaledvalue(scale,y_pattern,newline, 'y="')
#   print newline
    fout.write( newline )

fin.close()
fout.close()