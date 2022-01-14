;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((javascript-mode . ((eval . (add-hook 'after-save-hook 'recompile nil 'local))
                     (compile-command . "node2nix -i ./node-packages.json"))))
