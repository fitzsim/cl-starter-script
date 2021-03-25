	sudo apt install sbcl || \
	sudo dnf install sbcl || \
	sudo yum install sbcl && \
	git clone --recursive https://git.sr.ht/~fitzsim/cl-starter-script && \
	./cl-starter-script/start.lisp --help

# It's a start...

Features:

* Starting point for a small Common Lisp utility script.

* Runnable from the command line.

* Loadable in a REPL.

* SBCL and CLISP* support, so far.

* Self-contained within the checkout directory.

* Runnable without an Internet connection after the first Git clone.

* Command line option parsing support provided by
  [CLON](https://github.com/didierverna/clon).

* Experiment with no :use at all, not even :common-lisp.  Interesting,
  but in practice :use :cl and remove cl: prefixes.

You should probably use [Roswell](https://github.com/roswell/roswell)
instead.

Also check out [cl-launch](https://github.com/fare/cl-launch) which
unfortunately is not widely packaged by distros.

*A working CLISP can be built something like this on Debian:

	sudo apt install libffcall-dev
	git clone https://gitlab.com/gnu-clisp/clisp
	cd clisp
	git checkout -b ffcall d9cbf22d18680f9b9c84579be6bc363e4bd1090c
	git am ../cl-starter-script/patch/0001-Fix-ffcall-linkages-on-Debian.patch
	./configure --prefix=/usr --with-threads=POSIX_THREADS --with-module=asdf
	make
	sudo make install
