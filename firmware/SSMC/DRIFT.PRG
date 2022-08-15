
program

with robot
attach
  en=1
  abs=1
  vcruise=30
  sleep 10
  while 1
    move {0,0,0,0,0}
    waitformotion
    move {30,30,30,30,0}
    waitformotion
    move {0,0,0,0,0}
    waitformotion
    sleep 10
  end while
  en=0
detach
end with

end program ' <MyTask>.prg
