;; extends

; Highlight Gambit FFI forms.

((list
   .
   (symbol) @keyword
   (#any-of? @keyword
     "c-declare"
     "c-initialize"
     "c-lambda"))
 (#set! priority 110))

; Highlight c-lambda argument and result types.

((list
   .
   (symbol) @_ffi_form
   .
   (list
     (symbol) @type)
   .
   (symbol) @type
   .
   (string))
 (#eq? @_ffi_form "c-lambda")
 (#set! priority 110))

; Highlight the Scheme binding name in:
; (define x-initialize (c-lambda ...))

((list
   .
   (symbol) @_define
   .
   (symbol) @function
   .
   (list
     .
     (symbol) @_ffi_form))
 (#eq? @_define "define")
 (#eq? @_ffi_form "c-lambda")
 (#set! priority 110))
