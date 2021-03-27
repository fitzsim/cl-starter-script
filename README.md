	sudo apt    install sbcl || \
	sudo dnf    install sbcl || \
	sudo yum    install sbcl || \
	     guix   install sbcl || \
	sudo pacman -S      sbcl || \
	     emerge         sbcl && \
	git clone --recursive https://git.sr.ht/~fitzsim/cl-starter-script && \
	./cl-starter-script/start.lisp --help

If pasting that doesn't work, complain by filing a
[todo](https://todo.sr.ht/~fitzsim/cl-starter-script).

At the end, you should see:

	Compiling, should take less than 30 seconds...
	Usage: start [-hq] [OPTIONS] FILES...

	Starter utility script.
	Flags:
	  -h, --help                  Print this help and exit.
	  -q, --quiet                 Print fewer messages.
	Options:
	  -f, --file=FILE             Output to FILE.
	                              Default: output.txt

# It's a start...

Features:

* Template for a small Common Lisp utility script.

* Meant to be renamed and hacked up.

* Runnable from the command line.

* Loadable in a REPL.

* SBCL and CLISP support, so far.

* Self-contained within the checkout directory.

* Runnable without an Internet connection after the first Git clone.

* Command line option parsing support provided by
  [CLON](https://github.com/didierverna/clon).

* Experiment with no :use at all, not even :common-lisp.  Interesting,
  but in practice :use :cl and remove cl: prefixes.

# Alternatives

Check out [cl-launch](https://github.com/fare/cl-launch) which
unfortunately is not widely packaged by distros.

Also look at [Roswell](https://github.com/roswell/roswell) as another
potential basis for Common Lisp scripting, and lots more.

