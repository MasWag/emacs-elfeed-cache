;;; elfeed-cache.el --- Locally cache the enclosure of elfeed -*- lexical-binding:t -*-

;; Copyright (C) 2024 Masaki Waga

;; Maintainer: Masaki Waga
;; Keywords: RSS, elfeed

;; This file is NOT a part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Define functions to save the enclosures of an entry of elfeed <https://github.com/skeeto/elfeed>.

;;; Code:

(require 'elfeed)

(defcustom elfeed-enclosure-cache-dir "~/PodCast/"
  "The directory to save the enclosures of an entry of elfeed."
  :type 'string
  :group 'user)

(defun elfeed-show-play-enclosure (enclosure-index)
    "Play enclosure number ENCLOSURE-INDEX from current entry using EMMS.
Prompts for ENCLOSURE-INDEX when called interactively."
    (interactive (list (elfeed--enclosure-maybe-prompt-index elfeed-show-entry)))
    (elfeed-show-add-enclosure-to-playlist enclosure-index)
    (with-no-warnings
      (when (or (not emms-playlist-buffer)
                (not (buffer-live-p emms-playlist-buffer)))
        (emms-playlist-current-clear))
      (let ((emms-source-old-buffer (or emms-source-old-buffer
                                        (current-buffer))))
        (with-current-buffer emms-playlist-buffer
          (let ((inhibit-read-only t))
            (save-excursion
              (emms-playlist-last)
              (emms-playlist-mode-play-current-track)))))))

(defun elfeed-search-cache-enclosure (&optional use-generic-p)
  "Save the enclosure of the current entry to `elfeed-show-cache-dir'."
  (interactive "P")
  (let ((buffer (current-buffer))
        (entries (elfeed-search-selected)))
    (cl-loop for entry in entries
             ;; do (elfeed-untag entry 'unread)
             when (elfeed-entry-enclosures entry)
             do
             (cl-loop for enclosure in it
                      do
                      (let ((uri (car enclosure)))
                        (let ((filename (concat elfeed-enclosure-cache-dir
                                                (url-file-nondirectory uri))))
                          (message "Download to %s" filename)
                          (url-copy-file uri filename)))))))

(defun elfeed-show-play-enclosure-cache (enclosure-index)
    "Play enclosure number ENCLOSURE-INDEX from current entry using EMMS.
Prompts for ENCLOSURE-INDEX when called interactively."
    (interactive (list (elfeed--enclosure-maybe-prompt-index elfeed-show-entry)))
    (elfeed-show-add-enclosure-cache-to-playlist enclosure-index)
    (with-no-warnings
      (when (or (not emms-playlist-buffer)
                (not (buffer-live-p emms-playlist-buffer)))
        (emms-playlist-current-clear))
      (let ((emms-source-old-buffer (or emms-source-old-buffer
                                        (current-buffer))))
        (with-current-buffer emms-playlist-buffer
          (let ((inhibit-read-only t))
            (save-excursion
              (emms-playlist-last)
              (emms-playlist-mode-play-current-track)))))))

(defun elfeed-show-add-enclosure-cache-to-playlist (enclosure-index)
  "Add the cache of the enclosure number ENCLOSURE-INDEX to current EMMS playlist.
Prompts for ENCLOSURE-INDEX when called interactively."

  (interactive (list (elfeed--enclosure-maybe-prompt-index elfeed-show-entry)))
  (with-no-warnings ;; due to lazy
    (let ((uri (car (elt (elfeed-entry-enclosures elfeed-show-entry)
                         (- enclosure-index 1)))))
      (emms-add-file
       (concat elfeed-enclosure-cache-dir
               (url-file-nondirectory uri))))))

(provide 'elfeed-cache)

;;; elfeed-cache.el ends here

