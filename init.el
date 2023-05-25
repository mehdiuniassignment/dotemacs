(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package emacs
  :init
  (column-number-mode 1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (windmove-default-keybindings)
  (winner-mode 1)
  (column-number-mode 1)
  (global-hl-line-mode 1)
  (show-paren-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (delete-selection-mode 1)
  (make-directory "~/.cache/emacs/backup" t)
  (make-directory "~/.cache/emacs/autosave" t)
  :config
  (set-face-attribute 'default nil
		      :family "JetBrains Mono"
		      :slant 'normal
		      :weight 'normal
		      :height 115)
  (set-language-environment "UTF-8")
  :hook
  (prog-mode . display-line-numbers-mode)
  :custom
  (warning-minimum-level :error)
  (use-dialog-box nil)
  (use-file-dialog nil)
  (inhibit-startup-screen t)
  (initial-scratch-message nil)
  (ring-bell-function 'ignore)
  (frame-title-format "%b - GNU Emacs")
  (use-short-answers t)
  (scroll-conservatively 100)
  (truncate-lines 1)
  (truncate-partial-width-windows nil)
  (c-default-style "k&r")
  (c-basic-offset 8)
  (indent-tabs-mode t)
  (backup-directory-alist '(("." . "~/.cache/emacs/backup/")))
  (auto-save-file-name-transforms '((".*" "~/.cache/emacs/autosave/" t))))

(use-package doom-themes
  :ensure t
  :init
  (load-theme 'doom-gruvbox t))

(use-package avy
  :ensure t
  :bind
  (("C-:" . avy-goto-char)
  ("C-'" . avy-goto-char-2)
  ("M-g f" . avy-goto-line)
  ("M-g w" . avy-goto-word-1)))

(use-package multiple-cursors
  :ensure t
  :bind
  (("C-S-SPC" . set-rectangular-region-anchor)
   ("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-c C->" . mc/mark-all-like-this)
   ("C-c C-SPC" . mc/edit-lines)))

(use-package tree-sitter-langs
  :ensure t)

(use-package tree-sitter
  :ensure t
  :init
  (global-tree-sitter-mode)
  :hook
  (tree-sitter-after-on . tree-sitter-hl-mode))

(use-package eglot
  :ensure t
  :hook
  ((c-mode c++-mode) . eglot-ensure)
  (before-save . eglot-format)
  :custom
  (eglot-ignored-server-capabilities '(:inlayHintProvider))
  :bind (:map eglot-mode-map
  ("C-c r" . eglot-rename)
  ("C-c f" . eglot-format)
  ("C-c C-f" . eglot-format-buffer)
  ("C-c q" . eglot-code-action-quickfix)
  ("C-c a" . eglot-code-actions)
  ("C-c e" . eglot-code-action-extract)
  ("C-c i" . eglot-code-action-inline)
  ("C-c C-r" . eglot-code-action-rewrite)
  ("C-c o" . eglot-code-action-organize-imports)))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-count 15)
  (vertico-cycle t))

(use-package vertico-mouse
  :init
  (vertico-mouse-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)) (eglot (styles orderless)))))

(use-package consult
  :ensure t
  :bind (
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c C-i" . consult-info)
         ([remap Info-search] . consult-info)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode)
  :custom
  (marginalia-align 'right))

(use-package all-the-icons-completion
  :ensure t
  :init
  (all-the-icons-completion-mode))

(use-package corfu
  :ensure t
  :bind
  (:map corfu-map ("S-SPC" . corfu-insert-separator))
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  :custom
  (corfu-cycle t)
  (corfu-auto-delay 0)
  (corfu-auto t)
  (corfu-preview-current nil)
  (corfu-popupinfo-delay 0.2)
  (corfu-right-margin-width 1))

(use-package cape
  :ensure t
  :init
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  (kind-icon-blend-background nil)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package yaml-mode
  :ensure t)
