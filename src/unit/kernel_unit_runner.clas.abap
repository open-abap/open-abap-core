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
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_class_item,
             class_name     TYPE abap_compname,
             testclass_name TYPE abap_compname,
           END OF ty_class_item.
    TYPES ty_classes TYPE STANDARD TABLE OF ty_class_item WITH DEFAULT KEY.

    CLASS-METHODS unique_classes
      IMPORTING
       it_input TYPE ty_input
      RETURNING
        VALUE(rt_classes) TYPE ty_classes.
ENDCLASS.

CLASS kernel_unit_runner IMPLEMENTATION.

  METHOD unique_classes.
    DATA ls_input LIKE LINE OF it_input.
    DATA ls_class LIKE LINE OF rt_classes.
    LOOP AT it_input INTO ls_input.
      MOVE-CORRESPONDING ls_input TO ls_class.
      INSERT ls_class INTO TABLE rt_classes.
    ENDLOOP.
    SORT rt_classes.
    DELETE ADJACENT DUPLICATES FROM rt_classes.
  ENDMETHOD.

  METHOD run.

    DATA ls_input LIKE LINE OF it_input.
    DATA lv_time TYPE i.
    DATA lo_obj TYPE REF TO object.
    DATA lv_name TYPE string.
    DATA lt_classes TYPE ty_classes.
    DATA ls_class LIKE LINE OF lt_classes.
    FIELD-SYMBOLS <ls_result> LIKE LINE OF rt_result.

* todo, respect quit level, default = method?

    lt_classes = unique_classes( it_input ).

    LOOP AT lt_classes INTO ls_class.
* this is special, and must match the runtime:
      lv_name = |CLAS-{ ls_class-class_name }-{ ls_class-testclass_name }|.
      CREATE OBJECT lo_obj TYPE (lv_name).

      TRY.
          CALL METHOD lo_obj->('CLASS_SETUP').
        CATCH cx_sy_dyn_call_illegal_method.
      ENDTRY.
      
      LOOP AT it_input INTO ls_input WHERE class_name = ls_class-class_name AND testclass_name = ls_class-testclass_name.
        APPEND INITIAL LINE TO rt_result ASSIGNING <ls_result>.
        MOVE-CORRESPONDING ls_input TO <ls_result>.
        GET RUN TIME FIELD lv_time.

        TRY.
            CALL METHOD lo_obj->('SETUP').
          CATCH cx_sy_dyn_call_illegal_method.
        ENDTRY.

        CALL METHOD lo_obj->(ls_input-method_name).

        TRY.
            CALL METHOD lo_obj->('TEARDOWN').
          CATCH cx_sy_dyn_call_illegal_method.
        ENDTRY.

        GET RUN TIME FIELD lv_time.
        <ls_result>-runtime = lv_time.
      ENDLOOP.

      TRY.
          CALL METHOD lo_obj->('CLASS_TEARDOWN').
        CATCH cx_sy_dyn_call_illegal_method.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.