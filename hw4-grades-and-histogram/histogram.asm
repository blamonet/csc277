.MODEL  small
.STACK  100h
.DATA
space   db   10,13,'$'
.code
	PUBLIC histogram
     histogram   PROC

histo:
          mov      ah,9
          int      21h
          loop      histo
          lea      dx,space
          mov      ah,9
          int      21h
     ret
     histogram   ENDP
END
