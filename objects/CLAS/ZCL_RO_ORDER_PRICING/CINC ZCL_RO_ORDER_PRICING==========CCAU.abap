CLASS ltc_order_pricing DEFINITION FINAL
  FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zcl_ro_order_pricing.

    METHODS setup.

    " --- Discount percentage rules ---
    METHODS no_discount_below_5000      FOR TESTING.
    METHODS five_percent_from_5000      FOR TESTING.
    METHODS ten_percent_from_10000      FOR TESTING.
    METHODS zero_amount_no_discount     FOR TESTING.
    METHODS negative_amount_no_discount FOR TESTING.

    " --- Net amount calculation test conflict---
    METHODS net_amount_with_discount    FOR TESTING.
    METHODS ignores_zero_quantity       FOR TESTING.
    METHODS negative_quantity_ignored   FOR TESTING.
    METHODS empty_order_returns_zero    FOR TESTING.
    METHODS small_order_no_discount     FOR TESTING.
    METHODS boundary_5000_net           FOR TESTING.
    METHODS boundary_10000_net          FOR TESTING.
    METHODS large_order_ten_percent     FOR TESTING.
    METHODS decimal_prices_no_discount  FOR TESTING.
ENDCLASS.


CLASS ltc_order_pricing IMPLEMENTATION.

  METHOD setup.
    cut = NEW #( ).
  ENDMETHOD.

  " ===== Discount percentage =====

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

  METHOD zero_amount_no_discount.
    cl_abap_unit_assert=>assert_equals(
      act = cut->get_discount_percent( '0.00' )
      exp = 0 ).
  ENDMETHOD.

  METHOD negative_amount_no_discount.
    " Credit memo / negative value must never get a discount
    cl_abap_unit_assert=>assert_equals(
      act = cut->get_discount_percent( '-2500.00' )
      exp = 0 ).
  ENDMETHOD.

  " ===== Net amount =====

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

  METHOD negative_quantity_ignored.
    " Return line (-5) must not reduce the order value
    DATA(lt_items) = VALUE zcl_ro_order_pricing=>tt_order_items(
      ( material = 'MAT-5005' quantity = -5 unit_price = '1000.00' )
      ( material = 'MAT-6006' quantity = 1  unit_price = '500.00' ) ).

    cl_abap_unit_assert=>assert_equals(
      act = cut->calculate_net_amount( lt_items )
      exp = CONV zcl_ro_order_pricing=>ty_amount( '500.00' ) ).
  ENDMETHOD.

  METHOD empty_order_returns_zero.
    DATA lt_items TYPE zcl_ro_order_pricing=>tt_order_items.

    cl_abap_unit_assert=>assert_equals(
      act = cut->calculate_net_amount( lt_items )
      exp = CONV zcl_ro_order_pricing=>ty_amount( '0.00' ) ).
  ENDMETHOD.

  METHOD small_order_no_discount.
    " 3 x 1000 = 3000 -> 0% -> 3000.00
    DATA(lt_items) = VALUE zcl_ro_order_pricing=>tt_order_items(
      ( material = 'MAT-7007' quantity = 3 unit_price = '1000.00' ) ).

    cl_abap_unit_assert=>assert_equals(
      act = cut->calculate_net_amount( lt_items )
      exp = CONV zcl_ro_order_pricing=>ty_amount( '3000.00' ) ).
  ENDMETHOD.

  METHOD boundary_5000_net.
    " 2 x 2500 = 5000 (exact boundary) -> 5% -> 4750.00
    DATA(lt_items) = VALUE zcl_ro_order_pricing=>tt_order_items(
      ( material = 'MAT-8008' quantity = 2 unit_price = '2500.00' ) ).

    cl_abap_unit_assert=>assert_equals(
      act = cut->calculate_net_amount( lt_items )
      exp = CONV zcl_ro_order_pricing=>ty_amount( '4750.00' ) ).
  ENDMETHOD.

  METHOD boundary_10000_net.
    " 4 x 2500 = 10000 (exact boundary) -> 10% -> 9000.00
    DATA(lt_items) = VALUE zcl_ro_order_pricing=>tt_order_items(
      ( material = 'MAT-8008' quantity = 4 unit_price = '2500.00' ) ).

    cl_abap_unit_assert=>assert_equals(
      act = cut->calculate_net_amount( lt_items )
      exp = CONV zcl_ro_order_pricing=>ty_amount( '9000.00' ) ).
  ENDMETHOD.

  METHOD large_order_ten_percent.
    " 100 x 250 = 25000 -> 10% -> 22500.00
    DATA(lt_items) = VALUE zcl_ro_order_pricing=>tt_order_items(
      ( material = 'MAT-9009' quantity = 100 unit_price = '250.00' ) ).

    cl_abap_unit_assert=>assert_equals(
      act = cut->calculate_net_amount( lt_items )
      exp = CONV zcl_ro_order_pricing=>ty_amount( '22500.00' ) ).
  ENDMETHOD.

  METHOD decimal_prices_no_discount.
    " 3 x 33.33 = 99.99 -> 0% -> 99.99
    DATA(lt_items) = VALUE zcl_ro_order_pricing=>tt_order_items(
      ( material = 'MAT-1010' quantity = 3 unit_price = '33.33' ) ).

    cl_abap_unit_assert=>assert_equals(
      act = cut->calculate_net_amount( lt_items )
      exp = CONV zcl_ro_order_pricing=>ty_amount( '99.99' ) ).
  ENDMETHOD.

ENDCLASS.