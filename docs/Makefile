################################
# License - see LICENSE
################################
CONTEXT = header.html.jinja footer.html.jinja ../examples/*.jsonlang ../examples/*.jsonlang.golden
PAGES = index.html \
		userdocs.html tutorial.html demo.html stdlib.html \
		casestudies.html casestudy_fractal.1.html casestudy_fractal.2.html casestudy_fractal.3.html \
        language.html design.html comparisons.html spec.html \
		implementation.html commandline.html bindings.html cpp.html javascript.html tests.html \
		contributing.html

all: $(PAGES)

%.html: %.html.jinja $(CONTEXT) render.py
	python render.py $< $@
	cp *.html ../gh-pages/docs/
	cp *.js ../gh-pages/docs/
	cp *.css ../gh-pages/docs/
	cp *.png ../gh-pages/docs/

clean:
	rm -vf $(PAGES)
