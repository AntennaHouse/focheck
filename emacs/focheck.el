;;;; focheck.el --- XSL Integrated Development Environment
;; Copyright (C) 1998, 1999, 2000, 2001, 2003, 2011, 2013 Tony Graham

;; Author: Tony Graham, Antenna House <tgraham@antenna.co.jp>
;; Contributors: 
;; Created: 5 June 2016
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


(require 'flymake)

;;; Customization

(defgroup focheck nil
  "XSL-FO editing mode."
  :group 'languages)

(defcustom focheck-home nil
  "focheck home directory."
  :group 'focheck
  :type '(directory :must-match t))

(defcustom focheck-saxon nil
  "Location of Saxon 9 executable for use with Schematron."
  :group 'focheck
  :type '(file :must-match t))

(defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
(ad-activate 'flymake-post-syntax-check)

(defun flymake-focheck-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
     	 (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name)))
	 (build-file (concat focheck-home "build-focheck.xml")))
;;;    (list "java" (list "-jar" focheck-saxon "-l:on" local-file (concat focheck-home "build/schematron.xsl")))))
    ;; cmd /c ant.bat -emacs -f C:/projects/oxygen/focheck/build-focheck.xml schematron.single -Dsingle=C:/projects/oxygen/focheck/test/samples/test.fo
    (list "cmd" (list "/c" "ant.bat" "-emacs" "-f" build-file "schematron.single" (concat "-Dsingle=" local-file) ))))

(add-to-list 'flymake-allowed-file-name-masks
      '(".+\\.fo$"
	flymake-focheck-init
	flymake-simple-cleanup
	flymake-get-real-file-name))

(add-hook 'focheck-mode-hook
	  'flymake-mode)

(define-derived-mode fo-mode nxml-mode "focheck"
  "Major mode for editing XSL-FO."
  (setq rng-schema-locating-files
	(add-to-list 'rng-schema-locating-files
		     (locate-file "focheck-schemas.xml" load-path)))
  (rng-auto-set-schema)
  (setq imenu-create-index-function 'xsl-imenu-create-index-function)
  (setq imenu-extract-index-name-function 'xsl-imenu-create-index-function)
  (modify-syntax-entry ?' "."))


(provide 'fo-mode)

;;; focheck.el ends here
