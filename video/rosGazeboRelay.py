#!/usr/bin/env python
# waypoint control for quadrotor
import rospy
from geometry_msgs.msg import Quaternion
from gazebo_msgs.msg import ModelState
from tf.transformations import quaternion_from_euler
import pandas


def euler2quat(euler):  # returns quat as np.array. Input in radians.
    roll = euler[0]
    pitch = euler[1]
    yaw = euler[2]
    return quaternion_from_euler(roll, pitch, yaw)


class QuadJoy:

    def __init__(self):
        self.gazebo_state = ModelState()
        self.pubState = rospy.Publisher('/gazebo/set_model_state', ModelState, queue_size=1)
        self.name = 'quadrotor_static'


def startNode():
    c = QuadJoy()

    # load data
    df = pandas.read_excel(open('droneSolution_1_bl.xlsx','rb'))
    n_elements = len(df['time_tot'])

    scale = 1

    for i in range(n_elements-1):
        c.gazebo_state.model_name = c.name
        c.gazebo_state.pose.position.x = df['x_tot'][i]
        c.gazebo_state.pose.position.y = df['y_tot'][i]
        c.gazebo_state.pose.position.z = df['z_tot'][i]

        quat = euler2quat([df['roll_tot'][i], df['pitch_tot'][i], df['yaw_tot'][i]])
        orient = Quaternion()
        orient.x = quat[0]
        orient.y = quat[1]
        orient.z = quat[2]
        orient.w = quat[3]
        c.gazebo_state.pose.orientation = orient

        c.gazebo_state.reference_frame = "world"   
        c.pubState.publish(c.gazebo_state)
        dt = df['time_tot'][i+1] - df['time_tot'][i]

        rospy.sleep(dt*scale)  # in seconds



if __name__ == '__main__':

    ns = rospy.get_namespace()
    try:
        rospy.init_node('relay')
        #####
        ns = '/SQ01s'
        #####
        print "Starting drawing node for: " + ns
        startNode()
    except rospy.ROSInterruptException:
        pass
