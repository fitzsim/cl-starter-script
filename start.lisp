#| start.lisp --- a single-file self-contained Common Lisp script template
export __CL_ARGV0="$0"
type sbcl  >/dev/null 2>&1 && exec sbcl  --script "$0" "$@"
type clisp >/dev/null 2>&1 && exec clisp          "$0" "$@"
Copyright 2021 Thomas Fitzsimmons
SPDX-License-Identifier: Apache-2.0 |#
;;; Load dependee systems.
(cl:in-package #:cl-user) ; for systems that assume :cl is :use'd at load time
(setf *compile-verbose* nil *compile-print* nil)
(setf *load-pathname* (truename *load-pathname*)) ; for :here
(require "asdf") ; also loads uiop package
(unless (uiop:directory-exists-p (merge-pathnames
				  (uiop:relativize-pathname-directory
				   (uiop:pathname-directory-pathname
				    *load-pathname*))
				  asdf:*user-cache*))
  (format *error-output* "Compiling, please wait up to 30 seconds...~%"))
(asdf:initialize-source-registry
 '(:source-registry :ignore-inherited-configuration (:tree :here)))
(let ((*error-output* (make-string-output-stream)) ; version parsing
      (*debug-io* (make-string-output-stream))) ; grovel cc
  (ignore-errors ; if missing cc
   (asdf:load-system :net.didierverna.clon))) ; FIXME: clisp cc stderr
(net.didierverna.clon:nickname-package)
(asdf:load-system :with-user-abort)
;;; Actual script follows.
(defpackage #:start)
(in-package #:start)
(clon:defsynopsis (:postfix "FILES...")
  (text :contents "Template utility script.")
  (group (:header "Flags:")
	 (flag :short-name "h" :long-name "help"
	       :description "display this help text and exit")
	 (flag :short-name "e" :long-name "example"
	       :description "an example flag option"))
  (group (:header "Options:")
	 (path :short-name "f" :long-name "file"
	       :description "an example FILE option"
	       :argument-name "FILE" :type :file :default-value #p"file.txt")))
(cl:defun main ()
  "Entry point for the script."
  (clon:make-context :progname :environment)
  (cl:cond ((clon:getopt :short-name "h")
	    (clon:help))
	   (cl:t
	    (cl:format cl:t "Script full path:     ~A~%" cl:*load-pathname*)
	    (cl:format cl:t "Script argument 0:    ~A~%" (uiop:argv0))
	    (cl:format cl:t "ASDF version:         ~A~%" (asdf:asdf-version))
	    (cl:format cl:t "Program name:         ~A~%" (clon:progname))
	    (cl:format cl:t "Command line options:")
	    (clon:do-cmdline-options (option name value source)
	      (cl:print (cl:list option name value source)))
	    (cl:terpri)
	    (cl:format cl:t "Remainder:            ~A~%" (clon:remainder))
	    (cl:format cl:t "Lisp implementation:  ~A~%"
		       (cl:lisp-implementation-type))
	    (cl:format cl:t "Lisp version:         ~A~%"
		       (cl:lisp-implementation-version))))
  (cl:when (uiop:argv0) (uiop:quit)))
(cl:when (uiop:argv0)
  (cl:handler-case
      (with-user-abort:with-user-abort
	(main))
    (with-user-abort:user-abort () (uiop:quit 1))))
