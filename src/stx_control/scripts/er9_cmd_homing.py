#!/usr/bin/env python
# coding=utf-8
import getopt
import sys
import signal
from stxlib.tcp_move.basic_client import BasicClient


# MC_IP = '90.0.0.1'
MC_IP = '132.68.161.26'


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

        while True:
            print "============ Press `1` to begin setting up the robot ..."
            print "============ Press `0` when done with the setting ..."
            inp = raw_input()
            if inp == '1':
                tn.enableGroup(65)
                break

        while True:

            print "============ Enter joint number..."
            joint_num = raw_input()

            if joint_num == '0':
                tn.disconnect()
                break

            print "============ Enter movement degree..."
            deg = raw_input()
            neg_deg = '-' + deg

            if deg == '0':
                break

            if int(deg, 10) > 100:
                print "degree is to big, try again"
                continue

            print "=========== Enter movement speed..."
            speed = raw_input()

            if speed == '0':
                break

            if int(speed, 10) > 100:
                print "speed is to fast, try again"
                continue

            while True:
                print "\n======the robot will move '{}°' degrees with joint number '{}' in a speed of {}. (y/n)?=====".format(
                    deg, joint_num, speed)
                ans = raw_input()

                if ans == 'n':
                    print "\nEnter new command \n"
                    break

                if ans == 'y':
                    print "press '+' to move to {} degrees or '-' to move -{} degrees".format(deg, deg)
                    print "to change joints/speed/degree press Enter"
                    print "when joint is home pres 'H'\n"

                    while True:
                        direction = raw_input()
                        if direction == '':
                            break

                        if direction == 'H':
                            tn.setAxisHome(joint_num)

                            break

                        if direction == '+':
                            tn.moveAxisRealtive(joint_num, deg, speed)
                            print "\nrobot is moving!"

                        else:
                            if direction == '-':
                                tn.moveAxisRealtive(joint_num, neg_deg, speed)
                                print "\nrobot is moving!"
                            else:
                                print "input should be '+' or '-' (press 'Enter' to change joint movement settings)"


                # if ans == '0':
                #     tn.disconnect()
                #     break

                break

    except KeyboardInterrupt:
        pass



