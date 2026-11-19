class-pool .
*"* class pool for class ZCL_RO_ORDER_PRICING

*"* local type definitions
include ZCL_RO_ORDER_PRICING==========ccdef.

*"* class ZCL_RO_ORDER_PRICING definition
*"* public declarations
  include ZCL_RO_ORDER_PRICING==========cu.
*"* protected declarations
  include ZCL_RO_ORDER_PRICING==========co.
*"* private declarations
  include ZCL_RO_ORDER_PRICING==========ci.
endclass. "ZCL_RO_ORDER_PRICING definition

*"* macro definitions
include ZCL_RO_ORDER_PRICING==========ccmac.
*"* local class implementation
include ZCL_RO_ORDER_PRICING==========ccimp.

*"* test class
include ZCL_RO_ORDER_PRICING==========ccau.

class ZCL_RO_ORDER_PRICING implementation.
*"* method's implementations
  include methods.
endclass. "ZCL_RO_ORDER_PRICING implementation
