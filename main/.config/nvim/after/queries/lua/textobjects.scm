(string) @string.outer

(_) @node

(arguments (_) @swappable)
(field) @swappable
(parameters (_) @swappable)
(variable_list (_) @swappable)
(expression_list (_) @swappable)

_ @token.inner
(identifier) @token.inner
; FIXME: sometimes gets children

; TODO: token outer (whitespaces)

_ @token.outer
(identifier) @token.outer

; Generalized argument
; TODO: 

; Comments
(comment) @komment.inner

; from nvim-treesitter-textsujects smart
((comment) @_start @_end
     (#make-range! "komment.inner" @_start @_end))

; TODO: This query doesn't work for comment groups at the start and end of a file
;       See: https://github.com/tree-sitter/tree-sitter/issues/1138
(((_) @head . (comment) @_start . (comment)+ @_end (_) @tail)
    (#not-has-type? @tail "comment")
    (#not-has-type? @head "comment")
    (#make-range! "komment.outer" @_start @_end))
