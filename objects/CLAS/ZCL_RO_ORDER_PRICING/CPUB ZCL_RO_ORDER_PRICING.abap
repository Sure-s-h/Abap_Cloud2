CLASS zcl_ro_order_pricing DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES ty_amount TYPE p LENGTH 15 DECIMALS 2.

    TYPES: BEGIN OF ty_order_item,
             material   TYPE c LENGTH 18,
             quantity   TYPE i,
             unit_price TYPE ty_amount,
           END OF ty_order_item,
           tt_order_items TYPE STANDARD TABLE OF ty_order_item WITH EMPTY KEY.

    "! Discount % based on gross order value
    METHODS get_discount_percent
      IMPORTING iv_gross_amount   TYPE ty_amount
      RETURNING VALUE(rv_percent) TYPE i.

    "! Net order value after discount (lines with qty <= 0 are ignored)
    METHODS calculate_net_amount
      IMPORTING it_items      TYPE tt_order_items
      RETURNING VALUE(rv_net) TYPE ty_amount.