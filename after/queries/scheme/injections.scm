;; extends

; Gambit:
; (c-declare #<<c-declare-end
; #include "x.h"
; c-declare-end
; )

((list
   .
   (symbol) @_ffi_form
   .
   (string
     (heredoc_body) @injection.content))
 (#eq? @_ffi_form "c-declare")
 (#set! injection.language "c"))

((list
   .
   (symbol) @_ffi_form
   .
   (list)
   .
   (symbol)
   .
   (string
     (heredoc_body) @injection.content))
 (#eq? @_ffi_form "c-lambda")
 (#set! injection.language "c"))
