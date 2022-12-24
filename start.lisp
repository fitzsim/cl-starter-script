#| A single-file self-contained Common Lisp script template.
export __CL_ARGV0="$0"
type sbcl  >/dev/null 2>&1 && exec sbcl  --script "$0" "$@"
type clisp >/dev/null 2>&1 && exec clisp          "$0" "$@"
type ecl   >/dev/null 2>&1 && exec ecl   --shell  "$0" "$@"
echo "Install one of (sbcl clisp ecl)."; exit 1
Copyright 2021-2022 Thomas Fitzsimmons
SPDX-License-Identifier: Apache-2.0 |#
(cl:in-package #:cl-user) ; for systems that assume :cl is :use'd at load time
(setf *compile-verbose* nil *compile-print* nil *load-verbose* nil) ; silence
(defconstant *program-name* (pathname-name *load-truename*))
(defconstant *program-package* (string-upcase *program-name*))
(require "asdf") (setf *load-pathname* (truename *load-pathname*)) ; for :here
(let ((dot '(:source-registry :ignore-inherited-configuration (:tree :here))))
  (asdf:initialize-source-registry dot)) ; use Git submodules
(with-output-to-string (*standard-output*) ; suppress warnings
  (asdf:load-systems :unix-opts :with-user-abort))
(eval `(defpackage ,*program-package*)) (eval `(in-package ,*program-package*))
(opts:define-opts
  (:name :help :description "print this help text" :short #\h :long "help")
  (:name :verbose :description "verbose output" :short #\v :long "verbose")
  (:name :level :description "run at LEVEL" :short #\l :long "level"
   :arg-parser #'cl:parse-integer :meta-var "LEVEL")
  (:name :output :description "output to FILE" :short #\o :long "output"
   :arg-parser #'cl:identity :meta-var "FILE"))
(cl:defun main () "Entry point for the script."
  (cl:multiple-value-bind (options arguments) (opts:get-opts)
    (cl:cond
      ((cl:getf options :help)
       (opts:describe :tagline (cl:format cl:nil "Common Lisp script~%")
                      :usage-of (uiop:argv0) :args "[REST]" :suffix "Change."))
      ((cl:getf options :verbose)
       (cl:format cl:t "Lisp:~14T~A~%" (cl:lisp-implementation-type))
       (cl:format cl:t "Lisp version: ~A~%" (cl:lisp-implementation-version))
       (cl:format cl:t "ASDF version: ~A~%" (asdf:asdf-version)))
      (cl:t (cl:format cl:t "Script full path:~22T~A~%" cl:*load-pathname*)
            (cl:format cl:t "Script argument 0:~22T~A~%" (uiop:argv0))
            (cl:format cl:t "Command line options:")
            (cl:dolist (option options) (cl:print option)) (cl:terpri)
            (cl:format cl:t "Remainder:~22T~A~%" arguments))))
  (cl:when (uiop:argv0) (uiop:quit)))
(cl:when (uiop:argv0) (cl:handler-case (with-user-abort:with-user-abort (main))
                        (with-user-abort:user-abort () (uiop:quit 1))))
