This is a small Common Lisp script that can be used as a template.

To try it, first install SBCL, GNU CLISP, or ECL for your
distribution, e.g., run `apt install sbcl` or `dnf install sbcl` as
root.

Then, as a normal user, run:

	git clone -q --recursive https://git.sr.ht/~fitzsim/cl-starter-script && \
	./cl-starter-script/start.lisp --help

and you should see:

	Usage: ./cl-starter-script/start.lisp [-h|--help] [-v|--verbose]
	                                      [-l|--level LEVEL] [-o|--output FILE] [REST]
	Common Lisp script
	
	Available options:
	  -h, --help        print this help text
	  -v, --verbose     verbose output
	  -l, --level LEVEL run at LEVEL
	  -o, --output FILE output to FILE
	
	Change.

If that doesn't work, complain by filing a
[todo](https://todo.sr.ht/~fitzsim/cl-starter-script).

# It's a start...

Features:

* Template for a small Common Lisp utility script.

* Meant to be renamed and hacked up.

* Runnable from the command line.

* Loadable in a REPL.

* SBCL, GNU CLISP and ECL support, so far.

* Self-contained within the checkout directory.

* Runnable without an Internet connection after the first Git clone.

* Command line option parsing support provided by
  [unix-opts](https://github.com/libre-man/unix-opts).

* Experiment with no :use at all, not even :common-lisp.  Interesting,
  but in practice :use :cl and remove cl: prefixes.

# Supported Lisp Implementations as of January 2022

These are tried in order, from fastest to slowest.  A cold run results
from first removing the implementation's ASDF cache, for example by
removing `~/.cache/common-lisp/`, then running:

    ./start.lisp

A warm is the same command after everything is cached.

<table>
  <tr>
    <th style="text-align:left;">Implementation</th>
    <th style="text-align:left;">Version</th>
    <th style="text-align:left;">Cold Run (seconds)</th>
    <th style="text-align:left;">Warm Run (seconds)</th>
  </tr>
  <tr>
    <td>SBCL</td>
    <td>2.1.9.debian</td>
    <td>0.579</td>
    <td>0.579</td>
  </tr>
  <tr>
    <td>GNU CLISP</td>
    <td>2.49.93+ (2018-02-18)</td>
    <td>1.159</td>
    <td>0.871</td>
  </tr>
  <tr>
    <td>ECL</td>
    <td>21.2.1</td>
    <td>3.195</td>
    <td>1.207</td>
  </tr>
</table>

# Alternatives

Check out [cl-launch](https://github.com/fare/cl-launch) which
unfortunately is not widely packaged by distros.

Also look at [Roswell](https://github.com/roswell/roswell) as another
potential basis for Common Lisp scripting and lots more.

# Learning resources

A great introduction to Common Lisp; explains ASDF and Quicklisp
better than anything else I've read:

[A Road to Common Lisp](https://stevelosh.com/blog/2018/08/a-road-to-common-lisp/)

This PDF fosters a practical understanding of Common Lisp packges.  I
haven't found it available as a web page:

[The Complete Idiot’s Guide to Common LispPackages](http://index-of.es/Programming/Lisp/Lisp%20Mess/Erann%20Gat%20-%20Idiots%20Guide%20To%20Lisp%20Packages.pdf)

Refer to this page to set up a Common Lisp environment on a new
machine:

[lisp-lang.org Getting Started](https://lisp-lang.org/learn/getting-started/)
