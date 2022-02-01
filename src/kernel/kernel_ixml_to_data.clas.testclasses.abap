CLASS ltcl_ixml_to_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test_elem FOR TESTING RAISING cx_static_check.
    METHODS test_stru FOR TESTING RAISING cx_static_check.
    METHODS test_table FOR TESTING RAISING cx_static_check.
  
ENDCLASS.

CLASS ltcl_ixml_to_data IMPLEMENTATION.

  METHOD test_elem.

    DATA li_doc TYPE REF TO if_ixml_document.
    DATA target TYPE i.
    DATA lv_ref TYPE REF TO data.

    li_doc = kernel_json_to_ixml=>build( '{"DATA": 2}' ).
    GET REFERENCE OF target INTO lv_ref.

    kernel_ixml_to_data=>build(
      iv_name = 'DATA'
      iv_ref  = lv_ref
      ii_doc  = li_doc ).

    cl_abap_unit_assert=>assert_equals(
      act = target
      exp = 2 ).
      
  ENDMETHOD.

  METHOD test_stru.

    DATA li_doc TYPE REF TO if_ixml_document.
    DATA: BEGIN OF target,
            field TYPE i,
          END OF target.
    DATA lv_ref TYPE REF TO data.

    li_doc = kernel_json_to_ixml=>build( '{"DATA": {"FIELD": 321}}' ).
    GET REFERENCE OF target INTO lv_ref.

    kernel_ixml_to_data=>build(
      iv_name = 'DATA'
      iv_ref  = lv_ref
      ii_doc  = li_doc ).

    cl_abap_unit_assert=>assert_equals(
      act = target-field
      exp = 321 ).
      
  ENDMETHOD.

  METHOD test_table.

    TYPES: BEGIN OF ty_message,
             field TYPE i,
           END OF ty_message.
    DATA target TYPE STANDARD TABLE OF ty_message WITH DEFAULT KEY.
    DATA row LIKE LINE OF target.
    DATA lv_ref TYPE REF TO data.
    DATA li_doc TYPE REF TO if_ixml_document.
    DATA lv_input TYPE string.
    
    li_doc = kernel_json_to_ixml=>build( '{"DATA": [{"FIELD": 321}]}' ).
    GET REFERENCE OF target INTO lv_ref.

    kernel_ixml_to_data=>build(
      iv_name = 'DATA'
      iv_ref  = lv_ref
      ii_doc  = li_doc ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( target )
      exp = 1 ).
    READ TABLE target INDEX 1 INTO row.
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = row-field
      exp = 321 ).

  ENDMETHOD.

ENDCLASS.