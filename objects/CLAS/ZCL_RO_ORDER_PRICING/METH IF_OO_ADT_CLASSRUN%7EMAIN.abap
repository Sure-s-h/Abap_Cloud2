  METHOD if_oo_adt_classrun~main.
    DATA(lt_items) = VALUE tt_order_items(
      ( material = 'MAT-1001' quantity = 10 unit_price = '450.00' )
      ( material = 'MAT-2002' quantity = 4  unit_price = '1250.00' ) ).

    out->write( |Net order amount: { calculate_net_amount( lt_items ) }| ).
  ENDMETHOD.