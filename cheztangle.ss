(library (arcfide chezweb tangle)
  (export @chezweb @> @* @< @ @c @l)
  (import (chezscheme))

(define-syntax @chezweb
  (syntax-rules ()
    [(_) (begin)]))

(define-syntax @>
  (syntax-rules ()
    [(_ name (i ...) () (c ...) e1 e2 ...)
     (define-syntax name
       (lambda (x)
         (syntax-case x ()
           [(k)
            (with-implicit (k c ...)
              #'(let ()
                  (import i ...)
                  e1 e2 ...))])))]
    [(_ name (i ...) (e ...) (c ...) e1 e2 ...)
     (define-syntax name
       (lambda (x) 
         (syntax-case x ()
           [(k)
            (with-implicit (k c ... e ...)
              #'(module (e ...)
                  (import i ...)
                  e1 e2 ...))])))]))

(define-syntax @<
  (syntax-rules ()
    [(_ id) (id)]))

(define-syntax @
  (syntax-rules ()
    [(_ documentation exp ...)
     (string? (syntax->datum #'documentation))
     (begin exp ...)]))

(define-syntax @*
  (syntax-rules ()
    [(_  level name documentation exp ...)
     (and (integer? (syntax->datum #'level))
          (exact? (syntax->datum #'level))
          (string? (syntax->datum #'name))
          (string? (syntax->datum #'documentation)))
     (begin exp ...)]
    [(_ name documentation exp ...)
     (and (string? (syntax->datum #'name))
          (string? (syntax->datum #'documentation)))
     (begin exp ...)]
    [(_ level name exp ...)
     (and (integer? (syntax->datum #'level))
          (exact? (syntax->datum #'level))
          (string? (syntax->datum #'name)))
     (begin exp ...)]
    [(_ name exp ...)
     (string? (syntax->datum #'name))
     (begin exp ...)]))

(define-syntax @c
  (syntax-rules ()
    [(_ e1 e2 ...) (begin e1 e2 ...)]))

(define-syntax @l
  (lambda (x)
    (syntax-case x ()
      [(k doc (n1 n2 ...) (export e ...) (import i ...) body ...)
       (and (string? (syntax->datum #'doc))
            (eq? 'export (syntax->datum #'export))
            (eq? 'import (syntax->datum #'import)))
       (with-implicit (k library arcfide chezweb bootstrap)
         #'(library (n1 n2 ...)
             (export e ...)
             (import (arcfide chezweb bootstrap) i ...)
             body ...))])))

)

(import (arcfide chezweb tangle))