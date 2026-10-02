CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS worksheet_names FOR TESTING RAISING cx_static_check.
    METHODS cells FOR TESTING RAISING cx_static_check.
    METHODS columns FOR TESTING RAISING cx_static_check.
    METHODS without_references FOR TESTING RAISING cx_static_check.
    METHODS absolute_target FOR TESTING RAISING cx_static_check.
    METHODS unknown_worksheet FOR TESTING RAISING cx_static_check.
    METHODS not_a_spreadsheet FOR TESTING RAISING cx_static_check.

    METHODS build
      IMPORTING
        iv_sheet1          TYPE string
        iv_sheet2          TYPE string OPTIONAL
        iv_target2         TYPE string DEFAULT 'worksheets/sheet2.xml'
      RETURNING
        VALUE(rv_document) TYPE xstring.

    METHODS sheet
      IMPORTING
        iv_rows       TYPE string
      RETURNING
        VALUE(rv_xml) TYPE string.

    METHODS value
      IMPORTING
        ir_itab         TYPE REF TO data
        iv_row          TYPE i
        iv_column       TYPE string
      RETURNING
        VALUE(rv_value) TYPE string.
ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD build.
    DATA lo_zip      TYPE REF TO cl_abap_zip.
    DATA lv_workbook TYPE string.
    DATA lv_rels     TYPE string.

    lv_workbook = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' &&
      `<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" ` &&
      'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets>' &&
      '<sheet name="First" sheetId="1" r:id="rId1"/>'.
    lv_rels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' &&
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">' &&
      `<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" ` &&
      'Target="sharedStrings.xml"/>' &&
      `<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" ` &&
      'Target="worksheets/sheet1.xml"/>'.
    IF iv_sheet2 IS NOT INITIAL.
      lv_workbook = lv_workbook && '<sheet name="Second" sheetId="2" r:id="rId2"/>'.
      lv_rels = lv_rels &&
        `<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" ` &&
        'Target="' && iv_target2 && '"/>'.
    ENDIF.
    lv_workbook = lv_workbook && '</sheets></workbook>'.
    lv_rels = lv_rels && '</Relationships>'.

    CREATE OBJECT lo_zip.
    lo_zip->add( name    = 'xl/workbook.xml'
                 content = cl_abap_codepage=>convert_to( lv_workbook ) ).
    lo_zip->add( name    = 'xl/_rels/workbook.xml.rels'
                 content = cl_abap_codepage=>convert_to( lv_rels ) ).
    lo_zip->add( name    = 'xl/sharedStrings.xml'
                 content = cl_abap_codepage=>convert_to(
      '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' &&
      '<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="3" uniqueCount="3">' &&
      '<si><t>Name</t></si>' &&
      '<si><r><t>Qu</t></r><r><rPr><b/></rPr><t>antity</t></r></si>' &&
      '<si><t>Kanji</t><rPh sb="0" eb="1"><t>kana</t></rPh></si>' &&
      '</sst>' ) ).
    lo_zip->add( name    = 'xl/worksheets/sheet1.xml'
                 content = cl_abap_codepage=>convert_to( iv_sheet1 ) ).
    IF iv_sheet2 IS NOT INITIAL.
      lo_zip->add( name    = 'xl/worksheets/sheet2.xml'
                   content = cl_abap_codepage=>convert_to( iv_sheet2 ) ).
    ENDIF.
    rv_document = lo_zip->save( ).
  ENDMETHOD.

  METHOD sheet.
    rv_xml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' &&
      '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>' &&
      iv_rows &&
      '</sheetData></worksheet>'.
  ENDMETHOD.

  METHOD value.
    FIELD-SYMBOLS <lt_table> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <ls_line>  TYPE any.
    FIELD-SYMBOLS <lv_value> TYPE any.

    ASSIGN ir_itab->* TO <lt_table>.
    READ TABLE <lt_table> INDEX iv_row ASSIGNING <ls_line>.
    cl_abap_unit_assert=>assert_subrc( ).
    ASSIGN COMPONENT iv_column OF STRUCTURE <ls_line> TO <lv_value>.
    cl_abap_unit_assert=>assert_subrc( ).
    rv_value = <lv_value>.
  ENDMETHOD.

  METHOD worksheet_names.
    DATA lo_excel TYPE REF TO cl_fdt_xl_spreadsheet.
    DATA lt_names TYPE if_fdt_doc_spreadsheet=>t_worksheet_names.
    DATA lt_exp   TYPE if_fdt_doc_spreadsheet=>t_worksheet_names.

    CREATE OBJECT lo_excel
      EXPORTING
        document_name = 'test.xlsx'
        xdocument     = build( iv_sheet1 = sheet( '' )
                               iv_sheet2 = sheet( '' ) ).
    lo_excel->if_fdt_doc_spreadsheet~get_worksheet_names( IMPORTING worksheet_names = lt_names ).

    APPEND 'First' TO lt_exp.
    APPEND 'Second' TO lt_exp.
    cl_abap_unit_assert=>assert_equals(
      act = lt_names
      exp = lt_exp ).
  ENDMETHOD.

  METHOD cells.
    DATA lo_excel TYPE REF TO cl_fdt_xl_spreadsheet.
    DATA lr_itab  TYPE REF TO data.

    FIELD-SYMBOLS <lt_table> TYPE STANDARD TABLE.

    CREATE OBJECT lo_excel
      EXPORTING
        document_name = 'test.xlsx'
        xdocument     = build( sheet(
          '<row r="1"><c r="A1" t="s"><v>0</v></c><c r="B1" t="s"><v>1</v></c>' &&
          '<c r="D1" t="inlineStr"><is><t>Note</t></is></c></row>' &&
          '<row r="3"><c r="A3"><v>42.5</v></c><c r="B3" t="str"><f>A3&amp;"x"</f><v>42.5x</v></c>' &&
          '<c r="C3" t="s"><v>2</v></c><c r="D3" t="b"><v>1</v></c></row>' ) ).
    lr_itab = lo_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( 'First' ).

    ASSIGN lr_itab->* TO <lt_table>.
    cl_abap_unit_assert=>assert_equals(
      act = lines( <lt_table> )
      exp = 3 ).

    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 1
                   iv_column = 'A' )
      exp = 'Name' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 1
                   iv_column = 'B' )
      exp = 'Quantity' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 1
                   iv_column = 'C' )
      exp = '' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 1
                   iv_column = 'D' )
      exp = 'Note' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 2
                   iv_column = 'A' )
      exp = '' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 3
                   iv_column = 'A' )
      exp = '42.5' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 3
                   iv_column = 'B' )
      exp = '42.5x' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 3
                   iv_column = 'C' )
      exp = 'Kanji' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 3
                   iv_column = 'D' )
      exp = '1' ).
  ENDMETHOD.

  METHOD columns.
    DATA lo_excel      TYPE REF TO cl_fdt_xl_spreadsheet.
    DATA lr_itab       TYPE REF TO data.
    DATA lo_table      TYPE REF TO cl_abap_tabledescr.
    DATA lo_structure  TYPE REF TO cl_abap_structdescr.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.

    CREATE OBJECT lo_excel
      EXPORTING
        document_name = 'test.xlsx'
        xdocument     = build( sheet( '<row r="1"><c r="AB1"><v>1</v></c></row>' ) ).
    lr_itab = lo_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( 'First' ).

    lo_table ?= cl_abap_typedescr=>describe_by_data_ref( lr_itab ).
    lo_structure ?= lo_table->get_table_line_type( ).
    lt_components = lo_structure->get_components( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_components )
      exp = 28 ).
    READ TABLE lt_components INDEX 26 INTO ls_component.
    cl_abap_unit_assert=>assert_equals(
      act = ls_component-name
      exp = 'Z' ).
    READ TABLE lt_components INDEX 28 INTO ls_component.
    cl_abap_unit_assert=>assert_equals(
      act = ls_component-name
      exp = 'AB' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 1
                   iv_column = 'AB' )
      exp = '1' ).
  ENDMETHOD.

  METHOD without_references.
    DATA lo_excel TYPE REF TO cl_fdt_xl_spreadsheet.
    DATA lr_itab  TYPE REF TO data.

    CREATE OBJECT lo_excel
      EXPORTING
        document_name = 'test.xlsx'
        xdocument     = build( sheet(
          '<row><c><v>1</v></c><c><v>2</v></c></row>' &&
          '<row><c><v>3</v></c></row>' ) ).
    lr_itab = lo_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( 'First' ).

    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 1
                   iv_column = 'B' )
      exp = '2' ).
    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 2
                   iv_column = 'A' )
      exp = '3' ).
  ENDMETHOD.

  METHOD absolute_target.
    DATA lo_excel TYPE REF TO cl_fdt_xl_spreadsheet.
    DATA lr_itab  TYPE REF TO data.

    CREATE OBJECT lo_excel
      EXPORTING
        document_name = 'test.xlsx'
        xdocument     = build( iv_sheet1  = sheet( '' )
                               iv_sheet2  = sheet( '<row r="1"><c r="A1"><v>7</v></c></row>' )
                               iv_target2 = '/xl/worksheets/sheet2.xml' ).
    lr_itab = lo_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( 'Second' ).

    cl_abap_unit_assert=>assert_equals(
      act = value( ir_itab   = lr_itab
                   iv_row    = 1
                   iv_column = 'A' )
      exp = '7' ).
  ENDMETHOD.

  METHOD unknown_worksheet.
    DATA lo_excel TYPE REF TO cl_fdt_xl_spreadsheet.
    DATA lr_itab  TYPE REF TO data.

    CREATE OBJECT lo_excel
      EXPORTING
        document_name = 'test.xlsx'
        xdocument     = build( sheet( '' ) ).
    lr_itab = lo_excel->if_fdt_doc_spreadsheet~get_itab_from_worksheet( 'Missing' ).

    cl_abap_unit_assert=>assert_initial( lr_itab ).
  ENDMETHOD.

  METHOD not_a_spreadsheet.
    DATA lo_excel TYPE REF TO cl_fdt_xl_spreadsheet.

    TRY.
        CREATE OBJECT lo_excel
          EXPORTING
            document_name = 'test.txt'
            xdocument     = cl_abap_codepage=>convert_to( 'hello' ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_fdt_excel_core.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
