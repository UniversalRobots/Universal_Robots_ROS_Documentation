Architecture
============

Package Structure
-----------------

The `ur_rtde_publisher` package is organized into several components that together handle RTDE communication, data conversion, and ROS 2 topic publishing:

rtde_publisher_node
^^^^^^^^^^^^^^^^^^^

The main ROS 2 node entry point. This component handles ROS 2 parameter loading and validation, manages the RTDE connection setup and lifecycle, and runs the main publish loop at the configured frequency.

rtde_publisher
^^^^^^^^^^^^^^

Manages ROS 2 publishers and topic creation. This module is responsible for creating ROS 2 publishers based on the RTDE recipe, reading the YAML mapping configuration file, and publishing data at the appropriate frequency.

rtde_converter
^^^^^^^^^^^^^^

Provides utility functions for data conversion. This component converts raw RTDE data types into ROS 2 message types, and handles timestamp and frame_id assignments.

Data Flow
---------

1. **Initialization**: The node loads configuration from ROS 2 parameters and the YAML mapping file
2. **Connection**: Connects to the robot controller via RTDE protocol at the specified IP address
3. **Recipe Setup**: Configures RTDE output recipe with requested variables
4. **Publishing Loop**: Continuously reads RTDE data and publishes to ROS 2 topics via the converter utilities
5. **Cleanup**: Closes RTDE connection on node shutdown

Configuration Files
-------------------

**YAML Mapping File** (``config/rtde_map.yaml``)
    Defines how RTDE variables map to ROS 2 topics and message types.
    This file specifies how to convert the RTDE variables to ROS 2 messages.
