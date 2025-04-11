;;; packages/emacs-solo-ollama.el --- Ollama LLM integration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Functions for interacting with Ollama LLM models.

;;; Code:

(use-package emacs-solo-ollama
  :ensure nil
  :no-require t
  :defer t
  :init
  (defun emacs-solo/ollama-run-model ()
    "Run `ollama list`, let the user choose a model, and open it in `ansi-term`.
Asks for a prompt when run. If none is passed (RET), starts it interactive.
If a region is selected, prompt for additional input and pass it as a query."
    (interactive)
    (let* ((output (shell-command-to-string "ollama list"))
           (models (let ((lines (split-string output "\n" t)))
                     (mapcar (lambda (line) (car (split-string line))) (cdr lines))))
           (selected (completing-read "Select Ollama model: " models nil t))
           (region-text (when (use-region-p)
                          (shell-quote-argument
                           (replace-regexp-in-string "\n" " "
                                                     (buffer-substring-no-properties
                                                      (region-beginning)
                                                      (region-end))))))
           (prompt (read-string "Ollama Prompt (leave it blank for interactive): " nil nil nil)))
      (when (and selected (not (string-empty-p selected)))
        (ansi-term "/bin/sh")
        (sit-for 1)
        (let ((args (list (format "ollama run %s"
                                  selected))))
          (when (and prompt (not (string-empty-p prompt)))
            (setq args (append args (list (format "\"%s\"" prompt)))))
          (when region-text
            (setq args (append args (list (format "\"%s\"" region-text)))))

          (term-send-raw-string (string-join args " "))
          (term-send-raw-string "\n"))))))

;;; emacs-solo-ollama.el ends here