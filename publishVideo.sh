#!/bin/bash
ffmpeg -i outputRGB.avi -r 30  images/image%04d.png
ffmpeg -i outputD.avi -r 30 dimages/dimage%04d.png
wait
export ROS_PACKAGE_PATH=/home/h2r/catkin_ws:$ROS_PACKAGE_PATH
echo $ROS_PACKAGE_PATH
rosrun learning_image_transport videoPublisher $PWD images image color&
rosrun learning_image_transport videoPublisher $PWD dimages dimage  d &
rosrun image_view image_view image:=/camera/rgb/image_color &
rosrun image_view image_view image:=/camera/depth_registered/image_raw &
rosparam set /use_sim_time true &
roslaunch openni_launch openni.launch load_driver:=false &
rosbag play --clock info.bag
kill
rosparam set /use_sim_time false
rm images/*.png
rm dimages/*.png
