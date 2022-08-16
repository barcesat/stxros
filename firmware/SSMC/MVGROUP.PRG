'------------------------------------------------------------------------------
' File:        mvgroup.prg
' Purpose:     Move group server
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
dim gG as generic group

OnError
catch else
  sleep 10 ' to eliminate tight loop
  bErrorInOnError = 1
  continuetask mvgroup.prg
end onError
' 
semaphoreGive(semMove)
while 1
' aquire motion semaphore
  while semaphoreTake(semMove, 100) = 0 
    sleep 1
  end while
' move to new target  
  if grNewTarget Then
    bErrorInOnError = 0
    if IsDebug then
      print "Reference:";axSeq;" New target:";grTarget[1],grTarget[2],grTarget[3]
    end if  
    try
      gG = systemgroup(axRef)
    catch else
      lError = errornumber
    end try  
    try
      attach gG
      lError = mvGroup(axSeq, gG, grTarget, grVel, grAbs,grMoveType)
    catch else
      lError = errornumber
    end try  
    if IsDebug then
      print "Reference:";axSeq;" New target ack/nak:";grTarget[1],grTarget[2],grTarget[3];" Error:";lError
    end if  
    sendResponce(axRespFileDesc,axSeq,lError)
    if 0 = lError Then
      while gG.ismoving
        sleep bus[0].cycletime/1000
      end while
    detach gG
    if IsDebug then
      print "Reference:";axSeq;"target executed:";grTarget[1],grTarget[2],grTarget[3];" Error:";errornumber
    end if  
      if bErrorInOnError then 
        sendDeferredResponce(axRespFileDesc,axSeq,errornumber)
      else
        sendDeferredResponce(axRespFileDesc,axSeq,0)
      end if 'error in on error        
    end if ' error
    grNewTarget = 0
  else
    sleep 2' no new target - wait a bit  
  end if
  semaphoreGive(semMove)
end while  
  
end program ' <MyTask>.prg

function mvGroup(byval seqNum as long, gG as generic group, dPos[*] as double, byval dValVelocity as double, byval absl as long,byval lMvType as long) as long
dim dValhandle as long
dim pnt as generic location
dim jnt as generic joint
dim iNumJnt as long
'dValhandle = PlcMotionStatusCreate
' try to cast point to generic location
    iNumJnt =  SystemGroup(gG.ElementID).ElementSize
    select case iNumJnt
      case 1
      pnt =  CASTPOINT(#{dPos[1]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      jnt =  CASTPOINT({dPos[1]}, RobotType(SystemGroup(gG.ElementID).setpoint)) 
      case 2
      pnt =  CASTPOINT(#{dPos[1],dPos[2]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      jnt = CASTPOINT({dPos[1],dPos[2]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      case 3
      pnt =  CASTPOINT(#{dPos[1],dPos[2],dPos[3]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      jnt = CASTPOINT({dPos[1],dPos[2],dPos[3]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      case 4
      pnt =  CASTPOINT(#{dPos[1],dPos[2],dPos[3],dPos[4]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      jnt = CASTPOINT({dPos[1],dPos[2],dPos[3],dPos[4]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      case 5
      pnt =  CASTPOINT(#{dPos[1],dPos[2],dPos[3],dPos[4],dPos[5]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      jnt = CASTPOINT({dPos[1],dPos[2],dPos[3],dPos[4],dPos[5]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      case 6
      pnt =  CASTPOINT(#{dPos[1],dPos[2],dPos[3],dPos[4],dPos[5],dPos[6]}, RobotType(SystemGroup(gG.ElementID).setpoint))
      jnt = CASTPOINT({dPos[1],dPos[2],dPos[3],dPos[4],dPos[5],dPos[6]}, RobotType(SystemGroup(gG.ElementID).setpoint))
    end select  
    mvGroup = 0
    try
      select case lMvType
        case 2
          if IsDebug then 
            print "Move ";iNumJnt;" dof ";iNumJnt
          end if
          Move gG  pnt VelocityCruise=dValVelocity abs = absl 'PlcMotionStatus=dValhandle
        case 3
          if IsDebug then 
            print "MoveS ";iNumJnt;" dof ";iNumJnt
          end if
          MoveS gG pnt Vtran=dValVelocity abs = absl 'PlcMotionStatus=dValhandle
        case 4
          if IsDebug then 
            print "Move ";iNumJnt;" dof ";iNumJnt
          end if
          Move gG  jnt VelocityCruise=dValVelocity abs = absl 'PlcMotionStatus=dValhandle
        case 5
          if IsDebug then 
            print "MoveS ";iNumJnt;" dof ";iNumJnt
          end if
          MoveS gG jnt Vtran=dValVelocity abs = absl 'PlcMotionStatus=dValhandle
      end select        
    catch else
      mvGroup = user USR_GET_RECENT_ERROR(1,2,3)
    end try
'    PlcMotionStatusDestroy(dValhandle)
end function

