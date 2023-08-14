(module tftspellscsv ()

(import scheme)
(import (chicken base))
(import (chicken sort))
(import tabular)
(import fmt)
(import loop)

(define roff-header ".\\\" **** Settings *************************************************
.special S Symbola
.ds LH
.ds CH
.ds RH
.ds LF
.ds CF
.ds RF
.\\\" page height
.pl 8.5i
.\\\" text width
.nr LL 4.5i
.\\\" left margin
.nr PO 0.5i
.\\\" top margin
.nr HM 0.3i
.\\\" bottom margin
.nr FM 0.45i
.\\\" header/footer width
.nr LT \\n[LL]
.\\\" point size
.nr PS 8p
.\\\" line height
.nr VS 9.6p
.\\\" font family: A, BM, H, HN, N, P, T, ZCM
.fam T
.\\\" paragraph indent: I originally had 2m, but others convinced me no indent
.\\\" with inter-paragraph space was more readable.
.nr PI 1m
.\\\" Quote indent
.nr QI 2n
.\\\" interparagraph space
.nr PD 0.2v
.\\\" footnote width
.nr FL \\n[LL]
.\\\" footnote point size
.nr FPS (\\n[PS] - 2000)
.\\\" footnote mode
.nr FF 3
.\\\" footnote ratio
.ds FR 1
.\\\" color used for strikeout
.defcolor strikecolor rgb 0.7 0.7 0.7
.\\\" color for links (rgb)
.ds PDFHREF.COLOUR   0.35 0.00 0.60
.\\\" border for links (default none)
.ds PDFHREF.BORDER   0 0 0
")

(define rd (reader* (current-input-port)))

(define (iq   spell) (car spell))
(define (name spell) (cadr spell))
(define (type spell) (caddr spell))
(define (page spell) (cadddr (cdr spell)))


(define (by-name a b)
  (string-ci<? (name a) (name b)))

(define (main)
  (let* ((spells-by-iq
          (loop for record = (rd)
                for linenum from 1
                until (eof-object? record)
                ;; do (fmt #t (dsp "Line ") (num linenum) (dsp ": ") (wrt record) nl)
                when (> linenum 1) collect record))
         (spells-by-name (sort spells-by-iq by-name)))
    (fmt #t roff-header)
    (fmt #t ".MC " nl)
    (fmt #t ".LP" nl ".CE 1" nl
         "\\s+2\\f(BI— TFT Spells — Alphabetically —\\fP\\s0" nl
         ".sp 1v" nl)
    (loop for spell in spells-by-name
          do (fmt #t ".XP" nl "\\fB" (name spell) "\\fP "
                  "(" (type spell) ", IQ " (iq spell) "): \\f(BIITL\\fP p. "
                  (page spell) "." nl))
    (fmt #t ".bp" nl ".LP" nl ".CE 1" nl
         "\\s+2\\f(BI— TFT Spells — By IQ —\\fP\\s0" nl
         ".sp 1v" nl)
    (let ((old-iq '()))
      (loop for spell in spells-by-iq
            do (begin
                 (fmt (current-error-port) "old-iq: " old-iq " iq: " (iq spell)
                       " eqv? " (eqv? old-iq (iq spell)) nl)
                 (when (or (null? old-iq)
                             (not (string=? old-iq (iq spell))))
                   (fmt (current-error-port) "Changing old-iq" nl)
                   (set! old-iq (iq spell))
                   (fmt #t ".sp .5v" nl ".XP" nl "\\s+1\\fBIQ "
                        (dsp (iq spell))
                        " Spells\\fP\\s0" nl))
                 (fmt #t ".XP" nl "\\fB" (name spell) "\\fP "
                      "(" (type spell) "): \\f(BIITL\\fP p. "
                      (page spell) "." nl))))))

(cond-expand
  (compiling
   (main))
  (else))
)
  
;;; build/tftspellscsv <~/Reference/RPG/TFT/tft_talent_and_spell_list_sheet.csv | tee ~/tmp/x.ms | groff -Kutf8 -Tpdf -ms -P-p8.5i,5.5i >~/tmp/x.pdf && op ~/tmp/x.pdf
