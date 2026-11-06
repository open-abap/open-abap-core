INTERFACE if_fdt_doc_spreadsheet PUBLIC.
  TYPES t_worksheet_names TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

  TYPES: BEGIN OF s_column,
          id           TYPE sysuuid_c32,
          name         TYPE string,
          display_name TYPE string,
          is_result    TYPE abap_bool,
          type         TYPE REF TO cl_abap_datadescr,
        END OF s_column.
  TYPES t_column TYPE STANDARD TABLE OF s_column WITH DEFAULT KEY.

  METHODS get_worksheet_names
    EXPORTING
      worksheet_names TYPE t_worksheet_names.

* the rows of the worksheet, one string component per column, named A, B, C...
  METHODS get_itab_from_worksheet
    IMPORTING
      worksheet_name TYPE string
    RETURNING
      VALUE(itab)    TYPE REF TO data.

  CLASS-METHODS create_document
    IMPORTING
      name               TYPE string OPTIONAL
      columns            TYPE t_column OPTIONAL
      itab               TYPE REF TO data
      columns_aux        TYPE t_column OPTIONAL
      itab_aux_col_desc  TYPE REF TO data OPTIONAL
      iv_call_type       TYPE i
      it_dt_map_col      TYPE t_column OPTIONAL
      it_dt_map_col_desc TYPE REF TO data OPTIONAL
      iv_sheet_name      TYPE string OPTIONAL
    RETURNING
      VALUE(xdocument)   TYPE xstring
    RAISING
      cx_fdt_excel_core.

ENDINTERFACE.
