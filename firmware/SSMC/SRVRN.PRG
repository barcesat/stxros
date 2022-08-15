'------------------------------------------------------------------------------
' File:        <MyTask>.prg
' Purpose:     Just an example of a module header
' Version:     1.00
' Author:      <MyFullName>
' Description:
' History:     YYYY-MM-DD  <MyShortCut>  V1.00
'              Created
'------------------------------------------------------------------------------
' import comm.lib 'Bug 101276 - library use counter is not decremented in case of "terminate program"
' module global "constants"


' Instance of execution server, read from socket and execute a command while socket is open


program continue
dim bSocketIsOpen as long = 1
dim sCommand as string = ""
dim sChar as string=""
dim sNameSelf as string
dim sSocketDesc as string
dim sReEvaluateStr as string
dim lSocketDesc as long
dim seqNum as long
sNameSelf = PROGRAMNAME
sSocketDesc = mid$(sNameSelf, instr(sNameSelf,"_")+1, 2)
?sSocketDesc
lSocketDesc = val(sSocketDesc)
print sNameSelf; ": Listening to descriptor #";lSocketDesc
while bSocketIsOpen
    try
      if isopen(lSocketDesc) then
        if loc(lSocketDesc) = 0 then
             sleep 1
        end if     
        sChar=input$(1,#lSocketDesc) 'receive
        if asc(sChar)>=0xa then ' drop non printable
          if left$(sChar,1) <> chr$(0xd) then '\r - ignore
            if left$(sChar,1) = chr$(0xa) then '\n
              lCommandRecved = sys.clock
              sReEvaluateStr = Execute(lSocketDesc,sCommand,seqNum)
              lCommandExecuted = sys.clock
'Evaluate returned non-empty string - we have to reevalute it to complete operation              
              if len(sReEvaluateStr) then
                  sendResponceStr(lSocketDesc,seqNum,ExecuteResponce(lSocketDesc,sReEvaluateStr))
              end if
              sCommand = ""
            else
              sCommand = sCommand + sChar 
            end if  
          end if
        end if    
      else
        bSocketIsOpen = 0
      end if  
    catch else
      bSocketIsOpen = 0
    end try

end while
print sNameSelf;": Terminated"
try 
  close #lSocketDesc
catch else
  ' nothig to do
end try    
terminate program ' <MyTask>.prg
