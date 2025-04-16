.. _ros2_controller_vs_driver:

ROS 2 integration paths
=======================

There are different paths to use a Universal Robots arm with ROS 2.

ROS 2 on the robot
------------------

.. image:: /_static/images/ros2_urscript.png
   :alt: URScript for a subscruber
   :align: right
   :width: 400px

1. Starting with PolyScope X v10.7.0 the robots have builtin ROS 2 support that allows some amount
   of interaction with the robot without the need of any ROS 2 driver. In particular, the robot
   publishes a lot of status information and offers services  for example to control the robot's
   I/O ports. See the `Topics and Services overview
   <https://docs.universal-robots.com/polyscopex-ros2/v10.7/Appendix/Appendix%202.html>`_ for more
   information.


2. Starting with PolyScope X v10.7.0 there is basic URScript support for ROS 2. This allows
   publishing to and subscribing from ROS 2 topics directly in URScript as well as calling ROS 2
   services and actions from URScript. See `Basic Usage in URScript
   <https://docs.universal-robots.com/polyscopex-ros2/v10.7/Basic%20Usage%20in%20URScript.html>`_
   for details on that.

.. note::

  The builtin ROS 2 support will only be compatible with the ROS distribution running on the
  robot. For example, PolyScope 10.7.0 is running ROS 2 Humble. It should not be used with
  any other distribution.

Control the robot from an external ROS 2 application
----------------------------------------------------

.. image:: ur_tutorials/my_robot_cell/doc/view_workspace.png
   :alt: Visualizing a robot workspace using ROS 2
   :align: right
   :width: 400px

Using the :ref:`ur_robot_driver` which is a ROS 2 driver that offers full `ros2_control
<https://control.ros.org>`_ compatibility. This allows visualizing the robot's state in RViz and
control its motions through ROS 2. It works with CB3, e-Series (PolyScope 5) and PolyScope X robots.

Use the ROS 2 driver to build your own application on the ROS framework leveraging available
drivers for other hardware components, sensor integration and ready-to-use software functionalities
such as collision-aware path-planning.

The ROS 2 driver uses the :ref:`ur_client_library` to communicate with the robot.

Build your own external application using the C++ library
---------------------------------------------------------

With the standalone C++ library ":ref:`ur_client_library`" you can control a UR robot from a remote
application. It offers a lot of the functionality that traditionally the robot's teach pendant
would be used for. This includes

- Controlling the robot's power state
- Controlling the robot's motion
- Controlling the robot's I/O ports
- Access to low-level interfaces such as the Primary Interface, Dashboard Interface and the
  Realtime Data Exchange (RTDE).
