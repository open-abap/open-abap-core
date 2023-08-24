CLASS /ui2/cl_json DEFINITION PUBLIC.
  PUBLIC SECTION.
    CONSTANTS: BEGIN OF pretty_mode,
                 low_case   TYPE string VALUE 'low_case',
                 camel_case TYPE string VALUE 'camel_case',
               END OF pretty_mode.

    TYPES tribool TYPE c LENGTH 1.

    CLASS-METHODS deserialize
      IMPORTING
        json             TYPE string OPTIONAL
        jsonx            TYPE xstring OPTIONAL
        pretty_name      TYPE string OPTIONAL
        assoc_arrays     TYPE abap_bool OPTIONAL
        assoc_arrays_opt TYPE abap_bool OPTIONAL
      CHANGING
        data             TYPE data.

    CLASS-METHODS serialize
      IMPORTING
        data          TYPE data
        compress      TYPE abap_bool OPTIONAL
        pretty_name   TYPE string OPTIONAL
        assoc_arrays  TYPE abap_bool OPTIONAL
        ts_as_iso8601 TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(r_json) TYPE string.

    CLASS-METHODS generate
      IMPORTING
        json        TYPE string
        pretty_name TYPE string OPTIONAL
      RETURNING
        VALUE(rr_data) TYPE REF TO data.

  PRIVATE SECTION.
    CLASS-DATA mo_parsed TYPE REF TO lcl_parser.
    CLASS-METHODS _deserialize
      IMPORTING
        VALUE(prefix) TYPE string
        pretty_name   TYPE string OPTIONAL
      CHANGING
        data          TYPE data.
ENDCLASS.

CLASS /ui2/cl_json IMPLEMENTATION.

  METHOD generate.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD serialize.
    DATA lo_type       TYPE REF TO cl_abap_typedescr.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA ref           TYPE REF TO data.
    DATA lv_index      TYPE i.

    FIELD-SYMBOLS <any> TYPE any.
    FIELD-SYMBOLS <tab> TYPE ANY TABLE.

    lo_type = cl_abap_typedescr=>describe_by_data( data ).
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_elem.
*        WRITE '@KERNEL console.dir(lo_type);'.
        CASE lo_type->type_kind.
          WHEN cl_abap_typedescr=>typekind_char.
            IF lo_type->absolute_name = `\TYPE-POOL=ABAP\TYPE=ABAP_BOOL`.
              IF data = abap_true.
                r_json = 'true'.
              ELSE.
                r_json = 'false'.
              ENDIF.
            ELSEIF data IS INITIAL.
              r_json = '""'.
            ELSE.
              r_json = '"' && escape( val = |{ data }| format = cl_abap_format=>e_json_string )  && '"'.
            ENDIF.
          WHEN cl_abap_typedescr=>typekind_string.
            r_json = '"' && escape( val = data format = cl_abap_format=>e_json_string ) && '"'.
          WHEN cl_abap_typedescr=>typekind_int.
            r_json = |{ data }|.
          WHEN cl_abap_typedescr=>typekind_packed.
            IF ts_as_iso8601 = abap_true
                AND ( lo_type->absolute_name = `\TYPE=TIMESTAMP`
                OR lo_type->absolute_name = `\TYPE=TIMESTAMPL` ).
              IF data IS INITIAL.
                r_json = |""|.
              ELSE.
                r_json = |"{ data TIMESTAMP = ISO }.0000000Z"|.
              ENDIF.
            ELSE.
              r_json = |{ data }|.
            ENDIF.
          WHEN cl_abap_typedescr=>typekind_date.
            r_json = |"{ data DATE = ISO }"|.
          WHEN cl_abap_typedescr=>typekind_time.
            r_json = |"{ data TIME = ISO }"|.
          WHEN OTHERS.
            r_json = data.
        ENDCASE.
      WHEN cl_abap_typedescr=>kind_table.
        r_json = '['.
        ASSIGN data TO <tab>.
        LOOP AT <tab> ASSIGNING <any>.
          lv_index = sy-tabix.
          r_json = r_json && serialize(
            data          = <any>
            pretty_name   = pretty_name
            compress      = compress
            ts_as_iso8601 = ts_as_iso8601 ).
          IF lines( data ) <> lv_index.
            r_json = r_json && ','.
          ENDIF.
        ENDLOOP.
        r_json = r_json && ']'.
      WHEN cl_abap_typedescr=>kind_struct.
        lo_struct ?= lo_type.
        lt_components = lo_struct->get_components( ).
        r_json = '{'.
        LOOP AT lt_components INTO ls_component.
          ASSIGN COMPONENT ls_component-name OF STRUCTURE data TO <any>.
          ASSERT sy-subrc = 0.
          IF compress = abap_true AND <any> IS INITIAL.
            CONTINUE.
          ENDIF.
          IF pretty_name = pretty_mode-camel_case.
            r_json = r_json && |"{ to_mixed( to_lower( ls_component-name ) ) }":|.
          ELSEIF pretty_name = pretty_mode-low_case.
            r_json = r_json && |"{ to_lower( ls_component-name ) }":|.
          ELSE.
            r_json = r_json && |"{ ls_component-name }":|.
          ENDIF.
          r_json = r_json && serialize(
            data          = <any>
            pretty_name   = pretty_name
            compress      = compress
            ts_as_iso8601 = ts_as_iso8601 ).
          r_json = r_json && ','.
        ENDLOOP.
        IF r_json CP '*,'.
          r_json = substring( val = r_json off = 0 len = strlen( r_json ) - 1 ).
        ENDIF.
        r_json = r_json && '}'.
      WHEN cl_abap_typedescr=>kind_ref.
        IF data IS INITIAL.
          r_json = 'null'.
          RETURN.
        ENDIF.
        ASSIGN data->* TO <any>.
        r_json = serialize(
          data          = <any>
          pretty_name   = pretty_name
          compress      = compress
          ts_as_iso8601 = ts_as_iso8601 ).
      WHEN OTHERS.
        ASSERT 1 = 'cl_json, unknown kind'.
    ENDCASE.
  ENDMETHOD.

  METHOD deserialize.
    CREATE OBJECT mo_parsed.

    IF jsonx IS NOT INITIAL.
      mo_parsed->parse( cl_abap_codepage=>convert_from( jsonx ) ).
    ELSE.
      mo_parsed->parse( json ).
    ENDIF.

