;;; Run from the repository root with egcl --no-init --load test/egcl-clock.lisp.
(require :asdf)
(asdf:load-asd (truename "local-time.asd"))
(asdf:load-system "local-time")

;; Compare both the epoch and the fractional component against atomic native
;; clock samples. An integer-second fallback cannot pass the precision check.
(let ((saw-fraction nil))
  (dotimes (i 10)
    (multiple-value-bind (before-sec before-nsec) (egcl-ext:get-precise-time)
      (multiple-value-bind (seconds nanos) (local-time::%get-current-time)
        (multiple-value-bind (after-sec after-nsec) (egcl-ext:get-precise-time)
          (let ((before (+ (* before-sec 1000000000) before-nsec))
                (sample (+ (* (+ seconds 2208988800) 1000000000) nanos))
                (after (+ (* after-sec 1000000000) after-nsec)))
            (assert (<= before sample after)))
          (assert (<= 0 nanos 999999999))
          (when (plusp nanos) (setf saw-fraction t))))))
  (assert saw-fraction))

;; Exercise the public consumer and its UTC conversion, not just the adapter.
(let* ((stamp (local-time:now))
       (unix (local-time:timestamp-to-unix stamp))
       (roundtrip (local-time:unix-to-timestamp unix
                    :nsec (local-time:nsec-of stamp))))
  (assert (local-time:timestamp= stamp roundtrip))
  (assert (plusp (local-time:nsec-of stamp))))
(format t "EGCL precise clock and NOW roundtrip passed.~%")
