; Common Lisp

(defvar g "<QCImage/>")
(defvar r(make-array 8))
(defvar a 0)
(defvar i <QCConst>entrypoint</QCConst>)
(defvar p 0)
(defvar d 0)
(defvar c 0)
(defvar S(list))

; ---- helpers ----
(defun b(y j)(if(< j(length y))(char-code(char y j))0))
; write to a separate stream: with *standard-output*, clisp appends a fresh-line at exit
(defvar w(ext:make-stream :output))
(defun u()(setf i(+ i 1))(b g(- i 1)))

; ---- put the name into r[0..] (a fixed 8 iterations) ----
(do()((= c 8))(setf(aref r(mod c 8))(b(or(car ext:*args*)"lisp")c))(setf c(+ c 1)))

; ---- main loop ----
(do()((= c 0))(setf c(u))
  (if(= d 0)
    (if(< c 34)(setf d -1)
      (if(< c 39)(progn(setf a(b g p))(setf p(+ p 1)))
        (if(< c 41)(if(= a 0)(setf d 1)(setf S(cons i S)))
          (if(< c 42)(if(= a 0)(setf S(cdr S))(setf i(car S)))
            (if(< c 43)(write-char(code-char a)w)
              (if(< c 56)(setf(aref r(mod c 8))a)
                (setf a
                  (if(< c 64)(aref r(mod c 8))
                    (if(< c 72)(- a(aref r(mod c 8)))c)))))))))
    (if(< d 0)(if(= c 47)(setf d 0)(write-char(code-char(if(= c 72)(-(u)33)c))w))(if(< 39 c 42)(setf d(- d c c -81))))))
