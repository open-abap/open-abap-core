CLASS cl_abap_classdescr DEFINITION PUBLIC INHERITING FROM cl_abap_objectdescr.
  PUBLIC SECTION.

    DATA class_kind TYPE string.
    DATA create_visibility TYPE string.

    CLASS-METHODS get_class_name
      IMPORTING
        p_object      TYPE REF TO object
      RETURNING
        VALUE(p_name) TYPE abap_abstypename.

    METHODS get_super_class_type
      RETURNING
        VALUE(p_descr_ref) TYPE REF TO cl_abap_classdescr
      EXCEPTIONS
        super_class_not_found.

ENDCLASS.

CLASS cl_abap_classdescr IMPLEMENTATION.

  METHOD get_class_name.
    DATA lv_name TYPE string.
    WRITE '@KERNEL lv_name.set(p_object.get().constructor.INTERNAL_NAME);'.
    p_name = kernel_internal_name=>internal_to_rtti( lv_name ).
  ENDMETHOD.

  METHOD get_super_class_type.
    DATA lv_super_name TYPE string.
    DATA lo_type       TYPE REF TO cl_abap_typedescr.

    WRITE '@KERNEL let cls = abap.Classes[this.mv_object_name?.get()?.toUpperCase()?.trimEnd()];'.
    WRITE '@KERNEL if (!cls) { cls = abap.Classes[this.relative_name?.get()?.toUpperCase()?.trimEnd()]; }'.
    WRITE '@KERNEL if (cls?.STATIC_SUPER && cls.STATIC_SUPER.INTERNAL_NAME) {'.
    WRITE '@KERNEL   lv_super_name.set(cls.STATIC_SUPER.INTERNAL_NAME);'.
    WRITE '@KERNEL }'.

    IF lv_super_name IS INITIAL.
      RAISE super_class_not_found.
    ENDIF.

    cl_abap_typedescr=>describe_by_name(
      EXPORTING
        p_name         = lv_super_name
      RECEIVING
        type           = lo_type
      EXCEPTIONS
        type_not_found = 1
        OTHERS         = 2 ).
    IF sy-subrc <> 0 OR lo_type IS NOT BOUND OR lo_type->kind <> kind_class.
      RAISE super_class_not_found.
    ENDIF.

    p_descr_ref ?= lo_type.
  ENDMETHOD.
ENDCLASS.
