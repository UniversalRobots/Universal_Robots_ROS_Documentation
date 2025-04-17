.. _documentation_home:

Welcome to the Universal Robots ROS 2 driver documentation
==========================================================


.. image:: _static/images/ros2_driver.jpeg
   :alt: UR ROS 2 driver
   :align: right
   :width: 600px


This documentation covers everything around the Open-Source ROS (Robot Operating System) 2 driver packages
for Universal Robots manipulators and the standalone Universal Robots Client Library (C++).

With those packages it is possible to control a Universal Robots arm from an external application
either directly using a C++ API (see :ref:`ur_client_library`) or using ROS 2 (see :ref:`ur_robot_driver`).

This allows developing robot applications where one or more UR robots are a part of the complete
application. Some key use cases are:

- **External Monitoring and Control**: It allows you to monitor and control UR robots from an
  external application. This can be useful for tasks like external vision systems for part
  detection or external user interfaces to control robot programs.

- **Ease of Use**: The *ur_client_library* has minimal external dependencies, primarily relying on standard
  C++ libraries, making it straightforward to integrate and maintain.

- **Integration with ROS / ROS 2**: The *ur_client_library* serves as the foundation for the ROS 2
  driver, making it easier to integrate UR robots into ROS-based systems. ROS supports multiple
  programming languages, primarily C++ and Python, making it easier to integrate with other
  systems and tools. It also allows for communication between different nodes, enabling complex
  robotic systems. The Universal Robots ROS packages offer everything from Visualization, over
  simulation up to controlling a real robot bridging the great work of the ROS community with
  Universal Robots manipulators.


.. note::
   There is also builtin ROS 2 support for PolyScope X robots, see the `PolyScope X ROS 2 documentation <https://docs.universal-robots.com/polyscopex-ros2/v10.7/index.html>`_ and / or :ref:`ros2_controller_vs_driver` for details.

Table of Contents
-----------------

.. toctree::
   :titlesonly:

   ur_client_library <doc/ur_client_library/doc/index.rst>
   ur_description <doc/ur_description/doc/index.rst>
   ur_robot_driver <doc/ur_robot_driver/ur_robot_driver/doc/index.rst>
   ur_calibration <doc/ur_robot_driver/ur_calibration/doc/index.rst>
   ur_controllers <doc/ur_robot_driver/ur_controllers/doc/index.rst>
   ur_moveit_config <doc/ur_robot_driver/ur_moveit_config/doc/index.rst>
   ur_simulation_gz <doc/ur_simulation_gz/ur_simulation_gz/doc/index.rst>
   Tutorial examples <doc/ur_tutorials/tutorial_index.rst>
   doc/migration_notes.rst
   doc/build_status
   doc/ros2_controller_vs_driver
