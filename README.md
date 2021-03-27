Install SBCL or GNU CLISP for your distribution, e.g., run `apt
install sbcl` or `dnf install sbcl` as root.

	git clone --recursive https://git.sr.ht/~fitzsim/cl-starter-script && \
	./cl-starter-script/start.lisp --help

If pasting that doesn't work, complain by filing a
[todo](https://todo.sr.ht/~fitzsim/cl-starter-script).

If the SBCL installation and Git clone succeed, you should see:

	Compiling, please wait up to 30 seconds...
	Usage: start [-he] [OPTIONS] FILES...

	Template utility script.
	Flags:
	  -h, --help                  display this help text and exit
	  -e, --example               an example flag option
	Options:
	  -f, --file=FILE             an example FILE option
	                              Default: file.txt

# It's a start...

Features:

* Template for a small Common Lisp utility script.

* Meant to be renamed and hacked up.

* Runnable from the command line.

* Loadable in a REPL.

* SBCL and GNU CLISP support, so far.

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

# Learning resources

A great introduction to Common Lisp; explains ASDF and Quicklisp
better than anything else I've read:

[A Road to Common Lisp](https://stevelosh.com/blog/2018/08/a-road-to-common-lisp/)

This PDF fosters a practical understanding of Common Lisp packges.  I
haven't found it available as a web page:

[The Complete Idiot’s Guide to Common LispPackages](http://index-of.es/Programming/Lisp/Lisp%20Mess/Erann%20Gat%20-%20Idiots%20Guide%20To%20Lisp%20Packages.pdf))

Refer to this page to set up a Common Lisp environment on a new
machine:

[lisp-lang.org Getting Started](https://lisp-lang.org/learn/getting-started/)
