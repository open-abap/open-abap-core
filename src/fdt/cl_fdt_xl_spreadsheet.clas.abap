CLASS cl_fdt_xl_spreadsheet DEFINITION PUBLIC CREATE PUBLIC.
* reads the worksheets of an Office Open XML spreadsheet, ie. a .xlsx file

  PUBLIC SECTION.
    INTERFACES if_fdt_doc_spreadsheet.

    METHODS constructor
      IMPORTING
        document_name TYPE string
        xdocument     TYPE xstring
        mime_type     TYPE string OPTIONAL
      RAISING
        cx_fdt_excel_core.

  PRIVATE SECTION.
    CONSTANTS gc_relationships TYPE string VALUE 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'.

    TYPES: BEGIN OF ty_sheet,
             name TYPE string,
             path TYPE string,
           END OF ty_sheet.
    TYPES ty_sheets TYPE STANDARD TABLE OF ty_sheet WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_cell,
             row    TYPE i,
             column TYPE i,
             value  TYPE string,
           END OF ty_cell.
    TYPES ty_cells TYPE STANDARD TABLE OF ty_cell WITH DEFAULT KEY.

    DATA mo_zip TYPE REF TO cl_abap_zip.
    DATA mt_sheets TYPE ty_sheets.
    DATA mt_shared_strings TYPE string_table.

    METHODS read_file
      IMPORTING
        iv_name           TYPE string
      RETURNING
        VALUE(rv_content) TYPE xstring.

    METHODS parse
      IMPORTING
        iv_xml             TYPE xstring
      RETURNING
        VALUE(ri_document) TYPE REF TO if_ixml_document.

    METHODS read_sheets
      RAISING
        cx_fdt_excel_core.

    METHODS read_shared_strings.

    METHODS read_cells
      IMPORTING
        iv_path         TYPE string
      RETURNING
        VALUE(rt_cells) TYPE ty_cells.

    METHODS cell_value
      IMPORTING
        ii_cell         TYPE REF TO if_ixml_element
      RETURNING
        VALUE(rv_value) TYPE string.

    CLASS-METHODS text_of
      IMPORTING
        ii_element     TYPE REF TO if_ixml_element
      RETURNING
        VALUE(rv_text) TYPE string.

    CLASS-METHODS column_index
      IMPORTING
        iv_reference    TYPE string
      RETURNING
        VALUE(rv_index) TYPE i.

    CLASS-METHODS row_index
      IMPORTING
        iv_reference    TYPE string
      RETURNING
        VALUE(rv_index) TYPE i.

    CLASS-METHODS column_name
      IMPORTING
        iv_index       TYPE i
      RETURNING
        VALUE(rv_name) TYPE string.

ENDCLASS.

CLASS cl_fdt_xl_spreadsheet IMPLEMENTATION.

  METHOD constructor.
    CREATE OBJECT mo_zip.
    mo_zip->load( xdocument ).
    read_sheets( ).
    read_shared_strings( ).
  ENDMETHOD.

  METHOD if_fdt_doc_spreadsheet~get_worksheet_names.
    DATA ls_sheet LIKE LINE OF mt_sheets.

    CLEAR worksheet_names.
    LOOP AT mt_sheets INTO ls_sheet.
      APPEND ls_sheet-name TO worksheet_names.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_fdt_doc_spreadsheet~get_itab_from_worksheet.
    DATA ls_sheet      LIKE LINE OF mt_sheets.
    DATA lt_cells      TYPE ty_cells.
    DATA ls_cell       LIKE LINE OF lt_cells.
    DATA lv_rows       TYPE i.
    DATA lv_columns    TYPE i.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA lo_structure  TYPE REF TO cl_abap_structdescr.
    DATA lo_table      TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS <lt_table> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <ls_line>  TYPE any.
    FIELD-SYMBOLS <lv_value> TYPE any.

    READ TABLE mt_sheets INTO ls_sheet WITH KEY name = worksheet_name.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    lt_cells = read_cells( ls_sheet-path ).
    LOOP AT lt_cells INTO ls_cell.
      IF ls_cell-row > lv_rows.
        lv_rows = ls_cell-row.
      ENDIF.
      IF ls_cell-column > lv_columns.
        lv_columns = ls_cell-column.
      ENDIF.
    ENDLOOP.

