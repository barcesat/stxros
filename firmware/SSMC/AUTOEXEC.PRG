common shared finished_reading as long = 0

program continue

load startprg.prg
while startprg.PRG.state <> 10
  sleep 10
end while

load savepos.prg
stas savepos.prg

while finished_reading <> 1
  sleep 10
end while

loadglobal comm.lib
sleep 10
loadglobal axis_f.lib
sleep 10

load hmaxes.prg

load mvaxes.prg
load mvgroup.prg
load server.prg

?vesexecute("sys.motion=1")

end program
