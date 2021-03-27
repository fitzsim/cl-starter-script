#| start.lisp --- a single-file self-contained Common Lisp script template
export __CL_ARGV0="$0"
type sbcl  >/dev/null 2>&1 && exec sbcl  --script "$0" "$@"
type clisp >/dev/null 2>&1 && exec clisp          "$0" "$@"

Copyright (C) 2021 Thomas Fitzsimmons

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
|#

;; Many ASDF systems assume that asdf:load-system is called from
;; within the :common-lisp-user package.
(cl:in-package #:cl-user)

(cl:setf cl:*compile-verbose* cl:nil) ; output to *error-output* instead?
(cl:setf cl:*compile-print* cl:nil)

#+clisp (cl:setf cl:*load-pathname* (cl:truename cl:*load-pathname*)) ; :here

(cl:require "asdf")
(cl:unless (uiop:directory-exists-p
	    (cl:merge-pathnames
	     (uiop:relativize-pathname-directory
	      (uiop:pathname-directory-pathname
	       cl:*load-pathname*))
	     asdf:*user-cache*))
  (cl:format cl:*error-output*
	     "Compiling, should take less than 30 seconds...~%"))
(asdf:initialize-source-registry
 '(:source-registry :ignore-inherited-configuration (:tree :here)))
(cl:let ((cl:*error-output* (cl:make-string-output-stream)) ; version parsing
	 #+clisp (cl:*debug-io* (cl:make-string-output-stream))) ; grovel cc
  (asdf:load-system :net.didierverna.clon))
(asdf:load-system :with-user-abort)

(cl:defpackage #:start)
(cl:in-package #:start)

(net.didierverna.clon:nickname-package)

(clon:defsynopsis (:postfix "FILES...")
  (text :contents "Starter utility script.")
  (group (:header "Flags:")
	 (flag :short-name "h" :long-name "help"
	       :description "Print this help and exit.")
	 (flag :short-name "q" :long-name "quiet"
	       :description "Print fewer messages."))
  (group (:header "Options:")
	 (path :short-name "f" :long-name "file"
	       :description "Output to FILE."
	       :argument-name "FILE"
	       :type :file
	       :default-value #p"output.txt")))

(cl:defun main ()
  "Entry point for the script."
  (clon:make-context :progname :environment)
  (cl:cond ((clon:getopt :short-name "h")
	    (clon:help))
	   ((cl:not (clon:getopt :short-name "q"))
	    (cl:format cl:t "Script full path:  ~A~%" cl:*load-pathname*)
	    (cl:format cl:t "Script argument 0: ~A~%" (uiop:argv0))
	    (cl:format cl:t "ASDF version:      ~A~%" (asdf:asdf-version))
	    (cl:format cl:t "Program name:      ~A~%" (clon:progname))
	    (cl:format cl:t "Options:")
	    (clon:do-cmdline-options (option name value source)
	      (cl:print (cl:list option name value source)))
	    (cl:terpri)
	    (cl:format cl:t "Remainder:         ~A~%" (clon:remainder))))
  (cl:when (uiop:argv0)
    (uiop:quit)))

(cl:when (uiop:argv0)
  (cl:handler-case
      (with-user-abort:with-user-abort (main))
    (with-user-abort:user-abort ()
      (uiop:quit 1))))
