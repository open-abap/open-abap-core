CLASS cl_gui_cfw DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS:
      compute_pixel_from_metric
        IMPORTING
          x_or_y TYPE c
          in     TYPE i
        RETURNING
          VALUE(val) TYPE i.
ENDCLASS.

CLASS cl_gui_cfw IMPLEMENTATION.
  METHOD compute_pixel_from_metric.
    val = 1.
  ENDMETHOD.
ENDCLASS.