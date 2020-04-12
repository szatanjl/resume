package = resume
distfiles = Makefile README _layouts style.css index.md
layout = _layouts/default.html


all: resume.html resume.pdf

.PHONY: all dist clean distclean

dist: distclean
	mkdir $(package)
	cp -Rf $(distfiles) $(package)
	tar -cf $(package).tar $(package)
	gzip $(package).tar
	rm -Rf $(package) $(package).tar

clean:
	rm -f index.html resume.html resume.pdf
	rm -Rf $(package) $(package).tar $(package).tar.gz

distclean: clean


index.html: index.md
	markdown -o $@ $<

resume.html: index.html $(layout)
	title=`sed -n 's|<h1.*>\(.*\)</h1>|\1|p' $<` && \
	sed -e "s/{{ page.title }}/$$title/" \
	    -e '/{{ content }}/r $<' \
	    -e '/{{ content }}/d' $(layout) > $@

resume.pdf: resume.html style.css
	chromium --headless --print-to-pdf=$@ $<
