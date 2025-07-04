;;;; focheck.el --- XSL-FO mode
;; Copyright (C) 2016-2025 Antenna House

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


(require 'compile)
(require 'flymake-proc)

(require 'focheck-format "focheck-format")

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

(defcustom focheck-template-file
  (locate-library "../template/XSL-FO.fo" t)
  "*File containing initial FO stylesheet inserted into empty `focheck' buffers."
  :type '(choice (file :must-match t) (const :tag "No initial FO file" nil))
  :group 'xsl)

(defcustom focheck-template-file-initial-point 460
  "*Initial position of point in initial FO stylesheet."
  :type '(integer)
  :group 'xsl)

(defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
(ad-activate 'flymake-post-syntax-check)

(defun flymake-focheck-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
     	 (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name)))
	 (build-file (locate-library "../build-focheck.xml")))
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


(defun fo-read-from-minibuffer (prompt default history)
  "Read from minibuffer with default and command history."
(let ((value nil))
  (if (string-equal
       ""
       (setq value
	     (read-from-minibuffer (if default
				       (format
					"%s(default `%s') "
					prompt default)
				     (format "%s" prompt))
				   nil nil nil
				   history)))
	     default
	     value)))



(defun lorem-ipsum-fo-mode-hook ()
  "Set some variables for lorem-ipsum in `fo-mode'."
  (setq lorem-ipsum-paragraph-separator "</fo:block>\n<fo:block>"
	lorem-ipsum-sentence-separator " "
	lorem-ipsum-list-beginning "<fo:list-block>\n"
	lorem-ipsum-list-bullet "<fo:list-item>\n<fo:list-item-label><fo:block>*</fo:block></fo:list-item-label>\n<fo:list-item-body><fo:block>"
	lorem-ipsum-list-item-end "</fo:block></fo:list-item-body>\n</fo:list-item>\n"
	lorem-ipsum-list-end "</fo:list-block>\n"))

(add-hook 'fo-mode-hook #'lorem-ipsum-fo-mode-hook)



(define-derived-mode fo-mode nxml-mode "focheck"
  "Major mode for editing XSL-FO."
  (setq rng-schema-locating-files
	(add-to-list 'rng-schema-locating-files
		     (locate-file "focheck-schemas.xml" load-path)))
  (rng-auto-set-schema)
  ;;(setq imenu-create-index-function 'xsl-imenu-create-index-function)
  ;;(setq imenu-extract-index-name-function 'xsl-imenu-create-index-function)
  (modify-syntax-entry ?' ".")
  (if (and
       focheck-template-file
       (eq (point-min) (point-max)))
      (progn
	(insert-file-contents focheck-template-file)
	(goto-char focheck-template-file-initial-point))))


(provide 'fo-mode)

;;; focheck.el ends here
