	   sudo apt install sbcl \
	|| sudo dnf install sbcl \
	|| sudo yum install sbcl \
	&& git clone --recursive https://git.sr.ht/~fitzsim/cl-starter-script \
	&& ./cl-starter-script/start.lisp --help

# It's a start...

Features:

* Starting point for a small Common Lisp utility script.

* Runnable from the command line.

* Loadable in a REPL.

* SBCL support, so far.

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