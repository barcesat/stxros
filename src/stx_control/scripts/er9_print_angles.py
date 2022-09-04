#!/usr/bin/env python
# coding=utf-8
import getopt
import sys
import signal
import time
from stxlib.tcp_move.basic_client import BasicClient
from stxlib.axis_data.encoder_reader import AxisDataReader


# MC_IP = '90.0.0.1'
MC_IP = '132.68.161.26'
NUM_OF_JOINTS = 5
DEG2RAD = 0.017453292519943295


def signal_handler(signal, frame):
    #tn.disableGroup(65)
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

        #tn = BasicClient(MC_IP)
        #tn.connect()

        reader = AxisDataReader(MC_IP)
	position = [0] * NUM_OF_JOINTS

        while True:
	    axes_data = reader.read(NUM_OF_JOINTS)
            position = list(map(lambda axis_data: axis_data.get_pFb() * DEG2RAD, axes_data)) 
	    print(position)
	    time.sleep(0.2)               

        

    except KeyboardInterrupt:
        pass



