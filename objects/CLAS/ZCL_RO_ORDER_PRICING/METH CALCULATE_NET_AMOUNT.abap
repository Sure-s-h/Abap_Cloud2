  METHOD calculate_net_amount.
    DATA lv_gross TYPE ty_amount.

    LOOP AT it_items INTO DATA(ls_item) WHERE quantity > 0.
      lv_gross += ls_item-quantity * ls_item-unit_price.
    ENDLOOP.

    DATA(lv_percent) = get_discount_percent( lv_gross ).
    rv_net = lv_gross - lv_gross * lv_percent / 100.
  ENDMETHOD.