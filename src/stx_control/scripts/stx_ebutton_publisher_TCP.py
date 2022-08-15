#!/usr/bin/env python

# license removed for brevity

import rospy
# from sensor_msgs.msg import JointState
from std_msgs.msg import Bool
from std_msgs.msg import Header
from stxlib.tcp_move.basic_client import BasicClient

MC_IP = '90.0.0.1'

EBUTTON_PIN = 9


if __name__ == '__main__':
    try:

        pub = rospy.Publisher('ebutton', Bool, queue_size=10)
        rospy.init_node('stx_ebutton_publisher')
        rospy.loginfo('stx_ebutton_publisher Running .............')

        print("=====================================")
        MC_IP = rospy.get_param('~MC-IP')
        print('E button publisher connected to mc ip : {}'.format(MC_IP))
        print("=====================================")

        tn = BasicClient(MC_IP)
        tn.connect()

        msg = Bool()


        rate = rospy.Rate(10)  # 10hz
        while not rospy.is_shutdown():
	    try:
	    	returnVal = tn.getInput(EBUTTON_PIN)
	    
	    	if returnVal[-1] == '0':
		    ebuttonVal = True
	    	else:
		    ebuttonVal = False

	    	#rospy.loginfo(ebuttonVal)
	    	msg.data = ebuttonVal
	    

	        pub.publish(msg)
	    except:
		pass
	    
            rate.sleep()

    except rospy.ROSInterruptException:
        pass
