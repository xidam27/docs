(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu nil)
 '(ac-delay 0.5)
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes
   (quote
    ("135bbd2e531f067ed6a25287a47e490ea5ae40b7008211c70385022dbab3ab2a" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(flycheck-flake8-maximum-line-length 90)
 '(global-auto-revert-mode t)
 '(ido-mode (quote both) nil (ido))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/Dropbox/Personal/pomodoro.org")))
 '(org-agenda-window-setup (quote current-window))
 '(org-clock-clocked-in-display (quote frame-title))
 '(org-pomodoro-format "%s")
 '(org-pomodoro-long-break-format "%s")
 '(org-pomodoro-short-break-format "%s")
 '(org-src-fontify-natively t)
 '(show-paren-mode t)
 '(sml/theme (quote smart-mode-line-powerline))
 '(tool-bar-mode nil)
 '(venv-location "~/.virtualenvs/")
 '(web-mode-enable-current-element-highlight t)
 '(web-mode-markup-indent-offset 2)
 '(wg-mode-line-on nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 90 :width normal))))
 '(mode-line ((t (:family "DejaVu Sans Condensed"))))
 '(mode-line-inactive ((t (:family "DejaVu Sans Condensed")))))

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))


;; these must be before package-refresh-contents
(setq package-pinned-packages '((magit . "melpa-stable")
                                (yasnippet . "melpa-stable")
                                (jedi . "melpa-stable")
                                (auto-complete . "melpa-stable")
                                (autopair . "melpa-stable")
                                (find-file-in-repository . "melpa-stable")
                                (flycheck . "melpa-stable")
                                (virtualenvwrapper . "melpa")
                                (multiple-cursors . "melpa-stable")
                                (column-marker . "melpa")
                                (org-pomodoro . "melpa")
                                (workgroups . "melpa")
                                (web-mode . "melpa-stable")
                                (puppet-mode . "melpa-stable")
                                (buffer-move . "melpa-stable")
                                (cider . "melpa-stable")
                                (clojure-mode . "melpa-stable")
                                (smart-mode-line . "melpa-stable")
                                (smart-mode-line-powerline-theme . "melpa-stable")))


(package-initialize)

(package-refresh-contents)


(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-install package)))

;; make more packages available with the package installer
(let (to-install)
  (setq to-install
    '(magit yasnippet jedi auto-complete autopair find-file-in-repository flycheck multiple-cursors column-marker org-pomodoro workgroups web-mode puppet-mode buffer-move cider clojure-mode virtualenvwrapper smart-mode-line smart-mode-line-powerline-theme))

  (mapc 'install-if-needed to-install))

(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'smart-mode-line)
(sml/setup)
(add-to-list 'sml/replacer-regexp-list '("^~/Projects/" ":P:") t)

(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

(require 'auto-complete)
(require 'autopair)
(require 'yasnippet)

(yas-reload-all)

(require 'python)

(add-hook 'python-mode-hook 'autopair-mode)
(add-hook 'python-mode-hook 'yas-minor-mode)

(require 'jedi)

(add-hook 'python-mode-hook
          (lambda ()
            (jedi:setup)
            (jedi:ac-setup)
            (local-set-key "\C-cd" 'jedi:show-doc)
            (local-set-key (kbd "M-SPC") 'jedi:complete)
            (local-set-key (kbd "M-.") 'jedi:goto-definition)))


(add-hook 'python-mode-hook 'auto-complete-mode)

(require 'virtualenvwrapper)
(venv-initialize-interactive-shells) ;; if you want interactive shell support
(venv-initialize-eshell) ;; if you want eshell support

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(require 'org-pomodoro)
(global-set-key (kbd "C-c p") 'org-pomodoro)

(require 'org)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") 'org-capture)

(require 'org-capture)
(setq org-capture-templates
 '(("t" "Todo" entry (file+headline "~/Dropbox/Personal/pomodoro.org" "Unplanned")
	"* TODO %?\n  %i\n  %a")
   ("j" "Journal" entry (file+datetree "~/Dropbox/Personal/journal.org")
	"* %?\nEntered on %U\n  %i\n  %a")))

(require 'workgroups)

(setq wg-prefix-key (kbd "C-z")
      wg-no-confirm t
      wg-file "~/.emacs.d/workgroups"
      wg-use-faces nil
      wg-switch-on-load nil)

(defun wg-load-default ()
  "Run `wg-load' on `wg-file'."
  (interactive)
  (wg-load wg-file))

(defun wg-save-default ()
  "Run `wg-save' on `wg-file'."
  (interactive)
  (when wg-list
    (with-temp-message ""
      (wg-save wg-file))))

(define-key wg-map (kbd "g") 'wg-switch-to-workgroup)
(define-key wg-map (kbd "C-l") 'wg-load-default)
(define-key wg-map (kbd "C-s") 'wg-save-default)
(define-key wg-map (kbd "<backspace>") 'wg-switch-left)
(workgroups-mode 1)
(add-hook 'auto-save-hook 'wg-save-default)

(setq wg-query-for-save-on-emacs-exit nil)
(push (lambda()(or (ignore-errors
            (wg-update-all-workgroups-and-save)) t))
  kill-emacs-query-functions)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(setq web-mode-engines-alist
      '(("django" . "\\.html\\'")))

;; -------------------- extra nice things --------------------
;; use shift to move around windows
(windmove-default-keybindings 'shift)

(setq magit-last-seen-setup-instructions "1.4.0")

(setq-default mode-line-format (cons '(:exec venv-current-name) mode-line-format))

;; (desktop-save-mode 1)

;; Highlight character at "fill-column" position.
(require 'column-marker)
(set-face-background 'column-marker-1 "red")
(add-hook 'python-mode-hook
          (lambda () (interactive)
            (column-marker-1 79)))


(add-hook 'python-mode-hook
	   (lambda ()
	     (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
