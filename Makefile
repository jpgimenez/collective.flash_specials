# convenience makefile to boostrap & run buildout
# use `make options=-v` to run buildout with extra options

version = 2.7
python = bin/python
options =
minimum_coverage = 80
pep8_ignores = E501
max_complexity = 12

all: docs tests

docs: docs/html/index.html

docs/html/index.html: docs/*.rst src/collective/flash_specials/*.py src/collective/flash_specials/browser/*.py src/collective/flash_specials/tests/*.py bin/sphinx-build
	bin/sphinx-build docs docs/html
	@touch $@
	@echo "Documentation was generated at '$@'."

bin/sphinx-build: .installed.cfg
	@touch $@

.installed.cfg: bin/buildout buildout.cfg buildout.d/*.cfg setup.py
	bin/buildout $(options)

bin/buildout: $(python) buildout.cfg bootstrap.py
	$(python) bootstrap.py -d -v 1.6.3
	@touch $@

$(python):
	virtualenv -p python$(version) --no-site-packages .
	@touch $@

tests: .installed.cfg
	@bin/test
	@bin/flake8 --ignore=$(pep8_ignores) --max-complexity=$(max_complexity) src/collective/flash_specials
	@for pt in `find src/collective/flash_specials -name "*.pt"` ; do bin/zptlint $$pt; done
	@for xml in `find src/collective/flash_specials -name "*.xml"` ; do bin/zptlint $$xml; done
	@for zcml in `find src/collective/flash_specials -name "*.zcml"` ; do bin/zptlint $$zcml; done

clean:
	@rm -rf .installed.cfg .mr.developer.cfg bin docs/html parts develop-eggs \
		src/collective.flash_specials.egg-info lib include .Python

.PHONY: all docs tests clean
