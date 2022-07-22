;; https://en.wikipedia.org/wiki/Arrows_(Unicode_block)
;; https://en.wikipedia.org/wiki/List_of_logic_symbols
;; https://en.wikipedia.org/wiki/Mathematical_operators_and_symbols_in_Unicode


;; Keywords
(("return" @keyword) (#set! conceal "←"))
(("local" @keyword) (#set! conceal "•"))

(("or" @keyword) (#set! conceal "∨"))
(("and" @keyword) (#set! conceal "∧"))
;
(((true) @TSBoolean) (#set! conceal "■"))
(((false) @TSBoolean) (#set! conceal "□"))

(("comment_start" @comment) (#set! conceal ""))

;
; (("function" @keyword) (#set! conceal "ﬦ"))
; (("function" @keyword) (#set! conceal ""))

; (("for" @keyword) (#set! conceal "∀"))
; (("in" @keyword) (#set! conceal "∍"))
; (("while" @keyword) (#set! conceal "○"))
; (("while" @keyword) (#set! conceal "⟳"))
; (("end" @keyword) (#set! conceal "↖"))
; (("do" @keyword) (#set! conceal "↘"))
; ⇱   ⇲
; (("if" @keyword) (#set! conceal "?"))
; (("else" @keyword) (#set! conceal "!"))
; (("elseif" @keyword) (#set! conceal "¿"))
; (("then" @keyword) (#set! conceal "⇒"))


