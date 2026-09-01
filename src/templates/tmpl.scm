; Scheme

(define g "<QCImage/>")
(define r(make-vector 8 0))
(define a 0)
(define i <QCConst>entrypoint</QCConst>)
(define p 0)
(define d 0)
(define c 0)
(define S(list))

; ---- helpers ----
(define(b y j)(if(< j(string-length y))(char->integer(string-ref y j))0))
(define(u)(set! i(+ i 1))(b g(- i 1)))

; ---- put the name into r[0..] (a fixed 8 iterations) ----
(do()((= c 8))(vector-set! r(modulo c 8)(b(cadr(append(command-line)(list "scm")))c))(set! c(+ c 1)))

; ---- main loop ----
(do()((= c 0))(set! c(u))
  (if(= d 0)
    (if(< c 34)(set! d -1)
      (if(< c 39)(begin(set! a(b g p))(set! p(+ p 1)))
        (if(< c 41)(if(= a 0)(set! d 1)(set! S(cons i S)))
          (if(< c 42)(if(= a 0)(set! S(cdr S))(set! i(car S)))
            (if(< c 43)((@(rnrs io ports)put-u8)(current-output-port)a)
              (if(< c 56)(vector-set! r(modulo c 8)a)
                (set! a
                  (if(< c 64)(vector-ref r(modulo c 8))
                    (if(< c 72)(- a(vector-ref r(modulo c 8)))c)))))))))
    (if(< d 0)(if(= c 47)(set! d 0)((@(rnrs io ports)put-u8)(current-output-port)(if(= c 72)(-(u)33)c)))(if(< 39 c 42)(set! d(- d c c -81))))))
