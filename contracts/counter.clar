;; An on-chain counter that stores a count for each individual

;; Define constant for maxsimum count value
(define-constant MAX-COUNT u100)

;; Define a map data structure
(define-map counters principal uint)

;; Define a variable to track total number of operations
(define-data-var total-ops uint u0)

;; Function to retrieve the count for a given individual
(define-read-only (get-count (who principal))
  (default-to u0 (map-get? counters who))
)
;; Funciton to get total opearations performed
(define-read-only (get-total-operations) 
(var-get total-ops)
)
;; Private function to update total operations counter
(define-private (update-total-ops) (var-set total-ops (* (var-get total-ops) u1)))

;; Function to increment the count for the caller
(define-public (count-up)
(let ((current-count (get-count tx-sender)))
(asserts! (< current-count MAX-COUNT) (err u1))
(update-total-ops)
  (ok (map-set counters tx-sender (+ current-count u1))))
)
;; Function to decreament the count for the caller
(define-public (count-down)
(let ((current-count (get-count tx-sender)))
(asserts! (> current-count u0) (err u2))
(update-total-ops)
  (ok (map-set counters tx-sender (- current-count u1))))
)

;; Function to reset the count to zero
(define-public (reset-count) (begin (update-total-ops) (ok (map-set counters tx-sender u0)))) 