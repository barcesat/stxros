
program
with robot
attach
en=1
while 1=1
  move {-0.154831 , 108.5 , 65.6696 , 180.88 , 4995.48} abs=1 vcruise=100
  waitformotion
  sleep 5000
  move {56.4282 , 117.011 , 101.629 , 117.859 , 5347.54} abs=1 vcruise=100
  waitformotion
  sleep 5000
  move {56.4355 , 8.94967 , -24.7204 , 101.765 , 4986.39} abs=1 vcruise=100
  waitformotion
  sleep 5000
end while
en=0
detach
end with

end program ' <MyTask>.prg
