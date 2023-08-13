(module tftspellscsv ()

(import scheme)
(import (chicken base))
(import tabular)
(import fmt)
(import loop)

(define rd (reader* (current-input-port)))

(loop for record = (rd)
      for linenum from 1
      until (eof-object? record)
      do (fmt #t (dsp "Line ") (num linenum) (dsp ": ") (wrt record) nl))
)
  
