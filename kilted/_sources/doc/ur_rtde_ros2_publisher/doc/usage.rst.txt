:github_url: https://github.com/UniversalRobots/RTDE_ROS2_Publisher/blob/main/doc/usage.rst

.. _ur_rtde_pub/usage:

Usage
=====

Quick Start
-----------

Launch the RTDE publisher node using the provided launch file:

.. code-block:: bash

   ros2 launch ur_rtde_publisher rtde_publisher.launch.xml \
     robot_ip:=192.168.56.101 \
     output_recipe:='["payload", "robot_mode"]' \
     rtde_frequency:=125

After launching, verify the node is running:

.. code-block:: bash

   ros2 node list
   ros2 topic list | grep rtde

.. note::

   If a requested RTDE variable cannot be enabled or is not available on the robot
   controller, the node will continue running and publish the remaining valid variables.
   Failures affecting individual RTDE outputs do not stop the node.

Parameters
----------

The following parameters control the node behavior:

- ``robot_ip`` (string, **required**)

  IP address of the target UR robot controller.

  *Example:* ``robot_ip:=192.168.56.101``

- ``output_recipe`` (string array, **required**)

  List of RTDE output variables to request from the robot and publish as ROS 2 topics.

  The set of available RTDE output variables is defined by the Universal Robots RTDE interface
  and can be found in the official documentation:
  `RTDE Robot Controller Outputs <https://docs.universal-robots.com/tutorials/communication-protocol-tutorials/rtde-guide.html#robot-controller-outputs>`_

  The variable names must be used exactly as specified in the RTDE documentation when
  providing the ``output_recipe`` parameter in the launch file.
  
  *Example:* ``output_recipe:=["payload", "robot_mode", "safety_status"]``

- ``rtde_frequency`` (int, optional, default: ``500``)

  RTDE communication frequency in Hertz (Hz).

  Most robot controllers support RTDE frequencies up to 500 Hz, depending on the
  robot generation. For CB3‑series robots, the maximum supported RTDE frequency
  is 125 Hz.

  The configured frequency must be aligned with the RTDE update cycle, meaning it
  must be an integer divisor of 500 Hz. For instance: ``100`` Hz, ``125`` Hz or ``250`` Hz  

  *Example:* ``rtde_frequency:=125`` to publish RTDE data at 125 Hz.

- ``tf_prefix`` (string, optional, default: ``""``)

  Optional prefix applied to the ``frame_id`` field of stamped ROS 2 messages
  (e.g. ``PoseStamped``, ``TwistStamped``, ``WrenchStamped``).

  This parameter allows users to adapt the published ``frame_id`` values to their
  TF tree or multi‑robot setups without modifying the default YAML configuration
  file (``rtde_map.yaml``).

  When set, the final ``frame_id`` is constructed as: ``<tf_prefix>/<frame_id>``

  *Example:* setting ``tf_prefix:=robot1`` and the default ``frame_id`` of ``base``
  results in ``robot1/base``.



Configuration
--------------

The node uses a YAML configuration file (``config/rtde_map.yaml``) to define
the mapping between RTDE variables and ROS 2 message types.

In normal usage, this file should not be modified, as it reflects the supported RTDE
variables and their corresponding ROS 2 message mappings.

End users may optionally customize the configuration to adjust the ``frame_id`` used
for stamped ROS 2 messages (e.g. ``PoseStamped``, ``TwistStamped``, ``WrenchStamped``),
in order to match their TF tree or application-specific coordinate frames.

As an alternative to editing the YAML file, the ``tf_prefix`` parameter can be used to
systematically prepend a prefix to the default ``frame_id`` values defined in
``rtde_map.yaml``. 

Apart from frame-related metadata, modifying RTDE variables, message types, or mappings
is not recommended and may lead to inconsistent behavior.


Typical Workflow
----------------

1. Ensure your UR robot is powered on and network accessible. The `RTDE service should be enabled <https://docs.universal-robots.com/Universal_Robots_ROS_Documentation/rolling/doc/ur_client_library/doc/setup/robot_setup.html>`_ in
   the robot's service settings.
2. Launch the node: ``ros2 launch ur_rtde_publisher rtde_publisher.launch.xml robot_ip:=<YOUR_ROBOT_IP> output_recipe:='["payload", "robot_mode"]'``
3. Monitor published topics: ``ros2 topic list`` and ``ros2 topic echo <topic_name>``
4. Integrate published data into your ROS 2 application


Possible quirks
---------------

There are several aspects users should be aware of when using the RTDE ROS2 Publisher:

* **Network dependency**: Network latency may affect data delivery timing under non-real-time conditions. Ensure stable network connectivity between the ROS 2 host and robot controller.

* **PolyScope version compatibility**: RTDE field availability depends on the PolyScope version running on the controller. Some variables may not be available on older firmware versions.

* **Robot state requirements**: The robot should be powered on, and not in error condition for RTDE communication to work properly.

* **Low-latency QoS and sample loss**:  
  All topics are published using the ROS 2 ``SensorDataQoS`` profile, which prioritizes
  low latency over delivery reliability and may result in individual messages being dropped.
  This behavior is expected and acceptable for high-frequency RTDE data streams, where
  newer samples are continuously published.

* **Timestamp origin**:
  By default, published ROS 2 messages are timestamped on the external PC running
  the node, at the time RTDE data is received and published. These timestamps
  therefore reflect host‑side reception time rather than the exact time at which
  the data was produced by the robot controller.
  If precise controller‑side timing is required, users may include the RTDE
  ``timestamp`` variable in the ``output_recipe`` and use it as a reference for
  time synchronization or post‑processing.
