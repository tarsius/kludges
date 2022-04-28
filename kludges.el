;;; kludges.el --- Assorted Elisp snippets  -*- lexical-binding:t -*-

;; Copyright (C) 2018-2022 Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Homepage: https://github.com/tarsius/kludges
;; Keywords: local

;; Package-Requires: ((emacs "28.1"))

;; SPDX-License-Identifier: GPL-3.0-or-later

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation, either version 3 of the License,
;; or (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Assorted Elisp snippets intended for my own use.
;; Things may appear and disappear at any time.

;;; Code:

;;;###autoload
(define-minor-mode keyword-plist-mode
  "Change how keyword alists are intended.
This is most useful in libraries that define themes,
where

  (foobar ((t (:foreground \"red\"
               :background \"blue\"))))

looks much better than

  (foobar ((t (:foreground \"red\"
                           :background \"blue\"))))")

(defalias 'keyword-plist--looking-at
  (symbol-function 'looking-at))

(define-advice calculate-lisp-indent
    (:around (fn &optional parse-start) keyword-plist)
  "Change how keyword alists are intended.
This is most useful in libraries that define themes,
where

  (foobar ((t (:foreground \"red\"
               :background \"blue\"))))

looks much better than

  (foobar ((t (:foreground \"red\"
                           :background \"blue\"))))"
  (if keyword-plist-mode
      (cl-letf (((symbol-function 'looking-at)
                 (lambda (regexp)
                   (keyword-plist--looking-at
                    (if (equal regexp "\\s(")
                        "\\(?:\\s(\\|:\\)"
                      regexp)))))
        (funcall fn parse-start))
    (funcall fn parse-start)))

;;; _
(provide 'kludges)
;; Local Variables:
;; eval: (keyword-plist-mode)
;; indent-tabs-mode: nil
;; End:
;;; kludges.el ends here
