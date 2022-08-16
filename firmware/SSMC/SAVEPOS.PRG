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
  with robot
    attach
    en=0
    sleep 10
    open "lastpos.dat" mode="r" as #5
      if abs(a1.pfb) < 0.1 then
        a1.disp = -val(input$(#5))
      end if
      if abs(a2.pfb) < 0.1 then
        a2.disp = -val(input$(#5))
      end if  
      if abs(a3.pfb) < 0.1 then
        a3.disp = -val(input$(#5))
      end if
      if abs(a4.pfb) < 0.1 then
        a4.disp = -val(input$(#5))
      end if
      if abs(a5.pfb) < 0.1 then
        a5.disp = -val(input$(#5))
      end if
    close #5
    sleep 100
    detach
  end with


  finished_reading =1
  
  
  while 1=1
      open "lastpos.dat" mode="w" as #5
        print #5, a1.pfb
        print #5, a2.pfb
        print #5, a3.pfb
        print #5, a4.pfb
        print #5, a5.pfb
      close #5
      sleep 1000
  end while
end program ' <MyTask>.prg
