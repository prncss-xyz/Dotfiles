;; parameters
; function ({ x }) ...
; function ([ x ]) ...
; function (v = default_value)
(formal_parameters
  "," @_start .
  (_) @swappable.inner
 (#make-range! "swappable.outer" @_start @swappable.inner))
(formal_parameters
  . (_) @swappable.inner
  . ","? @_end
 (#make-range! "swappable.outer" @swappable.inner @_end))

; If the array/object pattern is the first parameter, treat its elements as the argument list
(formal_parameters
  . (_
    [(object_pattern "," @_start .  (_) @swappable.inner)
    (array_pattern "," @_start .  (_) @swappable.inner)]
    )
 (#make-range! "swappable.outer" @_start @swappable.inner))
(formal_parameters
  . (_
    [(object_pattern . (_) @swappable.inner . ","? @_end)
    (array_pattern . (_) @swappable.inner . ","? @_end)]
    )
 (#make-range! "swappable.outer" @swappable.inner @_end))


;; arguments
(arguments
  "," @_start .
  (_) @swappable.inner
 (#make-range! "swappable.outer" @_start @swappable.inner))
(arguments
  . (_) @swappable.inner
  . ","? @_end
 (#make-range! "swappable.outer" @swappable.inner @_end))
