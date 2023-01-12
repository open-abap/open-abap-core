CLASS cx_sy_create_object_error DEFINITION PUBLIC INHERITING FROM cx_dynamic_check.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        textid    LIKE textid OPTIONAL
        previous  LIKE previous OPTIONAL
        classname TYPE string OPTIONAL.

    METHODS if_message~get_text REDEFINITION.

    DATA classname TYPE string READ-ONLY.
ENDCLASS.

CLASS cx_sy_create_object_error IMPLEMENTATION.

  METHOD constructor.
    super->constructor(
      textid   = textid
      previous = previous ).
    me->classname = classname.
  ENDMETHOD.

  METHOD if_message~get_text.
    result = 'The object could not be created: The class ??? does not exist.'.
  ENDMETHOD.

ENDCLASS.