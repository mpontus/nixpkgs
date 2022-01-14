;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((nix-mode . ((eval .
                    (progn
                      (add-hook 'after-save-hook 'recompile nil 'local)
                      (add-hook 'org-babel-post-tangle-hook 'recompile nil 'local)))))

 (nil . ((eval . (add-hook 'after-save-hook 'recompile nil 'local))
         (compile-command . "nixos-rebuild switch")))
)
