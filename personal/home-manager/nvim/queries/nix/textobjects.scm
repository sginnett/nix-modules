;; extends
; assignment
(binding
  attrpath: (_) @assignment.lhs
  expression: (_) @assignment.rhs
) @assignment.outer

;; function call
(apply_expression
  function: (_) @call.inner
  argument: (_) @argument.inner
) @call.outer

;; function definition
(binding
  expression: (function_expression) @function.inner
) @function.outer


