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
    " the runtime hands the name over on CREATE OBJECT ... TYPE (name); a
    " raise of its own that names none keeps the placeholder
    IF classname IS INITIAL.
      result = 'The object could not be created: The class ??? does not exist.'.
    ELSE.
      result = |The object could not be created: The class { classname } does not exist.|.
    ENDIF.
  ENDMETHOD.

ENDCLASS.