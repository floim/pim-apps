JAVASCRIPTS=$(patsubst %.coffee,%.js,$(wildcard *.coffee))
PIMSCRIPTS=$(patsubst %.coffee,%.ps,$(wildcard *.coffee))

%.ps: %.js
	node_modules/.bin/pimscript $< '{"id":0}' $@

%.js: %.coffee
	coffee -bc $<

all: $(JAVASCRIPTS) $(PIMSCRIPTS)
