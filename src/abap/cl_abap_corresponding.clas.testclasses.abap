CLASS ltcl_corresponding DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty1,
             k    TYPE i,
             v    TYPE string,
             same TYPE i,
           END OF ty1.
    TYPES: BEGIN OF ty2,
             key  TYPE i,
             v    TYPE string,
             same TYPE i,
           END OF ty2.
    TYPES ty1_tab TYPE STANDARD TABLE OF ty1 WITH EMPTY KEY.
    TYPES ty2_tab TYPE STANDARD TABLE OF ty2 WITH EMPTY KEY.

    TYPES: BEGIN OF ty_sub1,
             a TYPE i,
             b TYPE i,
           END OF ty_sub1.
    TYPES: BEGIN OF ty_sub2,
             x TYPE i,
             b TYPE i,
           END OF ty_sub2.
    TYPES: BEGIN OF ty_deep1,
             id  TYPE i,
             sub TYPE ty_sub1,
             tab TYPE STANDARD TABLE OF ty_sub1 WITH EMPTY KEY,
           END OF ty_deep1.
    TYPES: BEGIN OF ty_deep2,
             id   TYPE i,
             sub2 TYPE ty_sub2,
             tab  TYPE STANDARD TABLE OF ty_sub2 WITH EMPTY KEY,
           END OF ty_deep2.

    METHODS structure FOR TESTING RAISING cx_static_check.
    METHODS table FOR TESTING RAISING cx_static_check.
    METHODS no_mapping FOR TESTING RAISING cx_static_check.
    METHODS keeps_unassigned FOR TESTING RAISING cx_static_check.
    METHODS table_initialized FOR TESTING RAISING cx_static_check.
    METHODS lower_case_names FOR TESTING RAISING cx_static_check.
    METHODS except_component FOR TESTING RAISING cx_static_check.
    METHODS except_all FOR TESTING RAISING cx_static_check.
    METHODS sub_structure FOR TESTING RAISING cx_static_check.
    METHODS nested_table FOR TESTING RAISING cx_static_check.
    METHODS sorted_destination FOR TESTING RAISING cx_static_check.
    METHODS discarding_duplicates FOR TESTING RAISING cx_static_check.
    METHODS duplicates_raise FOR TESTING RAISING cx_static_check.
    METHODS error_unknown_component FOR TESTING RAISING cx_static_check.
    METHODS error_struct_and_table FOR TESTING RAISING cx_static_check.
    METHODS error_bad_level FOR TESTING RAISING cx_static_check.
    METHODS except_sub_structure FOR TESTING RAISING cx_static_check.
    METHODS except_source_only FOR TESTING RAISING cx_static_check.
    METHODS error_except_unknown FOR TESTING RAISING cx_static_check.
    METHODS error_except_no_srcname FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS ltcl_corresponding IMPLEMENTATION.

  METHOD structure.
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    s1 = VALUE #( k = 3 v = `x` same = 9 ).
    DATA(mapper) = cl_abap_corresponding=>create(
      source      = s1
      destination = s2
      mapping     = VALUE cl_abap_corresponding=>mapping_table(
        ( level = 0 kind = cl_abap_corresponding=>mapping_component srcname = 'K' dstname = 'KEY' ) ) ).
    mapper->execute( EXPORTING source = s1 CHANGING destination = s2 ).

    cl_abap_unit_assert=>assert_equals( act = s2-key
                                        exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = s2-v
                                        exp = `x` ).
    cl_abap_unit_assert=>assert_equals( act = s2-same
                                        exp = 9 ).
  ENDMETHOD.

  METHOD table.
    DATA t1 TYPE ty1_tab.
    DATA t2 TYPE ty2_tab.

    t1 = VALUE #( ( k = 1 v = `a` same = 5 ) ( k = 2 v = `b` same = 6 ) ).
    DATA(mapper) = cl_abap_corresponding=>create(
      source      = t1
      destination = t2
      mapping     = VALUE cl_abap_corresponding=>mapping_table(
        ( level = 0 kind = cl_abap_corresponding=>mapping_component srcname = 'K' dstname = 'KEY' ) ) ).
    mapper->execute( EXPORTING source = t1 CHANGING destination = t2 ).

    cl_abap_unit_assert=>assert_equals( act = t2
                                        exp = VALUE ty2_tab( ( key = 1 v = `a` same = 5 ) ( key = 2 v = `b` same = 6 ) ) ).
  ENDMETHOD.

  METHOD no_mapping.
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    s1 = VALUE #( k = 3 v = `x` same = 9 ).
    cl_abap_corresponding=>create(
      source      = s1
      destination = s2
      mapping     = VALUE #( ) )->execute( EXPORTING source = s1 CHANGING destination = s2 ).

    cl_abap_unit_assert=>assert_equals( act = s2
                                        exp = VALUE ty2( key = 0 v = `x` same = 9 ) ).
  ENDMETHOD.

  METHOD keeps_unassigned.
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    s1 = VALUE #( k = 3 v = `x` same = 9 ).
    s2-key = 7.
    cl_abap_corresponding=>create(
      source      = s1
      destination = s2 )->execute( EXPORTING source = s1 CHANGING destination = s2 ).

    cl_abap_unit_assert=>assert_equals( act = s2
                                        exp = VALUE ty2( key = 7 v = `x` same = 9 ) ).
  ENDMETHOD.

  METHOD table_initialized.
    DATA t1 TYPE ty1_tab.
    DATA t2 TYPE ty2_tab.

    t1 = VALUE #( ( k = 1 v = `a` same = 5 ) ).
    t2 = VALUE #( ( key = 9 ) ( key = 8 ) ).
    cl_abap_corresponding=>create(
      source      = t1
      destination = t2 )->execute( EXPORTING source = t1 CHANGING destination = t2 ).

    cl_abap_unit_assert=>assert_equals( act = t2
                                        exp = VALUE ty2_tab( ( key = 0 v = `a` same = 5 ) ) ).
  ENDMETHOD.

  METHOD lower_case_names.
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    s1 = VALUE #( k = 3 ).
    cl_abap_corresponding=>create(
      source      = s1
      destination = s2
      mapping     = VALUE #(
        ( level = 0 kind = cl_abap_corresponding=>mapping_component srcname = 'k' dstname = 'key' ) )
      )->execute( EXPORTING source = s1 CHANGING destination = s2 ).

    cl_abap_unit_assert=>assert_equals( act = s2-key
                                        exp = 3 ).
  ENDMETHOD.

  METHOD except_component.
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    s1 = VALUE #( k = 3 v = `x` same = 9 ).
    cl_abap_corresponding=>create(
      source      = s1
      destination = s2
      mapping     = VALUE #(
        ( level = 0 kind = cl_abap_corresponding=>mapping_except_component srcname = 'SAME' ) )
      )->execute( EXPORTING source = s1 CHANGING destination = s2 ).

    cl_abap_unit_assert=>assert_equals( act = s2
                                        exp = VALUE ty2( key = 0 v = `x` same = 0 ) ).
  ENDMETHOD.

  METHOD except_all.
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    s1 = VALUE #( k = 3 v = `x` same = 9 ).
    s2-same = 4.
    cl_abap_corresponding=>create(
      source      = s1
      destination = s2
      mapping     = VALUE #(
        ( level = 0 kind = cl_abap_corresponding=>mapping_component srcname = 'K' dstname = 'KEY' )
        ( level = 0 kind = cl_abap_corresponding=>mapping_except_all ) )
      )->execute( EXPORTING source = s1 CHANGING destination = s2 ).

    cl_abap_unit_assert=>assert_equals( act = s2
                                        exp = VALUE ty2( key = 3 v = `` same = 4 ) ).
  ENDMETHOD.

  METHOD sub_structure.
    DATA d1 TYPE ty_deep1.
    DATA d2 TYPE ty_deep2.

    d1 = VALUE #( id = 1 sub = VALUE #( a = 2 b = 3 ) ).
    cl_abap_corresponding=>create(
      source      = d1
      destination = d2
      mapping     = VALUE #(
        ( level = 0 kind = cl_abap_corresponding=>mapping_component srcname = 'SUB' dstname = 'SUB2' )
        ( level = 1 kind = cl_abap_corresponding=>mapping_component srcname = 'A' dstname = 'X' ) )
      )->execute( EXPORTING source = d1 CHANGING destination = d2 ).

    cl_abap_unit_assert=>assert_equals( act = d2-id
                                        exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = d2-sub2-x
                                        exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = d2-sub2-b
                                        exp = 3 ).
  ENDMETHOD.

  METHOD nested_table.
    DATA d1 TYPE ty_deep1.
    DATA d2 TYPE ty_deep2.

    d1 = VALUE #( id = 1 tab = VALUE #( ( a = 1 b = 2 ) ( a = 3 b = 4 ) ) ).
    cl_abap_corresponding=>create(
      source      = d1
      destination = d2
      mapping     = VALUE #(
        ( level = 0 kind = cl_abap_corresponding=>mapping_component srcname = 'TAB' dstname = 'TAB' )
        ( level = 1 kind = cl_abap_corresponding=>mapping_component srcname = 'A' dstname = 'X' ) )
      )->execute( EXPORTING source = d1 CHANGING destination = d2 ).

    cl_abap_unit_assert=>assert_equals( act = lines( d2-tab )
                                        exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = d2-tab[ 2 ]-x
                                        exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = d2-tab[ 2 ]-b
                                        exp = 4 ).
  ENDMETHOD.

  METHOD sorted_destination.
    DATA t1 TYPE ty1_tab.
    DATA t2 TYPE SORTED TABLE OF ty2 WITH NON-UNIQUE KEY key.

    t1 = VALUE #( ( k = 2 v = `b` ) ( k = 1 v = `a` ) ).
    cl_abap_corresponding=>create(
      source      = t1
      destination = t2
      mapping     = VALUE #(
        ( level = 0 kind = cl_abap_corresponding=>mapping_component srcname = 'K' dstname = 'KEY' ) )
      )->execute( EXPORTING source = t1 CHANGING destination = t2 ).

    cl_abap_unit_assert=>assert_equals( act = lines( t2 )
                                        exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = t2[ 1 ]-v
                                        exp = `a` ).
  ENDMETHOD.

  METHOD discarding_duplicates.
    DATA t1 TYPE ty1_tab.
    DATA t2 TYPE SORTED TABLE OF ty2 WITH UNIQUE KEY v.

    t1 = VALUE #( ( k = 1 v = `a` ) ( k = 2 v = `a` ) ).
    cl_abap_corresponding=>create(
      source                = t1
      destination           = t2
      discarding_duplicates = abap_true )->execute( EXPORTING source = t1 CHANGING destination = t2 ).
    cl_abap_unit_assert=>assert_equals( act = lines( t2 )
                                        exp = 1 ).

    CLEAR t2.
    cl_abap_corresponding=>create(
      source      = t1
      destination = t2
      mapping     = VALUE #( ( kind = cl_abap_corresponding=>mapping_discarding_duplicates ) )
      )->execute( EXPORTING source = t1 CHANGING destination = t2 ).
    cl_abap_unit_assert=>assert_equals( act = lines( t2 )
                                        exp = 1 ).
  ENDMETHOD.

  METHOD duplicates_raise.
    DATA t1 TYPE ty1_tab.
    DATA t2 TYPE SORTED TABLE OF ty2 WITH UNIQUE KEY v.

    t1 = VALUE #( ( k = 1 v = `a` ) ( k = 2 v = `a` ) ).
    TRY.
        cl_abap_corresponding=>create(
          source      = t1
          destination = t2 )->execute( EXPORTING source = t1 CHANGING destination = t2 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_sy_itab_duplicate_key.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD error_unknown_component.
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    TRY.
        cl_abap_corresponding=>create(
          source      = s1
          destination = s2
          mapping     = VALUE #(
            ( level = 0 kind = cl_abap_corresponding=>mapping_component srcname = 'NOPE' dstname = 'KEY' ) ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_corr_dyn_error.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD error_struct_and_table.
    DATA s1 TYPE ty1.
    DATA t2 TYPE ty2_tab.

    TRY.
        cl_abap_corresponding=>create(
          source      = s1
          destination = t2 ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_corr_dyn_error.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD error_bad_level.
    DATA d1 TYPE ty_deep1.
    DATA d2 TYPE ty_deep2.

    TRY.
        cl_abap_corresponding=>create(
          source      = d1
          destination = d2
          mapping     = VALUE #(
            ( level = 1 kind = cl_abap_corresponding=>mapping_component srcname = 'A' dstname = 'X' ) ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_corr_dyn_error.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD except_sub_structure.
    DATA d1 TYPE ty_deep1.
    DATA d2 TYPE ty_deep2.

    d1 = VALUE #( id = 1 sub = VALUE #( a = 2 b = 3 ) ).
    d2-sub2-b = 7.
    cl_abap_corresponding=>create(
      source      = d1
      destination = d2
      mapping     = VALUE #(
        ( level = 0 kind = cl_abap_corresponding=>mapping_component srcname = 'SUB' dstname = 'SUB2' )
        ( level = 1 kind = cl_abap_corresponding=>mapping_component srcname = 'A' dstname = 'X' )
        ( level = 1 kind = cl_abap_corresponding=>mapping_except_component srcname = 'B' ) )
      )->execute( EXPORTING source = d1 CHANGING destination = d2 ).

    cl_abap_unit_assert=>assert_equals( act = d2-id
                                        exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = d2-sub2-x
                                        exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = d2-sub2-b
                                        exp = 7 ).
  ENDMETHOD.

  METHOD except_source_only.
* K only exists in the source, excluding it changes nothing
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    s1 = VALUE #( k = 3 v = `x` same = 9 ).
    cl_abap_corresponding=>create(
      source      = s1
      destination = s2
      mapping     = VALUE #(
        ( level = 0 kind = cl_abap_corresponding=>mapping_except_component srcname = 'K' ) )
      )->execute( EXPORTING source = s1 CHANGING destination = s2 ).

    cl_abap_unit_assert=>assert_equals( act = s2
                                        exp = VALUE ty2( key = 0 v = `x` same = 9 ) ).
  ENDMETHOD.

  METHOD error_except_unknown.
* KEY only exists in the destination, the excluded component is a source component
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    TRY.
        cl_abap_corresponding=>create(
          source      = s1
          destination = s2
          mapping     = VALUE #(
            ( level = 0 kind = cl_abap_corresponding=>mapping_except_component srcname = 'KEY' ) ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_corr_dyn_error.
        RETURN.
    ENDTRY.
  ENDMETHOD.

  METHOD error_except_no_srcname.
    DATA s1 TYPE ty1.
    DATA s2 TYPE ty2.

    TRY.
        cl_abap_corresponding=>create(
          source      = s1
          destination = s2
          mapping     = VALUE #(
            ( level = 0 kind = cl_abap_corresponding=>mapping_except_component dstname = 'SAME' ) ) ).
        cl_abap_unit_assert=>fail( ).
      CATCH cx_corr_dyn_error.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.