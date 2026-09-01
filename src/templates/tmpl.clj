; Clojure

(def g "<QCImage/>")
(def r(int-array 8))
(def a 0)
(def i <QCConst>entrypoint</QCConst>)
(def p 0)
(def d 0)
(def c 0)
(def S(list))

; ---- helpers ----
(defn b[y j](int(nth y j 0)))
(defn u[](def i(+ i 1))(b g(- i 1)))

; ---- put the name into r[0..] (a fixed 8 iterations) ----
(while(< c 8)(aset r(mod c 8)(b(or(first *command-line-args*)"clj")c))(def c(+ c 1)))

; ---- main loop ----
(while(< 0 c)(def c(u))
  (if(= d 0)
    (if(< c 34)(def d -1)
      (if(< c 39)(do(def a(b g p))(def p(+ p 1)))
        (if(< c 41)(if(= a 0)(def d 1)(def S(cons i S)))
          (if(< c 42)(if(= a 0)(def S(rest S))(def i(first S)))
            (if(< c 43)(.write System/out(int a))
              (if(< c 56)(aset r(mod c 8)a)
                (def a
                  (if(< c 64)(aget r(mod c 8))
                    (if(< c 72)(- a(aget r(mod c 8)))c)))))))))
    (if(< d 0)(if(= c 47)(def d 0)(.write System/out(int(if(= c 72)(-(u)33)c))))(if(< 39 c 42)(def d(- d c c -81))))))
(flush)
