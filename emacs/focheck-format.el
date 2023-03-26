;;;; focheck-format.el --- Format an XSL-FO document
;; $Id: focheck-format.el,v 1.3 2003/06/05 22:13:01 tonygraham Exp $

;; Copyright (C) 2018-2023 Antenna House

;; Author: Tony Graham, Antenna House <tgraham@antenna.co.jp>
;; Contributors: 
;; Created: 12 October 2018
;; Keywords: languages, xsl-fo, xml

;;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


;;;; Commentary:

;; Originally copied almost wholesale from xslide-process.el by Tony
;; Graham that was itself originally copied almost wholesale from
;; psgml.el by Lennart Staflin.  Updated to use `compilation-start`
;; then made to work by copying bits from `grep-mode'.


;;;; Variables:

(defcustom fo-offer-save t
  "*If non-nil, ask about saving modified buffers before \\[fo-format] is run."
  :type '(choice (const :tag "Yes" t) (const :tag "No" nil))
  :group 'fo-format)

(defcustom fo-format-browse-output nil
  "*If non-nil, open output in browser after \\[fo-format] is run."
  :type '(choice (const :tag "Yes" t) (const :tag "No" nil))
  :group 'fo-format)

(defcustom fo-format-find-output nil
  "*If non-nil, find output file after \\[fo-format] is run."
  :type '(choice (const :tag "Yes" t) (const :tag "No" nil))
  :group 'fo-format)

(defcustom fo-format-command
  (list
   ;; Antenna House Formatter GUI on Windows (opens in already-running
   ;; AHFormatter)
   "AHFormatter -s -d %f"
   ;; Antenna House Formatter on Windows
   "AHFCmd -x 4 -d %f -o %o"
   ;; Antenna House Formatter GUI on Windows
   "run.sh -x 4 -d %f -o %o"
   )
  "*The shell command to format an XSL document.

This is a `format' control string that by default should contain three
`%s' conversion specifications: the first will be replaced by the
value of `fo-format-input-file' \(or the empty string, if nil\); the
second will be replaced by `fo-format-stylesheet-file' \(or the empty
string, if nil\); the third will be replaced by
`fo-format-output-file' \(or the empty string, if nil\).

If `fo-format-files' is non-nil, the format string should contain
one `%s' conversion specification for each element of its result.

If `fo-format-command' is a list, then every element should be a
string.  The strings will be tried in order and %-sequences in the
string will be replaced according to the list below, if the string contains
%-sequences with no replacement value the next string will be tried.

%b means the visited file of the current buffer
%i means the value of `fo-format-input-file'
%s means the value of `fo-format-stylesheet-file'
%f means the value of `fo-format-fo-file'
%o means the value of `fo-format-output-file'
"
  :type '(repeat :tag "Commands" string)
  :group 'fo-format)

(defvar fo-format-files nil
  "If non-nil, a function of no arguments that returns a list of file names.
These file names will serve as the arguments to the `fo-format-command'
format control string instead of the defaults.")

(defcustom fo-format-error-regexps
  '(
    ;; AHFCmd
    ;;   AHFCmd :WARNING: Error Level : 2
    ;;   AHFCmd :WARNING: Error Code  : 10754 (2A02)
    ;;   AHFCmd :WARNING: Unknown property: 'leader-alignment1'.
    ;;   AHFCmd :WARNING: Line 64, Col 60, e:\Projects\...\test.fo
    ("^AHFCmd :\\(ERROR\\|WARNING\\): Line \\([0-9]+\\), Col \\([0-9]+\\), \\(\\([A-Za-z]:\\)?[^:]+\\.\\(fo\\|html\\)\\)$"
     4 2 3)

    ;; Generic
    (".*\\<file:\\(\\(/[A-Za-z]:\\)?[^:]+\\):[ \t]*\\(\\([0-9]+\\):[ \t]*\\(\\([0-9]+\\):\\)?\\)?"
     1 4 6)
    (".*\\([^ ]+\\.x[ms]l\\):[ \t]*\\([0-9]+\\):[ \t]*\\(\\([0-9]+\\):\\)?"
     1 2 4)
    ("^\\([^:]+\\): \\([0-9]+\\): error:"
     1 2)
    )
  "*Alist of regexps to recognize error messages from `fo-format'.
See `compilation-error-regexp-alist'."
  :type '(repeat :tag "Regexps"
		 (list (regexp :tag "Regexp")
		       (integer :tag "File index")
		       (integer :tag "Line index")
		       (choice :tag "Column index"
			       (integer)
			       (const :tag "None" nil))))
  :group 'fo-format)

(defvar fo-xml-source nil
  "*If non-nil, this is the name of the XML source file.")
(put 'fo-xml-source 'fo-type 'string)

(defvar fo-fo-result nil
  "*If non-nil, this is the name of the XSL result file.")
(put 'fo-fo-result 'fo-type 'string)

(defvar fo-format-command-history nil
  "The minibuffer history list for `fo-format''s COMMAND argument.")
