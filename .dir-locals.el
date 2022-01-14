;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((eval . (add-hook 'after-save-hook 'recompile nil 'local))
         (compile-command . "nixos-rebuild switch"))))
