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
     rtde_frequency:=125 \
     use_robot_timestamp:=true \
     t_delay:=0.004 

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

- ``use_robot_timestamp`` (bool, optional, default: ``false``)

  When enabled, the node uses the robot controller's internal hardware clock to stamp 
  ROS 2 messages instead of the host PC's local processing time.

  For a detailed explanation of the timeline reconstruction, see the
  `Timestamp Synchronization`_ section.

  *Example:* ``use_robot_timestamp:=true``

- ``t_delay`` (double, optional, default: ``0.0``)

  Constant time offset in seconds (s) to compensate for network latency between the robot and the ROS PC.

  This parameter is only effective when ``use_robot_timestamp`` is enabled. It shifts the reconstructed
  timeline backward, allowing the ROS timestamps to better approximate the exact moment the physical
  measurement occurred on the robot hardware. See `Timestamp Synchronization`_ for the mathematical implementation.

  *Example:* ``t_delay:=0.004`` to compensate for an estimated 4 ms communication delay.



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

Timestamp Synchronization
-----------------------------------

When the ``use_robot_timestamp`` parameter is enabled, the node switches from host-side
timestamping to a reconstructed timeline anchored directly to the robot controller's
internal hardware clock.

.. note::
   The timestamp received over RTDE represents the time in seconds since the controller
   startup (boot time).

Timeline Reconstruction Mechanism
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**1. Anchor Setup (First Packet)**

Upon receiving the first RTDE packet, the node captures the current host ROS time (:math:`t_{\text{host}}`)
and the initial robot hardware timestamp (:math:`T_0`). It applies the network latency compensation factor
``t_delay`` to calculate an adjusted host base time (:math:`t_0`):

.. math::
   t_0 = t_{\text{host}} - t_{\text{delay}}

**2. Linear Tracking (Subsequent Packets)**

For all consecutive packets, the node tracks the elapsed hardware time using the incoming robot timestamp (:math:`T`).
The final ROS 2 message timestamp (:math:`t_{\text{msg}}`) is linearly extrapolated as:

.. math::
   t_{\text{msg}} = t_0 + (T - T_0)

**Walkthrough Example:** Consider a configuration using ``use_robot_timestamp:=true`` and ``t_delay:=0.004`` (values in seconds):

.. list-table::
   :align: center
   :widths: 20 15 25 40
   :header-rows: 1

   * - Scope / Step
     - Variable
     - Value
     - Mathematical Context / Equation
   * - **Packet 1** (Initialization)
     - :math:`t_{\text{host}}`
     - ``1779781131.140454``
     - Host PC reception time
   * -
     - :math:`T_0`
     - ``9010.081000``
     - Initial robot hardware timestamp
   * -
     - :math:`t_{\text{delay}}`
     - ``0.004``
     - Configured latency compensation
   * -
     - :math:`t_0`
     - ``1779781131.136454``
     - Adjusted base ROS time: :math:`t_{\text{host}} - t_{\text{delay}}`
   * - **Packet 2** (Next Cycle)
     - :math:`T`
     - ``9010.087000``
     - Current robot hardware timestamp
   * -
     - :math:`dt`
     - ``0.006``
     - Elapsed hardware time: :math:`T - T_0`
   * -
     - :math:`t_{\text{msg}}`
     - ``1779781131.142454``
     - Final ROS message timestamp: :math:`t_0 + dt`

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
  If precise controller‑side timing is required, users can enable hardware timeline
  reconstruction. See the `Timestamp Synchronization`_ section for details.
