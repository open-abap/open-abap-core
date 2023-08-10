CLASS ltcl_dummy DEFINITION FOR TESTING.
ENDCLASS.

CLASS ltcl_dummy IMPLEMENTATION.
ENDCLASS.

******************************

CLASS ltcl_weak_reference DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS test FOR TESTING.

ENDCLASS.

CLASS ltcl_weak_reference IMPLEMENTATION.

  METHOD test.

    DATA ref  TYPE REF TO ltcl_dummy.
    DATA weak TYPE REF TO cl_abap_weak_reference.

    CREATE OBJECT ref.
    CREATE OBJECT weak EXPORTING oref = ref.

    cl_abap_unit_assert=>assert_equals(
      act = weak->get( )
      exp = ref ).

  ENDMETHOD.

ENDCLASS.