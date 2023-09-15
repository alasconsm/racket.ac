#lang sketching

(define img (load-image "hollowknight.jpg"))

(define small-point 4)
(define large-point 40)
(define current-shape 'diamond) ; Inicialmente, elige diamante como forma predeterminada
(define current-size small-point) ; Tamaño predeterminado
(define x-pos 0.0) ; Posición horizontal actual de la imagen
(define move-direction 1) ; Dirección inicial de movimiento (1 para derecha, -1 para izquierda)

(define (setup)
  (size 640 360)
  (frame-rate 120)
  (image-mode 'center)
  (no-stroke)
  (background 255))

(define (draw)
  (define radius current-size)
  (define y (int (random (image-height img))))

  (let ([new-x-pos (if (< x-pos 0) 0 (if (> x-pos (- (width) 1)) (- (width) 1) x-pos))])
    (set! x-pos new-x-pos))
  
  (define pix (image-get img (int x-pos) y))
  (fill pix 128)
  
  (cond
    [(equal? current-shape 'circle) (circle x-pos y radius)]
    [(equal? current-shape 'triangle) (triangle x-pos y (+ x-pos radius) (+ y radius) (- x-pos radius) (+ y radius))]
    [(equal? current-shape 'square) (rect x-pos y radius radius)]
    [(equal? current-shape 'diamond) (polygon2 x-pos y radius 4)])
  
  (set! x-pos (+ x-pos (* move-direction 0.3)))
  
  (when (or (< x-pos 0) (> x-pos (- width radius)))
  (set! move-direction (* -1 move-direction))))

(define (on-key-pressed)
  (define c key)
  (cond
    [(char=? c #\q) (set! current-shape 'triangle)] ; Tecla 'q' para triángulo
    [(char=? c #\w) (set! current-shape 'circle)]   ; Tecla 'w' para diamante (predeterminado)
    [(char=? c #\e) (set! current-shape 'square)]   ; Tecla 'e' para cuadrado
    [(char=? c #\r) (set! current-shape 'diamond)]  ; Tecla 'r' para rombo
    [(char=? c #\a) (set! current-size (- current-size 5))] ; Tecla 'a' para reducir el tamaño
    [(char=? c #\s) (set! current-size (+ current-size 5))] ; Tecla 's' para aumentar el tamaño
    [else (background 255)])) ; Borrar el lienzo en cualquier otra tecla

(define (polygon2 x y radius npoints)
  (define angle (/ 2π npoints))
  (begin-shape)
  (for ([a (in-range 0.0 2π angle)])
    (define sx (+ x (* radius (cos a))))
    (define sy (+ y (* radius (sin a))))
    (vertex sx sy))
  (end-shape 'close))
