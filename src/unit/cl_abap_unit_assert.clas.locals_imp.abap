* Note: dont reuse RTTI here, would like to keep it
* possible to run unit tests without RTTI if possible
CLASS lcl_dump DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS to_string
      IMPORTING iv_val TYPE any
      RETURNING VALUE(rv_str) TYPE string.
  PRIVATE SECTION.
    CLASS-METHODS dump_structure
      IMPORTING iv_val TYPE any
      RETURNING VALUE(rv_str) TYPE string.
ENDCLASS.

CLASS lcl_dump IMPLEMENTATION.
  METHOD to_string.
    DATA lv_type TYPE c LENGTH 1.

    DESCRIBE FIELD iv_val TYPE lv_type.
    CASE lv_type.
* avoid using RTTI,
      WHEN 'u' OR 'v'.
        rv_str = dump_structure( iv_val ).
      WHEN OTHERS.
        rv_str = |{ iv_val }|.
    ENDCASE.
  ENDMETHOD.

  METHOD dump_structure.
    DATA lt_components TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA lv_name LIKE LINE OF lt_components.
    FIELD-SYMBOLS <fs> TYPE any.

* avoid using RTTI,
    WRITE '@KERNEL Object.keys(iv_val.get()).forEach((name) => lt_components.append(new abap.types.String().set(name)));'.
    LOOP AT lt_components INTO lv_name.
      IF rv_str <> ''.
        rv_str = rv_str && |, |.
      ENDIF.
      ASSIGN COMPONENT lv_name OF STRUCTURE iv_val TO <fs>.
      ASSERT sy-subrc = 0.
      rv_str = rv_str && lv_name && |: | && |{ <fs> }|.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.