:github_url: https://github.com/UniversalRobots/RTDE_ROS2_Publisher/blob/main/doc/installation.rst

Installation
============

.. _ur_rtde_pub/installation:

The `ur_rtde_publisher` package can be built from source.

Building from Source
--------------------

Make sure ROS 2 is properly installed and sourced before proceeding.

1. Create a ROS 2 workspace:

.. code-block:: bash

   export COLCON_WS=~/ros2_ws
   mkdir -p $COLCON_WS/src

2. Clone the repository (replace ``<branch>`` with ``jazzy`` or ``main`` for rolling):

.. code-block:: bash

   cd $COLCON_WS
   git clone -b <branch> https://github.com/UniversalRobots/RTDE_ROS2_Publisher.git src/UR_RTDE_ROS2_Publisher

3. Install dependencies, build, and source the workspace:

.. code-block:: bash

   rosdep update
   rosdep install --ignore-src --from-paths src -y
   colcon build  --cmake-args -DCMAKE_BUILD_TYPE=Release
   source install/setup.bash


