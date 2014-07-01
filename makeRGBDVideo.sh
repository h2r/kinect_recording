#!/bin/bash
rm *.png
rm info.bag
roslaunch openni_launch openni.launch depth_registration:=true &
rosbag record /camera/depth_registered/camera_info /camera/rgb/camera_info /tf -O info.bag &
rosrun image_view depthExtraction _sec_per_frame:=0.01 image:=/camera/depth_registered/image_raw &
rosrun image_view extract_images _sec_per_frame:=0.01 image:=/camera/rgb/image_color
wait
#for file in dframe{0000..1000}.png; do convert $file -auto-level $file; echo converting File $file; done
rm outputD.avi
rm outputRGB.avi
ffmpeg -r 30 -i frame%05d.png -vcodec ffv1  -r 55 outputRGB.avi
ffmpeg -r 30 -i dframe%05d.png -vcodec ffv1 -r 55 outputD.avi
#rm *.png
mplayer outputRGB.avi &
mplayer outputD.avi
wait
du -h outputRGB.avi
du -h outputD.avi
du -h info.bag
du -h images.bag
