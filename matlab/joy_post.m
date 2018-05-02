%Ben Keegan, Noah Wachlin
%ME4823
%Assignment 5 Exercise #1
%02MAY18
%
% Create a bag file object with the file name
% by omitting the semicolon this displays some information about
% the bag file
bag = rosbag('~/mrc_hw5_data/joy.bag')
 
% Display a list of the topics and message types in the bag file
bag.AvailableTopics
 
% Since the messages on topic turtle1/pose are of type Twist,
% let's see some of the attributes of the Twist message
msg_odom = rosmessage('nav_msgs/Odometry')
showdetails(msg_odom)
 
% Get just the topic we are interested in
bagselect = select(bag,'Topic','/odom');
 
% Create a time series object based on the fields of the turtlesim/Pose
% message we are interested in
ts = timeseries(bagselect,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

%% Breakout Data 
t = ts.Time-ts.Time(1);
x = ts.Data(:,1);
y = ts.Data(:,2);
vel = ts.Data(:,3);
th_dot = ts.Data(:,4);
W = ts.Data(:,5);
X = ts.Data(:,6);
Y = ts.Data(:,7);
Z = ts.Data(:,8);
EUL = quat2eul([W X Y Z]);
yaw = rad2deg(EUL(:,1));
u = vel.*cosd(yaw);
v = vel.*sind(yaw);

%% Plots
ii = 1:10:length(x);  % Decimate the data so that it plot only every Nth point.
figure(1);
%Plot the X and Y location of your robot. Saveas images/joy_odom_xy.png
plot(x(ii),y(ii));
title('Plot of TurtleBot X and Y');
xlabel('X [m]'); ylabel('Y [m]');
saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/joy_odom_xy.png');

figure(2);
%Plot of the heading in degrees vs. time. Saveas images/joy_odom_yaw.png
plot(t(ii),yaw(ii));
title('Plot of TurtleBot Heading vs. Time');
xlabel('Time [s]'); ylabel('Heading [deg]');
saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/joy_odom_yaw.png');

figure(3);
%Plot of forward velocity vs. time. Saveas images/joy_odom_u.png
plot(t(ii),u(ii));
title('Plot of TurtleBot Forward Velocity vs. Time');
xlabel('Time [s]'); ylabel('Forward Velocity, u [m/s]');
saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/joy_odom_u.png');

figure(4);
%Quiver plot showing the location, yaw and speed of the robot.  Saveas images/joy_odom_quiver.png
quiver(x(ii),y(ii),u(ii),v(ii));
title('Quiver Plot of Turtlebot Joystick Test');
xlabel('X [m]'); ylabel('Y [m]');
saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/joy_odom_quiver.png');
