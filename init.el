(setq warning-minimum-level :error)
(set-language-environment "UTF-8")

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package emacs
  :init
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (column-number-mode 1)
  (delete-selection-mode 1)
  (show-paren-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (windmove-default-keybindings)
  (winner-mode 1)
  (global-auto-revert-mode t)
  (make-directory "~/.cache/emacs/backup" t)
  (make-directory "~/.cache/emacs/autosave" t)

  :config
  (set-face-attribute 'default nil
                      :family "JetBrains Mono"
                      :slant 'normal
                      :weight 'normal
                      :height 115)

  (set-face-attribute 'mode-line nil
                      :box nil)

  ;; use my style for indenting C

  (defconst my-c-style
    '("k&r"
      (indent-tabs-mode . t)
      (tab-width . 8)
      (c-basic-offset . 8)
      (c-offsets-alist . ((arglist-intro . +)
                          (arglist-cont . 0)
                          (arglist-cont-nonempty . +)
                          (arglist-close . 0)))))
  (c-add-style "my-c-style" my-c-style)

  (defun new-line-bellow ()
    (interactive)
    (end-of-line)
    (newline)
    (indent-for-tab-command))

  (defun new-line-above ()
    (interactive)
    (beginning-of-line)
    (newline)
    (previous-line)
    (indent-for-tab-command))

  (defun copy-line (arg)
    (interactive "p")
    (kill-ring-save (line-beginning-position)
                    (line-beginning-position (+ 1 arg))))

  :hook
  (prog-mode . display-line-numbers-mode)
  (c-mode . (lambda () (c-set-style "my-c-style")))

  :custom
  (indent-tabs-mode nil)
  (use-dialog-box nil)
  (use-file-dialog nil)
  (inhibit-startup-screen t)
  (initial-scratch-message nil)
  (ring-bell-function 'ignore)
  (use-short-answers t)
  (scroll-conservatively 100)
  (truncate-lines 1)
  (truncate-partial-width-windows nil)
  (show-trailing-whitespace t)
  (undo-limit 20000000)
  (undo-strong-limit 40000000)
  (global-auto-revert-non-file-buffers t)
  (auto-revert-verbose nil)
  (backup-directory-alist '(("." . "~/.cache/emacs/backup/")))
  (auto-save-file-name-transforms '((".*" "~/.cache/emacs/autosave/" t)))

  :bind (("C-c c" . global-display-fill-column-indicator-mode)
         ("C-<return>" . new-line-bellow)
         ("C-S-<return>" . new-line-above)
         ("C-x w" . copy-line)
         :map emacs-lisp-mode-map
         ("C-c C-e" . eval-buffer)))

(use-package elec-pair
  :init
  (electric-pair-mode 1)
  :config
  (defvar my-electic-pair-modes '(c-mode emacs-lisp-mode))
  (defun my-inhibit-electric-pair-mode (char)
    (not (member major-mode my-electic-pair-modes)))
  :custom
  (electric-pair-inhibit-predicate #'my-inhibit-electric-pair-mode))

(use-package multiple-cursors
  :ensure t
  :bind (("C-c }" . mc/edit-lines)
         ("C-c ]" . mc/mark-next-like-this)
         ("C-c [" . mc/mark-previous-like-this)
         ("C-c {" . mc/mark-all-like-this)
         :map mc/keymap
         ("<return>" . nil)))

(use-package phi-search
  :ensure t
  :bind (("C-s" . phi-search)
         ("C-r" . phi-search-backward)))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

(use-package avy
  :ensure t
  :bind (("C-c '" . avy-goto-char)
         ("C-c ;" . avy-goto-char-2)))

(use-package expand-region
  :ensure t
  :bind (("M-*" . er/expand-region)))

(use-package change-inner
  :requires expand-region
  :ensure t
  :bind (("M-i" . change-inner)
         ("M-o" . change-outer)))

(use-package move-dup
  :ensure t
  :bind (("M-<up>" . move-dup-move-lines-up)
         ("M-<down>" . move-dup-move-lines-down)
         ("M-S-<up>" . move-dup-duplicate-up)
         ("M-S-<down>" . move-dup-duplicate-down)))

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
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

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode)
  :custom
  (marginalia-align 'right))

;; just the example from the documentation

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

(use-package corfu
  :ensure t
  :bind
  (:map corfu-map
        ("S-SPC" . corfu-insert-separator))
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  :custom
  (corfu-cycle t)
  (corfu-auto-delay 0)
  (corfu-auto nil)
  (corfu-preview-current t)
  (corfu-popupinfo-delay 0.2)
  (corfu-right-margin-width 1))

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

(use-package cape
  :ensure t
  :init
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cape eglot tree-sitter-langs corfu consult marginalia orderless vertico move-dup change-inner expand-region avy yasnippet phi-search multiple-cursors use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
