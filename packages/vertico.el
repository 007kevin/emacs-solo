;;; packages/vertico.el --- vertico configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Basic Emacs configuration, key bindings, and general settings.

;;; Code:


(use-package vertico
  :ensure t
  :bind
  (("C-c C-r" . vertico-repeat))
  ;;:custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  ;; (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :ensure t
  ;; :custom
  ;; (consult-preview-key "C-<return>")
  :bind
  (("C-c j" . consult-ripgrep)
   ("C-c k" . consult-ripgrep-cwd))
  :config
  (defun consult-ripgrep-cwd ()
    (interactive )
    (consult-ripgrep default-directory))

  (consult-customize
   consult-ripgrep
   consult-ripgrep-cwd
   xref-find-references
   :preview-key "C-<return>"))

;;; vertico.el ends here
