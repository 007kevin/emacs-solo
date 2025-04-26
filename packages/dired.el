;;; packages/dired.el --- Directory editor configuration  -*- lexical-binding: t; -*-

;;; Commentary:
;; Settings for dired directory editor.

;;; Code:

(use-package dired
  :after emacs
  :ensure nil
  :bind
  (("<f2>" . my/dired-jump-reuse)
    ("RET" . dired-find-alternate-file)
    :map dired-mode-map
    ("d" . my/dired-dotfiles-toggle))
  :custom
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer nil)
  (dired-hide-details-hide-absolute-location t)            ; EMACS-31
  :init
  (setq my-dired-switches-no-dotfiles   "-Bhl --group-directories-first -v")
  (setq my-dired-switches-show-dotfiles "-Bhl --group-directories-first -v -A")
  (setq dired-listing-switches my-dired-switches-no-dotfiles)

  (defun my/dired-dotfiles-toggle ()
    "Show/hide dot-files"
    (interactive)
    (when (equal major-mode 'dired-mode)
      (if (equal dired-listing-switches my-dired-switches-no-dotfiles)
          (progn
            (dired-sort-other my-dired-switches-show-dotfiles)
            (setq dired-listing-switches my-dired-switches-show-dotfiles))
        (progn
          (dired-sort-other my-dired-switches-no-dotfiles)
          (setq dired-listing-switches my-dired-switches-no-dotfiles))
        )))

  (defun my/not-root () (unless (string= dired-directory "/") t))
  (defun my/dired-jump-reuse ()
    (interactive)
    (if (and (derived-mode-p 'dired-mode)
             (= (length (get-buffer-window-list)) 1))
        (if (my/not-root)
            (let ((dir (expand-file-name dired-directory)))
              (find-alternate-file "..")
              (dired-goto-file dir)))
    (dired-jump)))
  )

;;; EMACS-SOLO-DIRED-ICONS
;;
(use-package emacs-solo-dired-icons
  :ensure nil
  :no-require t
  :defer t
  :init
  (defvar emacs-solo/dired-icons-file-icons
    '(("el" . "📜")      ("rb" . "💎")      ("js" . "⚙️")      ("ts" . "⚙️")
      ("json" . "🗂️")    ("md" . "📝")      ("txt" . "📝")     ("html" . "🌐")
      ("css" . "🎨")     ("scss" . "🎨")    ("png" . "🖼️")    ("jpg" . "🖼️")
      ("jpeg" . "🖼️")   ("gif" . "🖼️")    ("svg" . "🖼️")    ("pdf" . "📄")
      ("zip" . "📦")     ("tar" . "📦")     ("gz" . "📦")      ("bz2" . "📦")
      ("7z" . "📦")      ("org" . "🗒️")    ("sh" . "💻")      ("c" . "🔧")
      ("h" . "📘")       ("cpp" . "➕")     ("hpp" . "📘")     ("py" . "🐍")
      ("java" . "☕")    ("go" . "🌍")      ("rs" . "💨")      ("php" . "🐘")
      ("pl" . "🐍")      ("lua" . "🎮")     ("ps1" . "🔧")     ("exe" . "⚡")
      ("dll" . "🔌")     ("bat" . "⚡")      ("yaml" . "⚙️")    ("toml" . "⚙️")
      ("ini" . "⚙️")     ("csv" . "📊")     ("xls" . "📊")     ("xlsx" . "📊")
      ("sql" . "🗄️")    ("log" . "📝")     ("apk" . "📱")     ("dmg" . "💻")
      ("iso" . "💿")     ("torrent" . "⏳") ("bak" . "🗃️")    ("tmp" . "⚠️")
      ("desktop" . "🖥️") ("md5" . "🔐")     ("sha256" . "🔐")  ("pem" . "🔐")
      ("sqlite" . "🗄️")  ("db" . "🗄️")
      ("mp3" . "🎶")     ("wav" . "🎶")     ("flac" . "🎶")
      ("ogg" . "🎶")     ("m4a" . "🎶")     ("mp4" . "🎬")     ("avi" . "🎬")
      ("mov" . "🎬")     ("mkv" . "🎬")     ("webm" . "🎬")    ("flv" . "🎬")
      ("ico" . "🖼️")     ("ttf" . "🔠")     ("otf" . "🔠")     ("eot" . "🔠")
      ("woff" . "🔠")    ("woff2" . "🔠")   ("epub" . "📚")    ("mobi" . "📚")
      ("azw3" . "📚")    ("fb2" . "📚")     ("chm" . "📚")     ("tex" . "📚")
      ("bib" . "📚")     ("apk" . "📱")     ("rar" . "📦")     ("xz" . "📦")
      ("zst" . "📦")     ("tar.xz" . "📦")  ("tar.zst" . "📦") ("tar.gz" . "📦")
      ("tgz" . "📦")     ("bz2" . "📦")     ("mpg" . "🎬")     ("webp" . "🖼️")
      ("flv" . "🎬")     ("3gp" . "🎬")     ("ogv" . "🎬")     ("srt" . "🔠")
      ("vtt" . "🔠")     ("cue" . "📀"))
    "Icons for specific file extensions in Dired.")

  (defun emacs-solo/dired-icons-icon-for-file (file)
    (if (file-directory-p file)
        "📁"
      (let* ((ext (file-name-extension file))
             (icon (and ext (assoc-default (downcase ext) emacs-solo/dired-icons-file-icons))))
        (or icon "📄"))))

  (defun emacs-solo/dired-icons-icons-regexp ()
    "Return a regexp that matches any icon we use."
    (let ((icons (mapcar #'cdr emacs-solo/dired-icons-file-icons)))
      (concat "^\\(" (regexp-opt (cons "📁" icons)) "\\) ")))

  (defun emacs-solo/dired-icons-add-icons ()
    "Add icons to filenames in Dired buffer."
    (when (derived-mode-p 'dired-mode)
      (let ((inhibit-read-only t)
            (icon-regex (emacs-solo/dired-icons-icons-regexp)))
        (save-excursion
          (goto-char (point-min))
          (while (not (eobp))
            (condition-case nil
                (when-let ((file (dired-get-filename nil t)))
                  (dired-move-to-filename)
                  (unless (looking-at-p icon-regex)
                    (insert (concat (emacs-solo/dired-icons-icon-for-file file) " "))))
              (error nil))  ;; gracefully skip invalid lines
            (forward-line 1))))))

  (add-hook 'dired-after-readin-hook #'emacs-solo/dired-icons-add-icons))

;;; dired.el ends here
