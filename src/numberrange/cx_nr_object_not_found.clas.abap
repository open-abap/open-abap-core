CLASS cx_nr_object_not_found DEFINITION PUBLIC INHERITING FROM cx_number_ranges.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid   LIKE textid OPTIONAL
        previous LIKE previous OPTIONAL.

ENDCLASS.

CLASS cx_nr_object_not_found IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).
  ENDMETHOD.

ENDCLASS.