* an empty worksheet still gives a table with one column
    IF lv_columns = 0.
      lv_columns = 1.
    ENDIF.

    DO lv_columns TIMES.
      ls_component-name = column_name( sy-index ).
      ls_component-type = cl_abap_elemdescr=>get_string( ).
      APPEND ls_component TO lt_components.
    ENDDO.
    lo_structure = cl_abap_structdescr=>create( lt_components ).
    lo_table = cl_abap_tabledescr=>create( lo_structure ).
    CREATE DATA itab TYPE HANDLE lo_table.
    ASSIGN itab->* TO <lt_table>.

    DO lv_rows TIMES.
      APPEND INITIAL LINE TO <lt_table>.
    ENDDO.

    LOOP AT lt_cells INTO ls_cell.
      READ TABLE <lt_table> INDEX ls_cell-row ASSIGNING <ls_line>.
      ASSIGN COMPONENT ls_cell-column OF STRUCTURE <ls_line> TO <lv_value>.
      <lv_value> = ls_cell-value.
    ENDLOOP.
  ENDMETHOD.

  METHOD read_file.
    mo_zip->get(
      EXPORTING
        name            = iv_name
      IMPORTING
        content         = rv_content
      EXCEPTIONS
        zip_index_error = 1 ).
    IF sy-subrc <> 0.
      CLEAR rv_content.
    ENDIF.
  ENDMETHOD.

  METHOD parse.
    DATA li_ixml    TYPE REF TO if_ixml.
    DATA li_factory TYPE REF TO if_ixml_stream_factory.
    DATA li_istream TYPE REF TO if_ixml_istream.
    DATA li_parser  TYPE REF TO if_ixml_parser.

    li_ixml = cl_ixml=>create( ).
    ri_document = li_ixml->create_document( ).
    li_factory = li_ixml->create_stream_factory( ).
    li_istream = li_factory->create_istream_xstring( iv_xml ).
    li_parser = li_ixml->create_parser( stream_factory = li_factory
                                        istream        = li_istream
                                        document       = ri_document ).
    li_parser->parse( ).
    li_istream->close( ).
  ENDMETHOD.

  METHOD read_sheets.
* the sheet names are in the workbook, the files in its relationships
    DATA lv_workbook  TYPE xstring.
    DATA li_workbook  TYPE REF TO if_ixml_document.
    DATA li_relations TYPE REF TO if_ixml_node_collection.
    DATA li_sheets    TYPE REF TO if_ixml_node_iterator.
    DATA li_iterator  TYPE REF TO if_ixml_node_iterator.
    DATA li_element   TYPE REF TO if_ixml_element.
    DATA li_relation  TYPE REF TO if_ixml_element.
    DATA lv_id        TYPE string.
    DATA ls_sheet     LIKE LINE OF mt_sheets.

    lv_workbook = read_file( 'xl/workbook.xml' ).
    IF lv_workbook IS INITIAL.
      RAISE EXCEPTION TYPE cx_fdt_excel_core.
    ENDIF.
    li_workbook = parse( lv_workbook ).
    li_relations = parse( read_file( 'xl/_rels/workbook.xml.rels' ) )->get_elements_by_tag_name( 'Relationship' ).

    li_sheets = li_workbook->get_elements_by_tag_name( 'sheet' )->create_iterator( ).
    DO.
      li_element ?= li_sheets->get_next( ).
      IF li_element IS INITIAL.
        EXIT.
      ENDIF.
      CLEAR ls_sheet.
      ls_sheet-name = li_element->get_attribute( 'name' ).
      lv_id = li_element->get_attribute_ns( name = 'id'
                                            uri  = gc_relationships ).
      IF lv_id IS INITIAL.
        lv_id = li_element->get_attribute( 'r:id' ).
      ENDIF.

      li_iterator = li_relations->create_iterator( ).
      DO.
        li_relation ?= li_iterator->get_next( ).
        IF li_relation IS INITIAL.
          EXIT.
        ELSEIF li_relation->get_attribute( 'Id' ) = lv_id.
          ls_sheet-path = li_relation->get_attribute( 'Target' ).
          EXIT.
        ENDIF.
      ENDDO.

* a target is relative to the folder of the workbook, unless it starts with a slash
      IF ls_sheet-path CP '/*'.
        ls_sheet-path = ls_sheet-path+1.
      ELSE.
        ls_sheet-path = 'xl/' && ls_sheet-path.
      ENDIF.
      APPEND ls_sheet TO mt_sheets.
    ENDDO.
  ENDMETHOD.

  METHOD read_shared_strings.
    DATA lv_xml      TYPE xstring.
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_element  TYPE REF TO if_ixml_element.

    lv_xml = read_file( 'xl/sharedStrings.xml' ).
    IF lv_xml IS INITIAL.
      RETURN.
    ENDIF.

    li_iterator = parse( lv_xml )->get_elements_by_tag_name( 'si' )->create_iterator( ).
    DO.
      li_element ?= li_iterator->get_next( ).
      IF li_element IS INITIAL.
        EXIT.
      ENDIF.
      APPEND text_of( li_element ) TO mt_shared_strings.
    ENDDO.
  ENDMETHOD.

  METHOD read_cells.
    DATA lv_xml   TYPE xstring.
    DATA li_rows  TYPE REF TO if_ixml_node_iterator.
    DATA li_cells TYPE REF TO if_ixml_node_iterator.
    DATA li_row   TYPE REF TO if_ixml_element.
    DATA li_cell  TYPE REF TO if_ixml_element.
    DATA lv_ref   TYPE string.
    DATA lv_row   TYPE i.
    DATA ls_cell  LIKE LINE OF rt_cells.

    lv_xml = read_file( iv_path ).
    IF lv_xml IS INITIAL.
      RETURN.
    ENDIF.

    li_rows = parse( lv_xml )->get_elements_by_tag_name( 'row' )->create_iterator( ).
    DO.
      li_row ?= li_rows->get_next( ).
      IF li_row IS INITIAL.
        EXIT.
      ENDIF.

