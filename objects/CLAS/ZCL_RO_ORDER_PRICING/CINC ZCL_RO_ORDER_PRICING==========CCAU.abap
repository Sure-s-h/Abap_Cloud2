CLASS ltc_order_pricing DEFINITION FINAL
  FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_ro_order_pricing.

    METHODS setup.
    METHODS no_discount_below_5000  FOR TESTING.
    METHODS five_percent_from_5000  FOR TESTING.
    METHODS ten_percent_from_10000  FOR TESTING.
    METHODS net_amount_with_discount FOR TESTING.
    METHODS ignores_zero_quantity   FOR TESTING.
ENDCLASS.


CLASS ltc_order_pricing IMPLEMENTATION.

  METHOD setup.
    cut = NEW #( ).
  ENDMETHOD.

  METHOD no_discount_below_5000.
    cl_abap_unit_assert=>assert_equals(
      act = cut->get_discount_percent( '4999.99' )
      exp = 0 ).
  ENDMETHOD.

  METHOD five_percent_from_5000.
    cl_abap_unit_assert=>assert_equals(
      act = cut->get_discount_percent( '5000.00' )
      exp = 5 ).
  ENDMETHOD.

  METHOD ten_percent_from_10000.
    cl_abap_unit_assert=>assert_equals(
      act = cut->get_discount_percent( '10000.00' )
      exp = 10 ).
  ENDMETHOD.

  METHOD net_amount_with_discount.
    " 10 x 450 + 4 x 1250 = 9500 -> 5% -> 9025.00
    DATA(lt_items) = VALUE zcl_ro_order_pricing=>tt_order_items(
      ( material = 'MAT-1001' quantity = 10 unit_price = '450.00' )
      ( material = 'MAT-2002' quantity = 4  unit_price = '1250.00' ) ).

    cl_abap_unit_assert=>assert_equals(
      act = cut->calculate_net_amount( lt_items )
      exp = CONV zcl_ro_order_pricing=>ty_amount( '9025.00' ) ).
  ENDMETHOD.

  METHOD ignores_zero_quantity.
    DATA(lt_items) = VALUE zcl_ro_order_pricing=>tt_order_items(
      ( material = 'MAT-3003' quantity = 0 unit_price = '9999.00' )
      ( material = 'MAT-4004' quantity = 2 unit_price = '100.00' ) ).

    cl_abap_unit_assert=>assert_equals(
      act = cut->calculate_net_amount( lt_items )
      exp = CONV zcl_ro_order_pricing=>ty_amount( '200.00' ) ).
  ENDMETHOD.

ENDCLASS.