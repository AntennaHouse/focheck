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
(defun flymake-focheck-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
     	 (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name))))
    (list "java" (list "-jar" "E:/saxon/saxon9he.jar" "-l:on" local-file "E:/projects/oxygen/focheck/build/schematron.xsl"))))

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
