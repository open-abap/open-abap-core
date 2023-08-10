CLASS ltcl_dummy DEFINITION FOR TESTING.
ENDCLASS.

CLASS ltcl_dummy IMPLEMENTATION.
ENDCLASS.

******************************

CLASS ltcl_weak_reference DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS basic FOR TESTING.
    METHODS collected FOR TESTING.

    METHODS method RETURNING VALUE(weak) TYPE REF TO cl_abap_weak_reference.

ENDCLASS.

CLASS ltcl_weak_reference IMPLEMENTATION.

  METHOD basic.

    DATA ref  TYPE REF TO ltcl_dummy.
    DATA weak TYPE REF TO cl_abap_weak_reference.

    CREATE OBJECT ref.
    CREATE OBJECT weak EXPORTING oref = ref.

    cl_abap_unit_assert=>assert_equals(
      act = weak->get( )
      exp = ref ).

  ENDMETHOD.

  METHOD method.
    DATA ref TYPE REF TO ltcl_dummy.
    CREATE OBJECT ref.
    CREATE OBJECT weak EXPORTING oref = ref.
  ENDMETHOD.

  METHOD collected.
    DATA weak TYPE REF TO cl_abap_weak_reference.

    weak = method( ).

* https://github.com/orgs/nodejs/discussions/36467
    WRITE '@KERNEL await new Promise(resolve => setTimeout(resolve, 0));;'.
* works only on NodeJS, with --expose-gc
    WRITE '@KERNEL global.gc();'.

    cl_abap_unit_assert=>assert_initial( weak->get( ) ).
  ENDMETHOD.

ENDCLASS.