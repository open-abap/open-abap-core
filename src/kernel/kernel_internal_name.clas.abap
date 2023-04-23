CLASS kernel_internal_name DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS internal_to_rtti
      IMPORTING
        iv_internal TYPE string
      RETURNING
        VALUE(rv_rtti) TYPE string.

    CLASS-METHODS rtti_to_internal
      IMPORTING
        iv_rtti TYPE string
      RETURNING
        VALUE(rv_internal) TYPE string.
ENDCLASS.

CLASS kernel_internal_name IMPLEMENTATION.

  METHOD internal_to_rtti.
    rv_rtti = iv_internal.
    IF rv_rtti CP '*CLAS-*'.
      REPLACE FIRST OCCURRENCE OF 'CLAS-' IN rv_rtti WITH '\CLASS#POOL='.
      REPLACE FIRST OCCURRENCE OF '-' IN rv_rtti WITH '\CLASS='.
      REPLACE FIRST OCCURRENCE OF '#' IN rv_rtti WITH '-'.
    ELSE.
      rv_rtti = '\CLASS=' && rv_rtti.
    ENDIF.
  ENDMETHOD.

  METHOD rtti_to_internal.
    rv_internal = iv_rtti.
    IF rv_internal CP '\CLASS=*'.
      REPLACE FIRST OCCURRENCE OF '\CLASS=' IN rv_internal WITH ''.
    ELSEIF rv_internal CP '\CLASS-POOL=*'.
      REPLACE FIRST OCCURRENCE OF '\CLASS-POOL=' IN rv_internal WITH 'CLAS-'.
      REPLACE FIRST OCCURRENCE OF '\CLASS=' IN rv_internal WITH '-'.
      REPLACE FIRST OCCURRENCE OF '\INTERFACE=' IN rv_internal WITH '-'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.