CLASS ltcl_ixml_to_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.
  
ENDCLASS.

CLASS ltcl_ixml_to_data IMPLEMENTATION.

  METHOD test1.

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

ENDCLASS.