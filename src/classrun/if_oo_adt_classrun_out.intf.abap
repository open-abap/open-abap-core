INTERFACE if_oo_adt_classrun_out PUBLIC.

  METHODS write
    IMPORTING
      data          TYPE any
      name          TYPE string OPTIONAL
    RETURNING
      VALUE(output) TYPE REF TO if_oo_adt_classrun_out.

  METHODS get
    IMPORTING
      data          TYPE any OPTIONAL
      name          TYPE string OPTIONAL PREFERRED PARAMETER data
    RETURNING
      VALUE(output) TYPE string.

ENDINTERFACE.