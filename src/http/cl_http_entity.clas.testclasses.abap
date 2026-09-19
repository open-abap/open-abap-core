CLASS ltcl_form_fields DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS get_by_the_name_it_was_set FOR TESTING RAISING cx_static_check.
    METHODS get_ignoring_case FOR TESTING RAISING cx_static_check.
    METHODS get_missing FOR TESTING RAISING cx_static_check.

    METHODS entity
      IMPORTING
        iv_name          TYPE string
      RETURNING
        VALUE(ro_entity) TYPE REF TO cl_http_entity.

ENDCLASS.

CLASS ltcl_form_fields IMPLEMENTATION.

  METHOD entity.
    DATA lt_fields TYPE tihttpnvp.
    DATA ls_field  TYPE ihttpnvp.

    CREATE OBJECT ro_entity.
    ls_field-name  = iv_name.
    ls_field-value = 'X'.
    APPEND ls_field TO lt_fields.
    ro_entity->if_http_entity~set_form_fields( lt_fields ).
  ENDMETHOD.

  METHOD get_by_the_name_it_was_set.
* the setters store the name as given, so a name that is not already lower
* case has to be readable by the name it was set with
    DATA lo_entity TYPE REF TO cl_http_entity.
    lo_entity = entity( 'f_STATUS' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_entity->if_http_entity~get_form_field( 'f_STATUS' )
      exp = 'X' ).
  ENDMETHOD.

  METHOD get_ignoring_case.
    DATA lo_entity TYPE REF TO cl_http_entity.
    lo_entity = entity( 'f_STATUS' ).
    cl_abap_unit_assert=>assert_equals(
      act = lo_entity->if_http_entity~get_form_field( 'f_status' )
      exp = 'X' ).
  ENDMETHOD.

  METHOD get_missing.
    DATA lo_entity TYPE REF TO cl_http_entity.
    lo_entity = entity( 'f_STATUS' ).
    cl_abap_unit_assert=>assert_initial( lo_entity->if_http_entity~get_form_field( 'nope' ) ).
  ENDMETHOD.

ENDCLASS.
