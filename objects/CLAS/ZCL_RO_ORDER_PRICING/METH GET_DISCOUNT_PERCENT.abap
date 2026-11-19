  METHOD get_discount_percent.
    rv_percent = COND #( WHEN iv_gross_amount >= 10000 THEN 10
                         WHEN iv_gross_amount >= 5000  THEN 5
                         ELSE 0 ).
  ENDMETHOD.