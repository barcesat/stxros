#!/usr/bin/env python
# coding=utf-8
import getopt
import sys
import signal
import time
from stxlib.tcp_move.basic_client import BasicClient


# MC_IP = '90.0.0.1'
MC_IP = '132.68.161.26'
NUM_OF_JOINTS = 5


def signal_handler(signal, frame):
    tn.disableGroup(65)
    sys.exit(0)


if __name__ == '__main__':

    if len(sys.argv) > 1:
    	# Remove 1st argument from the
    	# list of command line arguments
    	argumentList = sys.argv[1:]
 
    	# Options
    	options = "hm:"
 
    	# Long options
    	long_options = ["Help", "mc_ip="]

        # Zeroing MC_IP
        MC_IP = None
	try:
   	   # Parsing argument
    	   arguments, values = getopt.getopt(argumentList, options, long_options)
     
    	   # checking each argument
    	   for currentArgument, currentValue in arguments:
 
             if currentArgument in ("-h", "--Help"):
                print ("Usage: python homing_node --mc_ip=[IP of mc]")
	        raise SystemExit()
             
             elif currentArgument in ("-m", "--mc_ip"):
                MC_IP=currentValue
             
	except getopt.error as err:
    	   # output error, and return with an error code
    	   print (str(err))
	   raise SystemExit()
	      
    if MC_IP == None:
	print("No valid mc IP was given.")
        raise SystemExit()
    print("Using MC_IP="+MC_IP)

    try:
        signal.signal(signal.SIGINT, signal_handler)

        tn = BasicClient(MC_IP)
        tn.connect()

	print("")
	print("This Program will set up the home position of the robot by zeroing")
        print("all the servos at their current position.")
        print("")
        print("To start move the robot to it's home position. Then when you are ready")

        while True:
            print "============ Press `1` to begin zero all the joints in the robot ..."
            print "============ Press `0` to exit ..."
            inp = raw_input()
            if inp == '1':
                tn.enableGroup(65)
		for joint_num in range(NUM_OF_JOINTS):
		   print("Zeroing joint "+str(joint_num+1)+"....")
	    	   tn.setAxisHome(joint_num+1)
		   time.sleep(1)
		   
                break
	    if inp == '0':
		
                break                

        
	print("Closing connection and exiting")
	tn.disconnect()
	sys.exit(0)

    except KeyboardInterrupt:
        pass



