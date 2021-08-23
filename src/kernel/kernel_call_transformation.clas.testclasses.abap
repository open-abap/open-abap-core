CLASS ltcl_call_transformation DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test1 FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_call_transformation IMPLEMENTATION.

  METHOD test1.
    DATA lv_xml TYPE string.
    DATA: BEGIN OF ls_foo,
            foo TYPE i,
          END OF ls_foo.
    
    lv_xml = |<?xml version="1.0" encoding="utf-16"?>\n| &&
      |<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">\n| &&
      | <asx:values>\n| &&
      |  <DATA>\n| &&
      |   <FOO>2</FOO>\n| &&
      |  </DATA>\n| &&
      | </asx:values>\n| &&
      |</asx:abap>|.
    
    CALL TRANSFORMATION id
      SOURCE XML lv_xml
      RESULT data = ls_foo.
    
    WRITE '@KERNEL console.dir(ls_foo);'.

    cl_abap_unit_assert=>assert_equals(
      act = ls_foo-foo
      exp = 2 ).
  ENDMETHOD.

ENDCLASS.