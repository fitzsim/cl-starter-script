#| run-tests.lisp --- test start.lisp
export __CL_ARGV0="$0"
type sbcl  >/dev/null 2>&1 && exec sbcl  --script "$0" "$@"
type clisp >/dev/null 2>&1 && exec clisp          "$0" "$@"
type ecl   >/dev/null 2>&1 && exec ecl   --shell  "$0" "$@"
echo "Install one of (sbcl clisp ecl)."; exit 1
Copyright 2021 Thomas Fitzsimmons
SPDX-License-Identifier: Apache-2.0 |#
(cl:in-package #:cl-user) ; for systems that assume :cl is :use'd at load time
(setf *compile-verbose* nil *compile-print* nil *load-verbose* nil ; silence
      *load-pathname* (truename *load-pathname*)) ; for :here
(require "asdf") ; also loads uiop package
(asdf:initialize-source-registry ; use Git submodules
 '(:source-registry :ignore-inherited-configuration (:tree :here)))
(asdf:load-systems :unix-opts :with-user-abort)
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
  (let ((lisps '("sbcl" "clisp" "ecl"))
        (outputs (make-hash-table :test #'equal))
        (optionss '(" --help" " -l 3" " -l 3 --output file.txt"))
        (times (make-hash-table :test #'equal)))
    (dolist (lisp lisps)
      (format t "Test ~a~a~%" lisp " --verbose")
      (unnuke lisp)
      (time (uiop:run-program
             (concatenate 'string "./start.lisp --verbose")
             :output *standard-output*
             :error-output *standard-output*)))
    (dolist (options optionss)
      (dolist (lisp lisps)
        (format t "Test ~a~a~%" lisp options)
        (unnuke lisp)
        (setf
         (gethash lisp outputs)
         (with-output-to-string (out)
           (setf (gethash lisp times)
                 (time (uiop:run-program
                        (concatenate 'string "./start.lisp" options)
                        :output out :error-output out))))))
      (loop for lisp1 in lisps
            do (loop for lisp2 in (delete lisp1 (copy-list lisps))
                     do (when (not (equal (gethash lisp1 outputs)
                                          (gethash lisp2 outputs)))
                          (format t "~a ~a/~a~a:~%~a:~%~a~%~a:~%~a~%"
                                  "FAIL" lisp1 lisp2 options
                                  lisp1 (gethash lisp1 outputs)
                                  lisp2 (gethash lisp2 outputs))
                          (unnuke)
                          (uiop:quit 1)))
               (format t "Pass ~a~a~%" lisp1 options))))
  (unnuke)
  (when (uiop:argv0) (uiop:quit)))
(when (uiop:argv0) (handler-case (with-user-abort:with-user-abort (main))
                        (with-user-abort:user-abort () (uiop:quit 1))))
