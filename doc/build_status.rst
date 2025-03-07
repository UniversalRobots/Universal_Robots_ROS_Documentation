Build status
============

This page gives a detailed overview of the build status of the full ROS-related software stack. Please note that due to upstream changes some pipelines might turn red temporarily which can be expected behavior, especially the binary-main builds.

ur_client_library
-----------------

.. image:: https://github.com/UniversalRobots/Universal_Robots_Client_Library/actions/workflows/ci.yml/badge.svg
    :alt: Integration Tests
    :target: https://github.com/UniversalRobots/Universal_Robots_Client_Library/actions/workflows/ci.yml

.. image:: https://github.com/UniversalRobots/Universal_Robots_Client_Library/actions/workflows/industrial-ci.yml/badge.svg
    :alt: Industrial CI (all ROS distributions)
    :target: https://github.com/UniversalRobots/Universal_Robots_Client_Library/actions/workflows/industrial-ci.yml

.. image:: https://github.com/UniversalRobots/Universal_Robots_Client_Library/actions/workflows/win-build.yml/badge.svg
   :alt: Windows Build
   :target: https://github.com/UniversalRobots/Universal_Robots_Client_Library/actions/workflows/win-build.yml

.. image:: https://github.com/UniversalRobots/Universal_Robots_Client_Library/actions/workflows/sphinx_build.yml/badge.svg
   :alt: Documentation Build
   :target: https://github.com/UniversalRobots/Universal_Robots_Client_Library/actions/workflows/sphinx_build.yml

.. raw:: html
   :file: build_status.html

Explanations
------------

There are different stages checking current and future compatibility of the packages.

- Binary builds - against released packages (main and testing) in ROS distributions. Shows that
  direct local build is possible and integration tests work against the released state. Released
  upstream packages land in testing directly after being built by the ROS buildfarm, while main
  receives updates on discrete manually triggered events. This is why the binary-main pipeline
  might turn red temporarily while the binary-testing pipelines are green. This means that no
  further action is required from the maintainers, this will sort itself out with the next sync.

- Semi-binary builds - against released core ROS packages (main and testing), but the immediate
  dependencies are pulled from source. Shows that local build with dependencies is possible and if
  this fails we can expect that after the next package sync we will not be able to build. For
  example, if upstream changes would make the current branch fail and those changes have **not**
  been released, yet, we might adapt to these changes already leaving us also with a failing
  binary-testing build, while the semi-binary builds should turn green.
