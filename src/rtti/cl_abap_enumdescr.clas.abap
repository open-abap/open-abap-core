CLASS cl_abap_enumdescr DEFINITION PUBLIC INHERITING FROM cl_abap_elemdescr.
  PUBLIC SECTION.
    TYPES: BEGIN OF member,
             name  TYPE c LENGTH 30,
             value TYPE string,
           END OF member.
    TYPES member_table TYPE STANDARD TABLE OF member WITH KEY name.
    DATA members TYPE member_table READ-ONLY.
ENDCLASS.

CLASS cl_abap_enumdescr IMPLEMENTATION.

ENDCLASS.