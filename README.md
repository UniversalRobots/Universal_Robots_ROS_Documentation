# Universal Robots ROS 2 documentation

This repository contains the build scripts to generate the Universal Robots documentation around
the packages.

The rendered result of this can be viewed at [https://docs.universal-robots.com/Universal_Robots_ROS_Documentation/](https://docs.universal-robots.com/Universal_Robots_ROS_Documentation/).

## Building the documentation locally
In order to build the documentation locally, you'll need to 
  * Install the required tools
  * Checkout / symlink the respective ROS 2 packages that shall be documented.
  * Use `sphinx` to build the documentation locally

### Install required tools
In order to install the required tools you can create a python virtualenv (Install that using `sudo
apt install python3-venv`) and install the dependencies there:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip3 install -U -r requirements.txt
```

### Checkout subrepos
You can either checkout all the required repos using vcs or symlink them to the `doc` folder if you
have cloned them already.

```bash
pip3 install vcstool
vcs import --input rolling.repos doc
```

### Use sphinx to build the documentation
In order to build the documentation, simply use

```bash
make html
```

### View the generated documentation
To view the generated documentation use

```bash
xdg-open _build/html/index.html
```
