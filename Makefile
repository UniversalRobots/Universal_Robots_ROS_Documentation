# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SOURCEDIR     = .
BUILDDIR      = _build

SUBREPOS      = doc/ur_client_library doc/ur_description doc/ur_robot_driver doc/ur_simulation_gz doc/ur_tutorials

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile html html-all clone-subrepos

# Clone subrepos for ROS_DISTRO (default: rolling). Requires vcstool.
clone-subrepos:
	rm -rf $(SUBREPOS)
	ros=$${ROS_DISTRO:-rolling}; \
	vcs import --input $$ros.repos doc

# Single-distro HTML at _build/html/$(ROS_DISTRO)/ (default: rolling)
html: clone-subrepos
	@ros=$${ROS_DISTRO:-rolling}; \
	export ROS_DISTRO="$$ros"; \
	$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/html/$$ros" $(SPHINXOPTS) $(O)

# Jazzy, Kilted, Rolling; version-less pages redirect to chosen distro (see script)
html-all:
	@./scripts/build_docs.sh

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
