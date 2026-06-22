CLASS cl_abap_api_state DEFINITION PUBLIC CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_abap_api_state.

    ALIASES release FOR if_abap_api_state~release.
    ALIASES delete_release_state FOR if_abap_api_state~delete_release_state.
    ALIASES is_released FOR if_abap_api_state~is_released.

    CLASS-METHODS create_instance
      IMPORTING
        api_key       TYPE if_abap_api_state=>ty_api_key
      RETURNING
        VALUE(result) TYPE REF TO if_abap_api_state
      RAISING
        cx_abap_api_state.

  PRIVATE SECTION.
    DATA api_key TYPE if_abap_api_state=>ty_api_key.

    METHODS constructor
      IMPORTING
        api_key TYPE if_abap_api_state=>ty_api_key.
ENDCLASS.

CLASS cl_abap_api_state IMPLEMENTATION.

  METHOD constructor.
    me->api_key = api_key.
  ENDMETHOD.

  METHOD create_instance.
    result = NEW cl_abap_api_state( api_key ).
  ENDMETHOD.

  METHOD if_abap_api_state~release.
    RETURN.
  ENDMETHOD.

  METHOD if_abap_api_state~delete_release_state.
    RETURN.
  ENDMETHOD.

  METHOD if_abap_api_state~is_released.
    result = abap_false.
  ENDMETHOD.

ENDCLASS.
