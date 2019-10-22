;;; lc3-mode.el --- Major mode for lc-3 assembly     -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Varun Valada

;; Author: Varun Valada <varun.valada@gmail.com>
;; Keywords: languages
(require 'thingatpt)

(defvar lc3-mode-hook nil)

(defvar lc3-mode-map nil "Keymap for LC-3 mode.")

(setq lc3-mode-map
      (let ((map (make-sparse-keymap)))
        ;; Note that the comment character isn't set up until asm-mode is called.
        (define-key map ":"		'asm-colon)
        (define-key map "\C-c;"	'comment-region)
        (define-key map "\C-j"	'jump-to-label)
        (define-key map "\C-m"	'newline-and-indent)
        (define-key map [menu-bar lc3-mode] (cons "lc3" (make-sparse-keymap)))
        (define-key map [menu-bar lc3-mode comment-region]
          '(menu-item "Comment Region" comment-region
		      :help "Comment or uncomment each line in the region"))
        (define-key map [menu-bar lc3-mode newline-and-indent]
          '(menu-item "Insert Newline and Indent" newline-and-indent
		      :help "Insert a newline, then indent according to major mode"))
        map))
(defvar lc3-mode-syntax-table nil "Syntax table for `lc3-mode'.")
(defun jump-to-label ()
  (interactive)
  (let ((label (thing-at-point 'word)))
    (goto-char (point-min))
    (search-forward label nil nil)
  )
)

(setq lc3-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax-entry ?\; "< 12" st)
    (modify-syntax-entry ?\n ">" st)
    st))

(defconst lc3-font-lock-keywords
  (append
   '(("\\<\\(A\\(?:[DN]D\\)\\|\\(BR\\(?:n\\(?:zp\\|[pz]\\)\\|zp\\|[npz]\\)?\\)\\|HALT\\|J\\(?:MP\\|SRR?\\)\\|L\\(?:D[IR]?\\|EA\\)\\|NOT\\|R\\(?:ET\\|TI\\)\\|ST[IR]?\\|TRAP\\)\\>"
      (1 font-lock-function-name-face))
     ;; label started 
     ;; %register
     ("\\<\\(R[0-7]\\)\\>" . font-lock-variable-name-face)
     ("\\(\\..* \\)" (1 font-lock-function-name-face))))
  "Minimal highlighting expressions for LC-3 mode")

(defconst asm-font-lock-keywords
  (append
   '(("\\(A\\(?:[DN]D\\)\\|BR\\|HALT\\|J\\(?:MP\\|SRR?\\)\\|L\\(?:D[IR]?\\|EA\\)\\|NOT\\|R\\(?:ET\\|TI\\)\\|ST[IR]?\\|TRAP\\)"
      (1 font-lock-function-name-face))
     ;; label started 
     ;; %register
     ("\\(R[0-7]\\)" . font-lock-variable-name-face)))
  "Additional expressions to highlight in Assembler mode.")
                                        
(define-derived-mode lc3-mode prog-mode "lc3"
  "Major mode for editing Workflow Process Description Language files."
  (set-syntax-table lc3-mode-syntax-table)
  (use-local-map lc3-mode-map)
  (setq-local font-lock-defaults '(lc3-font-lock-keywords))
  )


(provide 'lc3-mode)
