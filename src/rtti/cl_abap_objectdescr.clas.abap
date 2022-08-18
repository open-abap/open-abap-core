CLASS cl_abap_objectdescr DEFINITION PUBLIC INHERITING FROM cl_abap_typedescr.
  PUBLIC SECTION.
    METHODS get_attribute_type
      IMPORTING
        p_name TYPE any
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_datadescr.

    CONSTANTS changing TYPE abap_parmkind VALUE 'C'.
    CONSTANTS exporting TYPE abap_parmkind VALUE 'E'.
    CONSTANTS importing TYPE abap_parmkind VALUE 'I'.
    CONSTANTS receiving TYPE abap_parmkind VALUE 'R'.
    CONSTANTS returning TYPE abap_parmkind VALUE 'R'.

    CONSTANTS private TYPE abap_visibility VALUE 'I'.
    CONSTANTS protected TYPE abap_visibility VALUE 'O'.
    CONSTANTS public TYPE abap_visibility VALUE 'U'.

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