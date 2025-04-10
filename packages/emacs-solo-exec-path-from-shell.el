;;; packages/emacs-solo-exec-path-from-shell.el --- PATH setup from shell  -*- lexical-binding: t; -*-

;;; Commentary:
;; Loads user's default shell PATH settings into Emacs.
;; Useful when calling Emacs directly from GUI systems.

;;; Code:

(use-package emacs-solo-exec-path-from-shell
  :ensure nil
  :no-require t
  :defer t
  :init
  (defun emacs-solo/set-exec-path-from-shell-PATH ()
    "Set up Emacs' `exec-path' and PATH environment the same as user Shell."
    (interactive)
    (let ((path-from-shell
           (replace-regexp-in-string
            "[ \t\n]*$" "" (shell-command-to-string
                            "$SHELL --login -c 'echo $PATH'"))))
      (setenv "PATH" path-from-shell)
      (setq exec-path (split-string path-from-shell path-separator))
      (message ">>> emacs-solo: PATH loaded")))

  (defun emacs-solo/fix-asdf-path ()
  "Ensure asdf shims and active Node.js version's bin directory are first in PATH."
  (interactive)
  (let* ((asdf-shims (expand-file-name "~/.asdf/shims"))
         (node-bin (string-trim (shell-command-to-string "asdf where nodejs 2>/dev/null")))
         (new-paths (list asdf-shims)))

    ;; If Node.js is installed, add its bin path
    (when (file-directory-p node-bin)
      (push (concat node-bin "/bin") new-paths))

    ;; Remove old asdf-related paths from PATH and exec-path
    (setq exec-path (seq-remove (lambda (p) (string-match-p "/\\.asdf/" p)) exec-path))
    (setenv "PATH" (string-join (seq-remove (lambda (p) (string-match-p "/\\.asdf/" p))
                                            (split-string (getenv "PATH") ":"))
                                ":"))

    ;; Add the new paths to exec-path and PATH
    (dolist (p (reverse new-paths))
      (unless (member p exec-path) (push p exec-path))
      (unless (member p (split-string (getenv "PATH") ":"))
        (setenv "PATH" (concat p ":" (getenv "PATH")))))))

  (add-hook 'find-file-hook #'emacs-solo/fix-asdf-path)
  (add-hook 'eshell-mode-hook #'emacs-solo/fix-asdf-path)
  (add-hook 'eshell-pre-command-hook #'emacs-solo/fix-asdf-path)
  (add-hook 'eshell-directory-change-hook #'emacs-solo/fix-asdf-path)

  (add-hook 'after-init-hook #'emacs-solo/set-exec-path-from-shell-PATH)
  (add-hook 'after-init-hook #'emacs-solo/fix-asdf-path))

(provide 'packages/emacs-solo-exec-path-from-shell)
;;; emacs-solo-exec-path-from-shell.el ends here