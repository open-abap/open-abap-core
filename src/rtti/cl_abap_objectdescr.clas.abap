CLASS cl_abap_objectdescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.
  PUBLIC SECTION.
    METHODS get_attribute_type
      IMPORTING
        p_name TYPE any
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_datadescr.

  PROTECTED SECTION.
    DATA mv_object_name TYPE string.
    DATA mv_object_type TYPE string.
ENDCLASS.

CLASS cl_abap_objectdescr IMPLEMENTATION.
  METHOD get_attribute_type.
    DATA lv_name TYPE string.
    DATA l_sub   TYPE string.
    DATA l_any   TYPE string.

    lv_name = p_name.

    WRITE '@KERNEL let foo = abap.Classes[this.mv_object_name.get()];'.

    CONCATENATE mv_object_name '$' lv_name INTO l_sub.
    l_sub = to_lower( l_sub ).

    " note that the typing here is misused
    WRITE '@KERNEL l_any = foo[l_sub.get()];'.

    p_descr_ref ?= describe_by_data( l_any ).
  ENDMETHOD.
ENDCLASS.