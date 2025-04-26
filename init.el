;;; init.el --- Init  -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

(defvar user-external-directory (expand-file-name "external" user-emacs-directory))
(add-to-list 'load-path user-external-directory)

(defun load-packages-directory ()
  "Load all Emacs Lisp files in the 'packages' directory relative to the Emacs directory."
  (interactive)
  (let* ((emacs-dir (file-name-directory (or user-init-file load-file-name)))
         (packages-dir (expand-file-name "packages" emacs-dir))
         (files (and (file-directory-p packages-dir)
                     (directory-files packages-dir t "\\.el$"))))
    (if files
        (dolist (file files)
          (message "Loading %s..." file)
          (condition-case err
              (progn
                (load-file file)
                (message "Loaded %s successfully" file))
            (error
             (message "Error loading %s: %s" file (error-message-string err)))))
      (message "Packages directory not found at %s" packages-dir))))

(load-packages-directory)

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
