"! ABAP Test Double Framework, doubles of global interfaces
"! open-abap: classes cannot be doubled yet, raise_event is not supported,
"! the class is not FOR TESTING, like cl_abap_unit_assert
CLASS cl_abap_testdouble DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES ty_object_name TYPE c LENGTH 30.

    CLASS-METHODS create
      IMPORTING
        object_name   TYPE ty_object_name
        double_name   TYPE string OPTIONAL
      RETURNING
        VALUE(double) TYPE REF TO object.

    CLASS-METHODS configure_call
      IMPORTING
        double               TYPE REF TO object
      RETURNING
        VALUE(configuration) TYPE REF TO if_abap_testdouble_config.

    CLASS-METHODS verify_expectations
      IMPORTING
        double TYPE REF TO object.

ENDCLASS.

CLASS cl_abap_testdouble IMPLEMENTATION.

  METHOD create.
    DATA lv_name        TYPE string.
    DATA lv_object_name TYPE abap_intfname.
    DATA lo_type        TYPE REF TO cl_abap_typedescr.
    DATA lo_double      TYPE REF TO lcl_double.

    lv_name = to_upper( condense( object_name ) ).
    lv_object_name = lv_name.
    cl_abap_typedescr=>describe_by_name(
      EXPORTING
        p_name         = lv_name
      RECEIVING
        type           = lo_type
      EXCEPTIONS
        type_not_found = 1 ).
    IF sy-subrc <> 0.
      lcl_error=>raise(
        iv_text        = |{ lv_name } does not exist|
        iv_object_name = lv_object_name ).
    ELSEIF lo_type->kind <> cl_abap_typedescr=>kind_intf.
      lcl_error=>raise(
        iv_text        = |{ lv_name } is not an interface, open-abap doubles interfaces only|
        iv_object_name = lv_object_name ).
    ENDIF.

    CREATE OBJECT lo_double
      EXPORTING
        iv_interface = lv_name.
    double = lo_double->mo_object.
  ENDMETHOD.

  METHOD configure_call.
    configuration = lcl_double=>find( double )->configure_call( ).
  ENDMETHOD.

  METHOD verify_expectations.
    lcl_double=>find( double )->verify( ).
  ENDMETHOD.

ENDCLASS.
