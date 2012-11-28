
.PHONY: page git

page: .html/index.html

git: page
	cd .html;\
		if [ "$$(git status -s)" ]; then \
			git commit -am "Update to master branch" && git push origin gh-pages; \
		fi

.html/index.html: resume.rst | .html
	rst2html.py $^ $@

.html:
	git clone -s -b gh-pages . .html
