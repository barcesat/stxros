'------------------------------------------------------------------------------
' File:       hmAxes.prg
' Purpose:     Perform homing procedure
' Version:     1.00
' Author:      <MyFullName>
' Description:
' History:     YYYY-MM-DD  <MyShortCut>  V1.00
'              Created
'------------------------------------------------------------------------------

' module global "constants"

'import comm.lib
' module global variables


dim shared bErrorInOnError as long =0
program continue
dim lError as long
dim gA as generic axis

OnError
catch else
  sleep 10 ' to eliminate tight loop
  bErrorInOnError = 1
  continuetask hmaxes.prg
end onError
' 
semaphoreGive(semMove)
while 1
' aquire motion semaphore
  while semaphoreTake(semMove, 100) = 0 
    sleep 1
  end while
' move to new target  
  if axNewHome Then
    bErrorInOnError = 0
    if IsDebug then
      print "Reference:";axSeq;"New target:";axTarget
    end if  
    gA = systemaxis(axRef)
    try
      attach gA
      lError = homeAxis(axSeq, gA)
    catch else
      lError = errornumber
    end try  
    if IsDebug then
      print "Homing:";axSeq
    end if  
    sendResponce(axRespFileDesc,axSeq,lError)
    if 0 = lError Then
' replace    
' todo monitor home procedure in 0x6041
      while 0
        sleep bus[0].cycletime
      end while
' todo write 8 to 0x6060
    detach gA
    if IsDebug then
      print "Homing done:";axSeq
    end if  
      if bErrorInOnError then 
        sendDeferredResponce(axRespFileDesc,axSeq,errornumber)
      else
        sendDeferredResponce(axRespFileDesc,axSeq,0)
      end if 'error in on error        
    end if ' error
    axNewHome = 0
  else
    sleep 2' no new target - wait a bit  
  end if
  semaphoreGive(semMove)
end while  
  
end program ' <MyTask>.prg

function homeAxis(byval seqNum as long, gA as generic axis) as long
dim dValhandle as long
'dValhandle = PlcMotionStatusCreate
    homeAxis = 0
    try
' replace    
' todo write 6 to 0x6060
' todo start home procedure in 0x6040    
      gA.disp = 0
      gA.disp = gA.pfb
    catch else

    end try
'    PlcMotionStatusDestroy(dValhandle)
end function

