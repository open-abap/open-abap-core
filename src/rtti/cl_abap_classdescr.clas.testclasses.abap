CLASS ltcl_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test01 FOR TESTING.

ENDCLASS.

CLASS ltcl_test IMPLEMENTATION.

  METHOD test01.

    DATA ref TYPE REF TO cl_abap_codepage.
    DATA type TYPE REF TO cl_abap_classdescr.
    CREATE OBJECT ref.
    type ?= cl_abap_typedescr=>describe_by_object_ref( ref ).

  ENDMETHOD.

ENDCLASS.