CLASS ltcl_wwwdata_import DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    CONSTANTS c_objid TYPE wwwdatatab-objid VALUE 'KERNEL_W3MI_TEST_600'.
    DATA mt_mime TYPE STANDARD TABLE OF w3mime WITH DEFAULT KEY.

    METHODS setup.
    METHODS import
      IMPORTING iv_relid        TYPE wwwdatatab-relid
                iv_objid        TYPE wwwdatatab-objid
      RETURNING VALUE(rv_subrc) TYPE i.

    METHODS rows FOR TESTING RAISING cx_static_check.
    METHODS miss_keeps_rows FOR TESTING RAISING cx_static_check.
    METHODS wrong_relid FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_wwwdata_import IMPLEMENTATION.

  METHOD setup.
* an object of 600 bytes 00 01 02 ..., registered the way the transpiler
* registers a W3MI object, its file beside the modules
    WRITE '@KERNEL const fs = await import("fs");'.
    WRITE '@KERNEL const path = await import("path");'.
    WRITE '@KERNEL const url = await import("url");'.
    WRITE '@KERNEL const dir = path.dirname(url.fileURLToPath(import.meta.url));'.
    WRITE '@KERNEL const bytes = Buffer.alloc(600);'.
    WRITE '@KERNEL for (let i = 0; i < 600; i++) { bytes[i] = i % 256; }'.
    WRITE '@KERNEL fs.writeFileSync(dir + path.sep + "kernel_w3mi_test_600.data.bin", bytes);'.
    WRITE '@KERNEL abap.W3MI["KERNEL_W3MI_TEST_600"] = {"objectType": "W3MI", "filename": "kernel_w3mi_test_600.data.bin"};'.
    CLEAR mt_mime.
  ENDMETHOD.

  METHOD import.
    DATA ls_key TYPE wwwdatatab.
    ls_key-relid = iv_relid.
    ls_key-objid = iv_objid.
    CALL FUNCTION 'WWWDATA_IMPORT'
      EXPORTING
        key               = ls_key
      TABLES
        mime              = mt_mime
      EXCEPTIONS
        wrong_object_type = 1
        import_error      = 2
        OTHERS            = 3.
    rv_subrc = sy-subrc.
  ENDMETHOD.

  METHOD rows.
    DATA ls_row  TYPE w3mime.
    DATA lv_last TYPE xstring.
    DATA lv_four TYPE x LENGTH 4.

    APPEND ls_row TO mt_mime.
    cl_abap_unit_assert=>assert_equals(
      act = import( iv_relid = 'MI'
                    iv_objid = c_objid )
      exp = 0 ).
* the rows are replaced: 255 + 255 + 90, the last one padded with 00
    cl_abap_unit_assert=>assert_equals(
      act = lines( mt_mime )
      exp = 3 ).
    READ TABLE mt_mime INDEX 1 INTO ls_row.
    lv_last = ls_row-line.
    lv_four = lv_last(4).
    cl_abap_unit_assert=>assert_equals(
      act = lv_four
      exp = '00010203' ).
    READ TABLE mt_mime INDEX 3 INTO ls_row.
    lv_last = ls_row-line.
    lv_four = lv_last+88(4).
    cl_abap_unit_assert=>assert_equals(
      act = lv_four
      exp = '56570000' ).
  ENDMETHOD.

  METHOD miss_keeps_rows.
    DATA ls_row TYPE w3mime.

    ls_row-line = 'FF'.
    APPEND ls_row TO mt_mime.
    cl_abap_unit_assert=>assert_equals(
      act = import( iv_relid = 'MI'
                    iv_objid = 'KERNEL_W3MI_TEST_NO_SUCH' )
      exp = 2 ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( mt_mime )
      exp = 1 ).
  ENDMETHOD.

  METHOD wrong_relid.
    cl_abap_unit_assert=>assert_equals(
      act = import( iv_relid = 'XX'
                    iv_objid = c_objid )
      exp = 1 ).
    cl_abap_unit_assert=>assert_equals(
      act = lines( mt_mime )
      exp = 0 ).
  ENDMETHOD.

ENDCLASS.