* the references of rows and cells are optional, then they follow the previous one
      lv_ref = li_row->get_attribute( 'r' ).
      IF lv_ref IS INITIAL.
        lv_row = lv_row + 1.
      ELSE.
        lv_row = lv_ref.
      ENDIF.

      CLEAR ls_cell.
      li_cells = li_row->get_elements_by_tag_name( 'c' )->create_iterator( ).
      DO.
        li_cell ?= li_cells->get_next( ).
        IF li_cell IS INITIAL.
          EXIT.
        ENDIF.
        lv_ref = li_cell->get_attribute( 'r' ).
        ls_cell-row = lv_row.
        IF lv_ref IS INITIAL.
          ls_cell-column = ls_cell-column + 1.
        ELSE.
          ls_cell-column = column_index( lv_ref ).
          IF row_index( lv_ref ) > 0.
            ls_cell-row = row_index( lv_ref ).
          ENDIF.
        ENDIF.
        ls_cell-value = cell_value( li_cell ).
        APPEND ls_cell TO rt_cells.
      ENDDO.
    ENDDO.
  ENDMETHOD.

  METHOD cell_value.
    DATA li_value TYPE REF TO if_ixml_element.
    DATA lv_type  TYPE string.
    DATA lv_index TYPE i.

    lv_type = ii_cell->get_attribute( 't' ).
    CASE lv_type.
      WHEN 'inlineStr'.
        li_value = ii_cell->find_from_name( 'is' ).
        IF li_value IS NOT INITIAL.
          rv_value = text_of( li_value ).
        ENDIF.
      WHEN 's'.
        li_value = ii_cell->find_from_name( 'v' ).
        IF li_value IS NOT INITIAL.
* the index of a shared string counts from zero
          lv_index = li_value->get_value( ).
          lv_index = lv_index + 1.
          READ TABLE mt_shared_strings INDEX lv_index INTO rv_value.
        ENDIF.
      WHEN OTHERS.
        li_value = ii_cell->find_from_name( 'v' ).
        IF li_value IS NOT INITIAL.
          rv_value = li_value->get_value( ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD text_of.
* the texts of a string item, plain or in rich text runs, without the phonetic readings
    DATA li_iterator TYPE REF TO if_ixml_node_iterator.
    DATA li_text     TYPE REF TO if_ixml_node.

    li_iterator = ii_element->get_elements_by_tag_name( 't' )->create_iterator( ).
    DO.
      li_text = li_iterator->get_next( ).
      IF li_text IS INITIAL.
        EXIT.
      ELSEIF li_text->get_parent( )->get_name( ) <> 'rPh'.
        rv_text = rv_text && li_text->get_value( ).
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD column_index.
* "AB12" is column 28
    DATA lv_offset   TYPE i.
    DATA lv_position TYPE i.
    DATA lv_char     TYPE c LENGTH 1.

    DO strlen( iv_reference ) TIMES.
      lv_offset = sy-index - 1.
      lv_char = iv_reference+lv_offset(1).
      FIND lv_char IN sy-abcde MATCH OFFSET lv_position.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
      rv_index = rv_index * 26 + lv_position + 1.
    ENDDO.
  ENDMETHOD.

  METHOD row_index.
* "AB12" is row 12
    DATA lv_offset TYPE i.

    DO strlen( iv_reference ) TIMES.
      lv_offset = sy-index - 1.
      IF iv_reference+lv_offset(1) CO '0123456789'.
        rv_index = iv_reference+lv_offset.
        RETURN.
      ENDIF.
    ENDDO.
  ENDMETHOD.

  METHOD column_name.
* column 28 is "AB"
    DATA lv_rest      TYPE i.
    DATA lv_remainder TYPE i.

    lv_rest = iv_index.
    WHILE lv_rest > 0.
      lv_remainder = ( lv_rest - 1 ) MOD 26.
      rv_name = sy-abcde+lv_remainder(1) && rv_name.
      lv_rest = ( lv_rest - 1 - lv_remainder ) / 26.
    ENDWHILE.
  ENDMETHOD.

ENDCLASS.
