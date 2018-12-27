PREFIX = /usr/local

check: matchnames parsenames test/listA test/listB test/names test/matchnames.ok test/parsenames.ok
	./matchnames -a test/listA -b test/listB -o test/out -f
	bash -c "if [ -z `diff test/matchnames.ok test/out` ] ; then echo '** matchnames PASS **'; else echo '** matchnames FAIL **' ; fi "
	rm -f test/out
	cat test/names | ./parsenames > test/out
	bash -c "if [ -z `diff test/parsenames.ok test/out` ] ; then echo '** parsenames PASS **'; else echo '** parsenames FAIL **' ; fi "
	rm -f test/out

install: matchnames parsenames share/taxon-tools.awk
	bash -lc 'IFS=":" ; for p in $$AWKLIBPATH ; do if [ -f $${p}/aregex.so ] ; then FOUND="1" ; fi ; done ; if [ -z $$FOUND ] ; then echo "** aregex.so not found in AWKLIBPATH **" && exit 1 ; fi '
	mkdir -p $(PREFIX)/bin
	cp -f matchnames parsenames $(PREFIX)/bin/.
	mkdir -p $(PREFIX)/share/awk
	cp -f share/taxon-tools.awk $(PREFIX)/share/awk/.
	mkdir -p $(PREFIX)/share/man/man1
	cp -f doc/matchnames.1 $(PREFIX)/share/man/man1/.
	cp -f doc/parsenames.1 $(PREFIX)/share/man/man1/.

man: doc/matchnames.md doc/parsenames.md
	pandoc -s -t man -o doc/matchnames.1 doc/matchnames.md
	pandoc -s -t man -o doc/parsenames.1 doc/parsenames.md