;;(make-variable-buffer-local 'fo-format-command-history)

(eval-and-compile
  (autoload 'compilation-start "compile" ""))

(defun fo-subst-expand-char (c parts)
  (cdr-safe (assq (downcase c) parts)))

(defun fo-subst-expand (s parts)
  (loop for i from 0 to (1- (length s))
	as c = (aref s i)
	concat (if (eq c ?%)
		   (or (fo-subst-expand-char (aref s (incf i)) parts)
		       (return nil)) 
		 (char-to-string (aref s i)))))

(defun fo-populate-format-command-history ()
  (cond
   ((consp fo-format-command)
    (let ((format-subst
	   (list
	    (cons ?b (and (buffer-file-name)
			  (file-name-nondirectory (buffer-file-name))))
	    (cons ?i fo-format-input-file)
	    (cons ?s fo-format-stylesheet-file)
	    (cons ?f fo-format-fo-file)
	    (cons ?o fo-format-output-file))))
      (setq fo-format-command-history
	    (append
	     (mapcar (lambda (x)
		       (fo-subst-expand x format-subst))
		     fo-format-command)
	     fo-format-command-history))))
;;      (loop for template in fo-format-command
;;	    append
;;	    (fo-subst-expand template format-subst)
;;	    into
;;	    fo-format-command-history)))
   (t
    (apply 'format fo-format-command
	   (if fo-format-files
	       (funcall fo-format-files)
	     (list (or fo-xml-source "")
		   (let ((name (buffer-file-name)))
		     (if name
			 (file-name-nondirectory name)
		       ""))
		   (or fo-fo-result "")))))))

(defvar fo-format-input-file nil
  "Filename of input file for `fo-format' command")

(defvar fo-format-input-history nil
  "The minibuffer history list for `fo-get-format-parameters''s INPUT argument.")

(defvar fo-format-stylesheet-file nil
  "Filename of stylesheet file for `fo-format' command")

(defvar fo-format-stylesheet-history nil
  "The minibuffer history list for `fo-get-format-parameters''s STYLESHEET argument.")

(defvar fo-format-fo-history nil
  "The minibuffer history list for `fo-get-format-parameters''s FO argument.")

(defvar fo-format-output-file nil
  "Filename of output file for `fo-format' command")

(defvar fo-format-output-history nil
  "The minibuffer history list for `fo-get-format-parameters''s OUTPUT argument.")

(defun fo-get-format-parameters ()
  "Get and set the parameters for the `fo-format' command"
  (interactive)
  (setq fo-format-input-file
	(fo-read-from-minibuffer "Input file: "
			      (concat (file-name-sans-extension
				       (file-name-nondirectory
					(buffer-file-name)))
				      ".xml")
			      'fo-format-input-history))
  (setq fo-format-stylesheet-file
	(fo-read-from-minibuffer "Stylesheet file: "
			      (concat (file-name-sans-extension
				       (file-name-nondirectory
					(buffer-file-name)))
				      ".xsl")
			      'fo-format-stylesheet-history))
  (setq fo-format-fo-file
	(fo-read-from-minibuffer "FO file: "
			      (file-name-nondirectory
			       (buffer-file-name))
			      'fo-format-fo-history))
  (setq fo-format-output-file
	(fo-read-from-minibuffer "Output file: "
			      (concat (file-name-sans-extension
				       (file-name-nondirectory
					fo-format-input-file))
				      ".pdf")
			      'fo-format-output-history)))

(defun fo-format (command)
  "Format an XSL stylesheet.

Runs COMMAND, a shell command, in a separate format
asynchronously with output going to the buffer *focheck format*.
You can then use the command \\[next-error] to find the next
error message and move to the line in the XSL document that
caused it.

The first time that the program is run and whenever you provide a
prefix argument, e.g. \\[universal-argument] \\[fo-format],
prompts for FO filename, output filename, input filename, and
stylesheet file.  Those values are used with the templates in
`fo-format-command' to populate this command's command history
with the command lines to run several XSL-FO formatters using
those values.  Use M-p and M-n to step through the predefined
commands, edit a command if necessary, or enter a new command
line.  The next time that this command is run, the previously
executed command is used as the default.

If `fo-format-browse-output' is non-nil, the filename entered in
response to the \"Output file:\" prompt is opened in a browser using
`browse-url'.

If `fo-format-view-output' is non-nil, the filename entered in
response to the \"Output file:\" prompt is opened in a buffer."
  (interactive
   (list (progn
	   (if (or
		current-prefix-arg
		(null fo-format-command-history))
	       (progn
		 (fo-get-format-parameters)
		 (fo-populate-format-command-history)))
	   (read-from-minibuffer "Format command: "
				     (car fo-format-command-history)
				     nil nil
				     'fo-format-command-history))))
  (if fo-offer-save
      (save-some-buffers nil nil))
  ;; (compile-internal command "No more errors" "FO format"
  ;; 		    nil
  ;; 		    fo-format-error-regexps)
  (compilation-start command 'fo-format-mode (lambda (mode-name) "FO format"))
  (if fo-format-browse-output
      (browse-url fo-format-output-file))
  (if fo-format-find-output
      (switch-to-buffer
       (find-file-noselect (expand-file-name fo-format-output-file)))))



(define-compilation-mode fo-format-mode "focheck format"
  "Major mode for formatting XSL-FO."
    (set (make-local-variable 'compilation-error-regexp-alist)
	 fo-format-error-regexps))

(provide 'focheck-format)
