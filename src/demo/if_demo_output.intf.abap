INTERFACE if_demo_output PUBLIC.

  METHODS write
    IMPORTING
      data TYPE any.

  METHODS write_html
    IMPORTING
      html TYPE csequence.

  METHODS begin_section
    IMPORTING
      title TYPE clike OPTIONAL.

  METHODS display.

ENDINTERFACE.