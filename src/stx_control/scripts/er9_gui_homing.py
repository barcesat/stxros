# coding=utf-8

try:
    # for Python2
    import Tkinter as tk
except ImportError:
    # for Python3
    import tkinter as tk
import sys
import signal
from stxlib.tcp_move.basic_client import BasicClient
import getopt

# MC_IP = '90.0.0.1'
MC_IP = '132.68.161.26'


class MoveAxis(object):
    def __init__(self):
        self.joint_num = '0'
        self.deg = '0'
        self.speed = '0'

    def set_joint_data(self, joint_num, deg, speed):
        self.joint_num = joint_num
        self.deg = deg
        self.speed = speed


def quit_and_disconnect():
    tn.disableGroup(65)
    tn.disconnect()
    sys.exit(0)


class Graphics(object):

    def __init__(self, my_joint):
        self.my_joint = my_joint

        master = tk.Tk()
        master.configure(background='gray')
        master.title("Homing Controller")

        tk.Label(master, text="Joint number:").grid(row=0, column=0, pady=10, padx=10)
        tk.Label(master, text="Degree:").grid(row=0, column=2, pady=10)
        tk.Label(master, text="Speed(degree/seconds):").grid(row=0, column=4, pady=10)

        self.e1 = tk.Entry(master)
        self.e2 = tk.Entry(master)
        self.e3 = tk.Entry(master)

        self.e1.grid(row=1, column=0, padx=10)
        self.e2.grid(row=1, column=2, padx=10)
        self.e3.grid(row=1, column=4, padx=10)

        tk.Button(master,
            text='Start homing', command=self.submit_command_settings).grid(row=1,
            column=5,
            padx=10,
            sticky=tk.E)

        tk.Button(master,
            text='     <--    ', command=self.move_neg).grid(row=3,
            column=0,
            sticky=tk.E,
            pady=30)
        tk.Button(master,
            text='    -->     ', command=self.move_pos).grid(row=3,
            column=2,
            sticky=tk.W,
            pady=30)

        tk.Button(master,
            text='Set joint!', command=self.set_joint).grid(row=3,
            column=4,
            sticky=tk.W,
            pady=30)
        tk.Button(master,
            text='Quit',
            command=quit_and_disconnect).grid(row=3,
            column=5,
            sticky=tk.W,
             pady=4)

        tk.mainloop()

    def submit_command_settings(self):
        self.my_joint.joint_num = self.e1.get()
        self.my_joint.deg = self.e2.get()
        self.my_joint.speed = self.e3.get()
        print("joint, degree and speed are set!")

    def move_neg(self):
        print("moving -{}°".format(self.my_joint.deg))
        neg_deg = '-' + self.my_joint.deg
        tn.moveAxisRealtive(self.my_joint.joint_num, neg_deg, self.my_joint.speed)

    def move_pos(self):
        print("moving {}°".format(self.my_joint.deg))
        tn.moveAxisRealtive(self.my_joint.joint_num, self.my_joint.deg, self.my_joint.speed)

    def set_joint(self):
        tn.setAxisHome(self.my_joint.joint_num)
        print("joint {} is set!".format(self.my_joint.joint_num))


def signal_handler(signal, frame):
    tn.disableGroup(65)
    tn.disconnect()
    sys.exit(0)


def connect_to_mc():
    signal.signal(signal.SIGINT, signal_handler)
    tn.connect()
    tn.enableGroup(65)


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
        tn = BasicClient(MC_IP)
        connect_to_mc()

        my_joint = MoveAxis()

        Graphics(my_joint)

    except KeyboardInterrupt:
        pass
