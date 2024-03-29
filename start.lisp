#| A single-file self-contained Common Lisp script template.
export __CL_ARGV0="$0"
type sbcl  >/dev/null 2>&1 && exec sbcl  --script "$0" "$@"
type clisp >/dev/null 2>&1 && exec clisp          "$0" "$@"
type ecl   >/dev/null 2>&1 && exec ecl   --shell  "$0" "$@"
echo "Install one of (sbcl clisp ecl)."; exit 1
Copyright 2021-2022 Thomas Fitzsimmons
SPDX-License-Identifier: Apache-2.0 |#

;; Scripting boilerplate.
(cl:in-package #:cl-user) ; for systems that assume :cl is :use'd at load time
(setf *compile-verbose* nil *compile-print* nil *load-verbose* nil ; silence
      *load-pathname* (truename *load-pathname*)) ; for :here
(defconstant *program-name* (pathname-name *load-truename*))
(defconstant *program-package* (string-upcase *program-name*)) (require "asdf")
(let ((dot '(:source-registry :ignore-inherited-configuration (:tree :here))))
  (asdf:initialize-source-registry dot)) ; use Git submodules
(with-output-to-string (*standard-output*) ; suppress warnings
  (asdf:load-systems :unix-opts :with-user-abort))
(eval `(defpackage ,*program-package*)) (eval `(in-package ,*program-package*))

;; Command-line options.
(opts:define-opts
  (:name :help :description "print this help text" :short #\h :long "help")
  (:name :verbose :description "verbose output" :short #\v :long "verbose")
  (:name :level :description "run at LEVEL" :short #\l :long "level"
   :arg-parser #'cl:parse-integer :meta-var "LEVEL")
  (:name :output :description "output to FILE" :short #\o :long "output"
   :arg-parser #'cl:identity :meta-var "FILE"))

;; Main function.
(cl:defun main () "Main function for script, and binary's entry-point."
  (cl:let ((name (uiop:argv0)))
    (cl:multiple-value-bind (options arguments) (opts:get-opts)
      (cl:cond
        ((cl:getf options :help)
         (opts:describe :tagline (cl:format cl:nil "Common Lisp script~%")
                        :usage-of (cl:file-namestring name)
                        :args "[REST]" :suffix "Change."))
        ((cl:getf options :verbose)
         (cl:format cl:t "Lisp:~14T~A~%" (cl:lisp-implementation-type))
         (cl:format cl:t "Lisp version: ~A~%" (cl:lisp-implementation-version))
         (cl:format cl:t "ASDF version: ~A~%" (asdf:asdf-version)))
        (cl:t (cl:format cl:t "Script argument 0:~22T~A~%" name)
              (cl:format cl:t "Command line options:")
              (cl:dolist (option options) (cl:print option)) (cl:terpri)
              (cl:format cl:t "Remainder:~22T~A~%" arguments))))
    (cl:when name (uiop:quit))))

;; Compilation logic.
(cl:let ((name (uiop:argv0)) (out cl-user::*program-name*)
         (package cl-user::*program-package*))
  (cl:when (cl:and name (cl:equal (cl:file-namestring name) "compile.lisp"))
    (cl:setf uiop:*image-entry-point* (cl:intern "MAIN" package))
    (uiop:dump-image out :executable cl:t) ; not supported on ECL.
    (uiop:quit)))

;; Shell script logic.
(cl:when (uiop:argv0) (cl:handler-case (with-user-abort:with-user-abort (main))
                        (with-user-abort:user-abort () (uiop:quit 1))))

;;; Local Variables:
;;; mode: Lisp
;;; syntax: ANSI-Common-Lisp
;;; compile-command: "./compile.lisp"
;;; End:
