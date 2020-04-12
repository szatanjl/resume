package = resume
distfiles = Makefile index.md style.css _layouts fonts README.md
layout = _layouts/default.html
fonts = fonts/computer-modern-serif.ttf fonts/helvetica-bold.ttf \
        fonts/times-new-roman.ttf

.PHONY: all check dist clean distclean install uninstall

all: resume.html resume.pdf

check:

dist:
	rm -R -f $(package) $(package).tar $(package).tar.gz
	mkdir $(package)
	cp -R -f $(distfiles) $(package)
	tar -c -f $(package).tar $(package)
	gzip $(package).tar
	rm -R -f $(package) $(package).tar

clean:
	rm -R -f $(package) $(package).tar $(package).tar.gz \
	         index.html resume.html resume.pdf

distclean: clean

install:

uninstall:

index.html: index.md
	markdown -o $@ $<

resume.html: index.html $(layout)
	sed -e "s/{{ page.title }}/`sed -n '/<h1>/{s/<[^>]*>//gp; q}' $<`/" \
	    -e '/{{ content }}/{r $<' -e 'd}' $(layout) > $@

resume.pdf: resume.html style.css $(fonts)
	weasyprint $< $@
