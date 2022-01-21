#| run-tests.lisp --- test start.lisp
export __CL_ARGV0="$0"
type sbcl  >/dev/null 2>&1 && exec sbcl  --script "$0" "$@"
echo "Install sbcl."; exit 1
Copyright 2021 Thomas Fitzsimmons
SPDX-License-Identifier: Apache-2.0 |#
(cl:in-package #:cl-user) ; for systems that assume :cl is :use'd at load time
(setf *load-pathname* (truename *load-pathname*)) ; for :here
(require "asdf") ; also loads uiop package
(asdf:initialize-source-registry ; use Git submodules
 '(:source-registry :ignore-inherited-configuration (:tree :here)))
(asdf:load-systems :with-user-abort)
(defpackage #:run-tests (:use #:cl)) (in-package #:run-tests)
(defun unnuke (&optional lisp)
  (let ((lines (uiop:read-file-lines "start.lisp")))
    (with-open-file  (out "start.lisp" :direction :io :if-exists :supersede)
      (loop for line in lines do
        (cond ((eq 0 (search (concatenate 'string "type ") line))
               (if lisp
                   (if (eq 0 (search (concatenate 'string "type " lisp) line))
                       (write-line line out) ; leave unnuked
                       (write-line (concatenate 'string "#" line) out)) ;; nuke
                   (write-line line out)))
              ((eq 0 (search (concatenate 'string "#type ") line))
               (if lisp
                   (if (eq 0 (search (concatenate 'string "#type " lisp) line))
                       (write-line (subseq line 1) out) ; unnuke
                       (write-line line out)) ; leave nuked
                   (write-line (subseq line 1) out))) ; unnuke all
              (t
               (write-line line out)))))))
(defun main () "Entry point for the script."
  (dolist (lisp '("sbcl" "ecl" "clisp"))
    (unnuke lisp))
  (when (uiop:argv0) (uiop:quit)))
(when (uiop:argv0) (handler-case (with-user-abort:with-user-abort (main))
                        (with-user-abort:user-abort () (uiop:quit 1))))
