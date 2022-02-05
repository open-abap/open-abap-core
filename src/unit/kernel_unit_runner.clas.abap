CLASS kernel_unit_runner DEFINITION PUBLIC.
  PUBLIC SECTION.
* as of now, only global classes with local testclasses are supported
    TYPES: BEGIN OF ty_input_item,
             class_name     TYPE abap_compname,
             testclass_name TYPE abap_compname,
             method_name    TYPE abap_compname,
           END OF ty_input_item.
    TYPES ty_input TYPE STANDARD TABLE OF ty_input_item WITH DEFAULT KEY.

    TYPES BEGIN OF ty_result_item.
    INCLUDE TYPE ty_input_item.
    TYPES:   expected    TYPE string,
             actual      TYPE string,
             runtime     TYPE i,
             message     TYPE string,
             js_location TYPE string,
           END OF ty_result_item.
    TYPES ty_result TYPE STANDARD TABLE OF ty_result_item WITH DEFAULT KEY.

    CLASS-METHODS run
      IMPORTING
        it_input TYPE ty_input
      RETURNING
        VALUE(rt_result) TYPE ty_result.
ENDCLASS.

CLASS kernel_unit_runner IMPLEMENTATION.

  METHOD run.

    DATA ls_input LIKE LINE OF it_input.
    DATA lv_time TYPE i.
    DATA lo_obj TYPE REF TO object.
    DATA lv_name TYPE string.
    FIELD-SYMBOLS <ls_result> LIKE LINE OF rt_result.

    LOOP AT it_input INTO ls_input.
      APPEND INITIAL LINE TO rt_result ASSIGNING <ls_result>.
      MOVE-CORRESPONDING ls_input TO <ls_result>.
      GET RUN TIME FIELD lv_time.

* default quit level = method?

* this is special, and must match the runtime:
      lv_name = |CLAS-{ ls_input-class_name }-{ ls_input-testclass_name }|.
      CREATE OBJECT lo_obj TYPE (lv_name).
      CALL METHOD lo_obj->(ls_input-method_name).

      GET RUN TIME FIELD lv_time.
      <ls_result>-runtime = lv_time.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.