* todo, this should take the "pretty_name" into account
    mo_parsed->adjust_names( ).

    _deserialize(
      EXPORTING
        prefix      = ''
        pretty_name = pretty_name
      CHANGING
        data        = data ).
  ENDMETHOD.

  METHOD _deserialize.
    DATA lo_type       TYPE REF TO cl_abap_typedescr.
    DATA lo_struct     TYPE REF TO cl_abap_structdescr.
    DATA lo_table      TYPE REF TO cl_abap_tabledescr.
    DATA lt_components TYPE cl_abap_structdescr=>component_table.
    DATA ls_component  LIKE LINE OF lt_components.
    DATA lt_members    TYPE string_table.
    DATA ref           TYPE REF TO data.
    DATA lv_name       TYPE string.
    DATA lv_type       TYPE string.
    DATA lv_value      TYPE string.
    DATA lv_member     LIKE LINE OF lt_members.

    FIELD-SYMBOLS <any> TYPE any.

    lo_type = cl_abap_typedescr=>describe_by_data( data ).
    prefix = mo_parsed->find_ignore_case( prefix ).

*    WRITE '@KERNEL console.dir(lo_type.get());'.
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_elem.
*        WRITE '@KERNEL console.dir(lo_type.get().absolute_name);'.
        IF lo_type->absolute_name = '\TYPE-POOL=ABAP\TYPE=ABAP_BOOL'
            OR lo_type->absolute_name = '\TYPE=ABAP_BOOLEAN'
            OR lo_type->absolute_name = '\TYPE=FLAG'.
          data = boolc( mo_parsed->value_string( prefix ) = 'true' ).
        ELSEIF lo_type->absolute_name = `\TYPE=TIMESTAMP`
            OR lo_type->absolute_name = `\TYPE=TIMESTAMPL`.
          lv_value = mo_parsed->value_string( prefix ).
          REPLACE ALL OCCURRENCES OF '-' IN lv_value WITH ''.
          REPLACE ALL OCCURRENCES OF 'T' IN lv_value WITH ''.
          REPLACE ALL OCCURRENCES OF ':' IN lv_value WITH ''.
          REPLACE ALL OCCURRENCES OF 'Z' IN lv_value WITH ''.
          data = lv_value.
        ELSEIF lo_type->type_kind = cl_abap_typedescr=>typekind_date.
          lv_value = mo_parsed->value_string( prefix ).
          REPLACE ALL OCCURRENCES OF '-' IN lv_value WITH ''.
          IF lv_value CO space.
            CLEAR data.
          ELSE.
            data = lv_value.
          ENDIF.
        ELSEIF lo_type->type_kind = cl_abap_typedescr=>typekind_time.
          lv_value = mo_parsed->value_string( prefix ).
          REPLACE ALL OCCURRENCES OF ':' IN lv_value WITH ''.
          IF lv_value CO space.
            CLEAR data.
          ELSE.
            data = lv_value.
          ENDIF.
        ELSE.
          data = mo_parsed->value_string( prefix ).
        ENDIF.
      WHEN cl_abap_typedescr=>kind_table.
        lt_members = mo_parsed->members( prefix && '/' ).
        LOOP AT lt_members INTO lv_member.
