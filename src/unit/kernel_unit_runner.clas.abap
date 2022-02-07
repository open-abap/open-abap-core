CLASS kernel_unit_runner DEFINITION PUBLIC.
  PUBLIC SECTION.
* as of now, only global classes with local testclasses are supported
    TYPES: BEGIN OF ty_input_item,
             class_name     TYPE c LENGTH 30,
             testclass_name TYPE c LENGTH 30,
             method_name    TYPE c LENGTH 30,
           END OF ty_input_item.
    TYPES ty_input TYPE STANDARD TABLE OF ty_input_item WITH DEFAULT KEY.

    TYPES ty_status TYPE string.
    CONSTANTS: BEGIN OF gc_status,
                success TYPE ty_status VALUE 'SUCCESS',
                failed  TYPE ty_status VALUE 'FAILED',
                skipped TYPE ty_status VALUE 'SKIPPED',
               END OF gc_status.

    TYPES BEGIN OF ty_result_item.
    INCLUDE TYPE ty_input_item.
    TYPES: expected    TYPE string,
             actual      TYPE string,
             status      TYPE ty_status,
             runtime     TYPE i,
             message     TYPE string,
             js_location TYPE string,
           END OF ty_result_item.
    TYPES: BEGIN OF ty_result,
             list TYPE STANDARD TABLE OF ty_result_item WITH DEFAULT KEY,
             json TYPE string,
           END OF ty_result.

    CLASS-METHODS run
      IMPORTING
        it_input TYPE ty_input
      RETURNING
        VALUE(rs_result) TYPE ty_result.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_class_item,
             class_name     TYPE c LENGTH 30,
             testclass_name TYPE c LENGTH 30,
           END OF ty_class_item.
    TYPES ty_classes TYPE STANDARD TABLE OF ty_class_item WITH DEFAULT KEY.

    CLASS-METHODS unique_classes
      IMPORTING
       it_input TYPE ty_input
      RETURNING
        VALUE(rt_classes) TYPE ty_classes.

    CLASS-METHODS to_json
      IMPORTING it_list TYPE ty_result-list
      RETURNING VALUE(rv_json) TYPE string.

    CLASS-METHODS get_location
      IMPORTING ix_error TYPE REF TO cx_root
      RETURNING VALUE(rv_location) TYPE string.
ENDCLASS.

CLASS kernel_unit_runner IMPLEMENTATION.

  METHOD get_location.
    DATA lv_stack TYPE string.
    DATA lt_lines TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lv_found TYPE abap_bool.
    WRITE '@KERNEL lv_stack.set(INPUT.ix_error.get().stack);'.
    SPLIT lv_stack AT |\n| INTO TABLE lt_lines.
* find whatever comes after "cl_abap_unit_assert"
    LOOP AT lt_lines INTO lv_stack.
      IF lv_stack CP '*cl_abap_unit_assert*'.
        lv_found = abap_true.
        CONTINUE.
      ELSEIF lv_found = abap_true.
        REPLACE FIRST OCCURRENCE OF |at | IN lv_stack WITH ''.
        rv_location = condense( lv_stack ).
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD to_json.
* would like to keep the dependencies of this class minimal, 
* so not using CALL TRANSFORMATION or any other ABAP classes    

    DATA ls_list LIKE LINE OF it_list.
    DATA lt_strings TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lv_string LIKE LINE OF lt_strings.
    DATA lv_message TYPE string.


    LOOP AT it_list INTO ls_list.
      lv_message = ls_list-message.
      REPLACE ALL OCCURENCES OF |"| IN lv_message WITH |\"|.
      lv_string = |\{"class_name": "{ ls_list-class_name
        }","testclass_name": "{ ls_list-testclass_name 
        }","method_name": "{ ls_list-method_name 
        }","expected": "{ ls_list-expected 
        }","actual": "{ ls_list-actual 
        }","status": "{ ls_list-status 
        }","runtime": { ls_list-runtime 
        },"message": "{ lv_message 
        }","js_location": "{ ls_list-js_location }"\}|.
      APPEND lv_string TO lt_strings.
    ENDLOOP.
    CONCATENATE LINES OF lt_strings INTO rv_json SEPARATED BY ','.
    rv_json = '[' && rv_json && ']'.
  ENDMETHOD.

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

    DATA ls_input   LIKE LINE OF it_input.
    DATA lv_time    TYPE i.
    DATA lo_obj     TYPE REF TO object.
    DATA lv_name    TYPE string.
    DATA lt_classes TYPE ty_classes.
    DATA ls_class   LIKE LINE OF lt_classes.
    DATA lx_root    TYPE REF TO cx_root.
    DATA lx_assert  TYPE REF TO kernel_cx_assert.
    FIELD-SYMBOLS <ls_result> LIKE LINE OF rs_result-list.

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
        APPEND INITIAL LINE TO rs_result-list ASSIGNING <ls_result>.
        MOVE-CORRESPONDING ls_input TO <ls_result>.

        TRY.
            CALL METHOD lo_obj->('SETUP').
          CATCH cx_sy_dyn_call_illegal_method.
        ENDTRY.

        GET RUN TIME FIELD lv_time.
        TRY.
            CALL METHOD lo_obj->(ls_input-method_name).
            <ls_result>-status = gc_status-success.
          CATCH kernel_cx_assert INTO lx_assert.
            <ls_result>-status      = gc_status-failed.
            <ls_result>-actual      = lx_assert->actual.
            <ls_result>-expected    = lx_assert->expected.
            <ls_result>-message     = lx_assert->message.
            <ls_result>-js_location = get_location( lx_assert ).
          CATCH cx_root INTO lx_root.
            <ls_result>-status  = gc_status-failed.
            <ls_result>-message = |Some exception raised|. " todo, use RTTI to find the class name?
            <ls_result>-js_location = get_location( lx_root ).
        ENDTRY.
        GET RUN TIME FIELD lv_time.
        <ls_result>-runtime = lv_time.

        TRY.
            CALL METHOD lo_obj->('TEARDOWN').
          CATCH cx_sy_dyn_call_illegal_method.
        ENDTRY.
      ENDLOOP.

      TRY.
          CALL METHOD lo_obj->('CLASS_TEARDOWN').
        CATCH cx_sy_dyn_call_illegal_method.
      ENDTRY.

    ENDLOOP.

    rs_result-json = to_json( rs_result-list ).

  ENDMETHOD.

ENDCLASS.