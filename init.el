;;; init.el --- Init  -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:

(defun require-all-packages ()
  "Add packages directory to load-path and require all packages in it."
  (interactive)
  (let* ((package-dir (expand-file-name "packages" user-emacs-directory)))
    ;; Add the packages directory to load-path
    (add-to-list 'load-path package-dir)

    ;; Require each package
    (dolist (file (directory-files package-dir t "\\.el$"))
      (let* ((file-name (file-name-nondirectory file))
             (package-name (file-name-sans-extension file-name))
             ;; Keep hyphens in the feature name
             (feature-name (intern (concat "packages/" package-name))))
        (message "Loading %s..." feature-name)
        (condition-case err
            (require feature-name)
          (error (message "Error loading %s: %s" feature-name err)))))))

;; Call the function to load all packages
(require-all-packages)
;;; init.el ends here