INTERFACE if_fdt_doc_spreadsheet PUBLIC.
  TYPES t_worksheet_names TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

  METHODS get_worksheet_names
    EXPORTING
      worksheet_names TYPE t_worksheet_names.

* the rows of the worksheet, one string component per column, named A, B, C...
  METHODS get_itab_from_worksheet
    IMPORTING
      worksheet_name TYPE string
    RETURNING
      VALUE(itab)    TYPE REF TO data.

ENDINTERFACE.
