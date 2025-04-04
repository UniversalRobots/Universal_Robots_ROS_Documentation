.. _ros2_controller_vs_driver:

ROS 2 integration paths
=======================

There are different paths to use a Universal Robots arm with ROS 2:

1. Starting with PolyScope X v10.7.0 the robots have builtin ROS 2 support that allows some amount
   of interaction with the robot without the need of any ROS 2 driver. In particular, the robot
   publishes a lot of status information and offers services  for example to control the robot's
   I/O ports. See the `Topics and Services overview
   <https://docs.universal-robots.com/polyscopex-ros2/v10.7/Appendix/Appendix%202.html>`_ for more
   information.

   .. note::

     The builtin ROS 2 support will only be compatible with the ROS distribution running on the
     robot. For example, PolyScope 10.7.0 is running ROS 2 Humble. It should not be used with
     any other distribution.

2. Starting with PolyScope X v10.7.0 there is basic URScript support for ROS 2. This allows
   publishing to and subscribing from ROS 2 topics directly in URScript as well as calling ROS 2
   services and actions from URScript. See `Basic Usage in URScript
   <https://docs.universal-robots.com/polyscopex-ros2/v10.7/Basic%20Usage%20in%20URScript.html>`_
   for details on that.
3. Using the :ref:`ur_robot_driver` which is a ROS 2 driver that offers full `ros2_control
   <https://control.ros.org>`_ compatibility. This allows visualizing the robot's state in RViz and
   control its motions through ROS 2. It works with CB3, e-Series (PolyScope 5) and PolyScope X robots.

   The ROS 2 driver uses the :ref:`ur_client_library` to communicate with the robot.
