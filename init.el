(set-face-attribute 'default nil
		    :family "Ricty Diminished"
		    :height 120)
(set-fontset-font (frame-parameter nil 'font)
				   'japanese-jisx0208
				   (cons "Ricty Diminished" "iso10646"))
(set-fontset-font (frame-parameter nil 'font)
		  'japanese-jisx0212
		  (cons "Ricty Diminished" "iso10646-1"))
(set-fontset-font (frame-parameter nil 'font)
		  'katakana-jisx0201
		  (cons "Ricty Diminished" "iso10646-1"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (helm-ack helm-ag restart-emacs wget w3m migemo gtags mew esup magithub magit function-args ddskk sr-speedbar helm helm-gtags company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'manoj-dark)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

;;
(setq-default bidi-display-reordering nil)

;; Disable splash screen
(setq inhibit-splash-screen t)

;;
(setq history-delete-duplicates t)

;; 
(setq set-mark-command-repeat-pop t)

;;
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory "places"))

;;
(setq-default indent-tabs-mode nil)

;;
(savehist-mode 1)

;;
(global-set-key (kbd "C-h") 'delete-backward-char)

;;
(setq gc-cons-threshold (* 10 gc-cons-threshold))

;;
(setq message-log-max 10000)

;;
(setq history-length 1000)

;;
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(require 'company)
(global-company-mode)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(setq company-selection-wrap-around t)

(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)

(show-paren-mode t)

(global-linum-mode)
(setq linum-format "%4d ")

(display-time)

(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq delete-auto-save-files t)

;;(setq hl-line-face 'underline)
;;(global-hl-line-mode 1)

(setq default-tab-width 4)

;; Setup helm
(require 'helm)
(require 'helm-config)
;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t
      helm-M-x-fuzzy-match t
      helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)
(helm-mode 1)

;; 
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

(require 'helm-ag)

;; Setup speedbar
(setq speedbar-show-unknown-files t)

;; Setup ddskk
(unless window-system frame-background-mode 'dark)
(setq skk-byte-compile-init-file t)
(setq default-input-method "japanese-skk")
(setq skk-isearch-mode-enable 'always)

;; Setup magit
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(setenv "GIT_ASKPASS" "git-gui--askpass")

;; Setup MEW
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew)

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

;; Setup migemo
(require 'migemo)
;; (setq migemo-dictionary "C:/Users/username/AppData/Roaming/.emacs.d/conf/migemo/dict/cp932/migemo-dict")
(setq migemo-dictionary "c:/msys64/home/Saito/.emacs.d/conf/migemo/dict/utf-8/migemo-dict") ; 文字コードに注意.
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs" "-i" "\a"))
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix) ; 文字コードに注意.
;; (setq migemo-coding-system 'cp932-unix)
(load-library "migemo") ; ロードパス指定.
(migemo-init)

