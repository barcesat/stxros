'------------------------------------------------------------------------------
' File:        <MyTask>.prg
' Purpose:     Just an example of a module header
' Version:     1.00
' Author:      <MyFullName>
' Description:
' History:     YYYY-MM-DD  <MyShortCut>  V1.00
'              Created
'------------------------------------------------------------------------------

' module global "constants"


' module global variables


program


while savepos.prg.state = 1
  ktas savepos.prg
end while

with a1
  attach
  disp=0
  disp=pfb
  detach
end with

with a2
  attach
  disp=0
  disp=pfb
  detach
end with

with a3
  attach
  disp=0
  disp=pfb
  detach
end with

with a4
  attach
  disp=0
  disp=pfb
  detach
end with

with a5
  attach
  disp=0
  disp=pfb
  detach
end with


open "lastpos.dat" mode="w" as #5
  print #5, 0
  print #5, 0
  print #5, 0
  print #5, 0
  print #5, 0
close #5

if savepos.prg.state = 10 then
  stas savepos.prg
end if

end program ' <MyTask>.prg