*          WRITE '@KERNEL console.dir(lv_member.get());'.
          CREATE DATA ref LIKE LINE OF data.
          ASSIGN ref->* TO <any>.
          _deserialize(
            EXPORTING
              prefix      = prefix && '/' && lv_member
              pretty_name = pretty_name
            CHANGING
              data        = <any> ).
*          WRITE '@KERNEL console.dir(fs_row_);'.
          INSERT <any> INTO TABLE data.
        ENDLOOP.
      WHEN cl_abap_typedescr=>kind_struct.
        lo_struct ?= lo_type.
        lt_components = lo_struct->get_components( ).
        LOOP AT lt_components INTO ls_component.
          ASSIGN COMPONENT ls_component-name OF STRUCTURE data TO <any>.
          ASSERT sy-subrc = 0.
          CASE pretty_name.
            WHEN pretty_mode-camel_case.
              lv_name = to_mixed( to_lower( ls_component-name ) ).
            WHEN OTHERS.
              lv_name = to_lower( ls_component-name ).
          ENDCASE.
          " WRITE '@KERNEL console.dir("structure: " + lv_name.get());'.
          _deserialize(
            EXPORTING
              prefix      = prefix && '/' && lv_name
              pretty_name = pretty_name
            CHANGING
              data        = <any> ).
        ENDLOOP.
      WHEN cl_abap_typedescr=>kind_ref.
        IF data IS INITIAL.
          lt_members = mo_parsed->members( prefix && '/' ).

*          WRITE '@KERNEL console.dir(prefix.get());'.
          IF lines( lt_members ) = 0 AND prefix = ''.
            RETURN.
          ENDIF.

          lv_type = mo_parsed->get_type( prefix && '/' ).
          IF lv_type IS INITIAL.
            lv_type = mo_parsed->get_type( prefix ).
          ENDIF.
*          WRITE '@KERNEL console.dir("type: " + lv_type.get());'.

          IF lines( lt_members ) > 0 AND lv_type = 'object'.
            CLEAR lt_components.
            LOOP AT lt_members INTO lv_member.
*              WRITE '@KERNEL console.dir("component: " + lv_member.get());'.
              CLEAR ls_component.
              ls_component-name = to_upper( lv_member ).
              TRANSLATE ls_component-name USING '-_'.
              ls_component-type = cl_abap_refdescr=>get_ref_to_data( ).
              ASSERT ls_component-name IS NOT INITIAL.
              APPEND ls_component TO lt_components.
            ENDLOOP.
            lo_struct = cl_abap_structdescr=>create( lt_components ).
            CREATE DATA data TYPE HANDLE lo_struct.
          ELSEIF lines( lt_members ) > 0 AND lv_type = 'array'.
            lo_table = cl_abap_tabledescr=>create( cl_abap_refdescr=>get_ref_to_data( ) ).
            CREATE DATA data TYPE HANDLE lo_table.
          ELSE.
            CASE lv_type.
              WHEN 'num'.
                lv_value = mo_parsed->value_string( prefix ).
                IF lv_value CO '-0123456789'.
                  CREATE DATA data TYPE i.
                ELSEIF lv_value CO '-0123456789.'.
                  CREATE DATA data TYPE f.
                ELSE.
                  ASSERT 1 = 'todo'.
                ENDIF.
              WHEN 'bool'.
                CREATE DATA data TYPE HANDLE cl_abap_typedescr=>describe_by_name( 'ABAP_BOOL' ).
              WHEN 'str'.
                CREATE DATA data TYPE HANDLE cl_abap_elemdescr=>get_string( ).
              " WHEN OTHERS.
              "   ASSERT 1 = 'todo'.
            ENDCASE.
          ENDIF.
        ENDIF.
        ASSIGN data->* TO <any>.
        _deserialize(
          EXPORTING
            prefix      = prefix
            pretty_name = pretty_name
          CHANGING
            data        = <any> ).
      WHEN OTHERS.
        ASSERT 1 = 'cl_json, unknown kind'.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.