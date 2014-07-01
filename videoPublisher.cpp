#include <ros/ros.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <cv_bridge/cv_bridge.h>
#include <string>
#include <sstream>
#include <sensor_msgs/image_encodings.h>
#include <stdio.h>

int main(int argc, char** argv)
{
  ros::init(argc, argv, "video_publisher_"+std::string(argv[2]));
  ros::NodeHandle nh;

    cv_bridge::CvImage cv_image;
    std::string filepath ;
    std::string image =argv[3];
    std::string name = image ;
    int imNumber =0;

    
    std::string topic;//"/recorded_video/"+std::string(argv[2]);
    std::cout<<(std::string(argv[4])).length()<<std::string(argv[4]);
    if((std::string(argv[4])).length() > 2){
      topic="/camera/rgb/image_color";
    }else{
      topic="/camera/depth_registered/image_raw";
    }
    ROS_INFO(topic.c_str());

  ros::Publisher pub = nh.advertise<sensor_msgs::Image>(topic , 1);
  ros::Rate loop_rate(30);

  while (nh.ok()) 
  {
    char curImage[50];
    sprintf(curImage, "%04d",imNumber++);
    //ROS_INFO(name.c_str());
    image = name + curImage;
    //ROS_INFO(image.c_str());
    filepath = std::string(argv[1]) +"/" + std::string(argv[2]) + "/" + image + ".png";
    ROS_INFO(filepath.c_str());

    cv_image.image = cv::imread(filepath  ,CV_LOAD_IMAGE_COLOR);
    cv_image.encoding = "bgr8";
    sensor_msgs::Image ros_image;
    cv_image.toImageMsg(ros_image);


    pub.publish(ros_image);
    loop_rate.sleep();
    
  }
}
