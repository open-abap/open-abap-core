CLASS ltcl_fugr DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.
    METHODS system_installed_languages FOR TESTING RAISING cx_root.

ENDCLASS.

CLASS ltcl_fugr IMPLEMENTATION.

  METHOD system_installed_languages.

    DATA lv_installed_languages TYPE string.

    CALL FUNCTION 'SYSTEM_INSTALLED_LANGUAGES'
      IMPORTING
        languages       = lv_installed_languages
      EXCEPTIONS
        sapgparam_error = 1
        OTHERS          = 2.

    cl_abap_unit_assert=>assert_subrc( ).

    cl_abap_unit_assert=>assert_not_initial( lv_installed_languages ).

  ENDMETHOD.

ENDCLASS.