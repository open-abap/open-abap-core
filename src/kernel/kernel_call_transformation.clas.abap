CLASS kernel_call_transformation DEFINITION PUBLIC.
* handling of ABAP statement CALL TRANSFORMATION  
  PUBLIC SECTION.
    CLASS-METHODS call IMPORTING input TYPE any.
  PRIVATE SECTION.
    CLASS-DATA mi_doc TYPE REF TO if_ixml_document.
    CLASS-DATA mi_writer TYPE REF TO if_sxml_writer.

    CLASS-METHODS parse_xml IMPORTING iv_xml TYPE string.
    CLASS-METHODS parse_json IMPORTING iv_json TYPE string.
    CLASS-METHODS traverse IMPORTING
      iv_name TYPE string 
      iv_ref  TYPE REF TO data.
    CLASS-METHODS traverse_write
      IMPORTING iv_ref TYPE REF TO data.
    CLASS-METHODS traverse_write_type
      IMPORTING iv_ref TYPE REF TO data 
      RETURNING VALUE(rv_type) TYPE string.

    CLASS-METHODS build_ixml_from_data
      IMPORTING 
        iv_ref  TYPE REF TO data 
        iv_name TYPE string.
    CLASS-METHODS build_ixml_from_data_traverse
      IMPORTING 
        iv_ref    TYPE REF TO data 
        ii_parent TYPE REF TO if_ixml_element.        

ENDCLASS.

CLASS kernel_call_transformation IMPLEMENTATION.

  METHOD call.
* first convert SOURCE to internal format stored in "MI_DOC"?
* then output to RESULT

    DATA lv_name   TYPE string.
    DATA lv_source TYPE string.
    DATA result    TYPE REF TO data.
    DATA lt_rtab   TYPE abap_trans_resbind_tab.
    DATA ls_rtab   LIKE LINE OF lt_rtab.

    CLEAR mi_doc.

*    WRITE '@KERNEL console.dir(INPUT);'.

* only the ID transformation is implemented
    WRITE '@KERNEL lv_name.set(INPUT.name);'.
    ASSERT lv_name = 'id'.

* Handle input SOURCE    
    WRITE '@KERNEL if (INPUT.sourceXML?.constructor.name === "ABAPObject") this.mi_doc.set(INPUT.sourceXML);'.
    WRITE '@KERNEL if (INPUT.sourceXML?.constructor.name === "String") lv_source.set(INPUT.sourceXML);'.
    IF lv_source IS NOT INITIAL.
      IF lv_source(1) = '<'.
        parse_xml( lv_source ).
      ELSEIF lv_source(1) = '{' OR lv_source(1) = '['.
        parse_json( lv_source ).
      ELSE.
        RAISE EXCEPTION TYPE cx_xslt_format_error.
      ENDIF.
    ENDIF.
    " WRITE '@KERNEL if (typeof INPUT.source === "object") {'.
    " WRITE '@KERNEL   for (const name in INPUT.source) {'.
    " WRITE '@KERNEL    lv_name.set(name);'.
    " WRITE '@KERNEL    if (INPUT.source[name].constructor.name === "FieldSymbol") {'.
    " WRITE '@KERNEL      result.assign(INPUT.source[name].getPointer());'.
    " WRITE '@KERNEL    } else {'.
    " WRITE '@KERNEL      result.assign(INPUT.source[name]);'.
    " WRITE '@KERNEL    }'.
    " build_ixml_from_data( iv_ref  = result
    "                       iv_name = lv_name ).
    " WRITE '@KERNEL   }'.
    " WRITE '@KERNEL }'.

    
    WRITE '@KERNEL if (typeof INPUT.source === "object" && INPUT.resultXML?.constructor.name === "ABAPObject") {'.
    WRITE '@KERNEL   this.mi_writer.set(INPUT.resultXML);'.
    WRITE '@KERNEL }'.
*    WRITE '@KERNEL console.dir(INPUT);'.
    IF mi_writer IS NOT INITIAL.
* input is object and write to sxml output      
      mi_writer->open_element( name = 'object' ).
      WRITE '@KERNEL for (const name in INPUT.source) {'.
      WRITE '@KERNEL   lv_name.set(name);'.
      WRITE '@KERNEL   if (INPUT.source[name].constructor.name === "FieldSymbol") {'.
      WRITE '@KERNEL     result.assign(INPUT.source[name].getPointer());'.
      WRITE '@KERNEL   } else {'.
      WRITE '@KERNEL     result.assign(INPUT.source[name]);'.
      WRITE '@KERNEL   }'.
      mi_writer->open_element( name = 'str' ).
      mi_writer->write_attribute( name = 'name' value = to_upper( lv_name ) ).
      traverse_write( result ).
      mi_writer->close_element( ).
      WRITE '@KERNEL }'.
      mi_writer->close_element( ).
      RETURN.
    ENDIF.

    IF lv_source IS INITIAL AND mi_doc IS INITIAL.
      RAISE EXCEPTION TYPE cx_xslt_runtime_error.
    ENDIF.

    WRITE '@KERNEL if (INPUT.result.constructor.name === "Table") {'.
* INPUT.result is an ABAP internal table
    WRITE '@KERNEL lt_rtab = INPUT.result;'.
    LOOP AT lt_rtab INTO ls_rtab.
      traverse(
        iv_name = ls_rtab-name
        iv_ref  = ls_rtab-value ).
    ENDLOOP.

    WRITE '@KERNEL } else {'.
* INPUT.result is a javascript structure 
    WRITE '@KERNEL for (const name in INPUT.result) {'.
    WRITE '@KERNEL lv_name.set(name);'.
    WRITE '@KERNEL result.assign(INPUT.result[name]);'.
    traverse(
      iv_name = lv_name
      iv_ref  = result ).
    WRITE '@KERNEL }'.
    WRITE '@KERNEL }'.

*    WRITE '@KERNEL console.dir(INPUT.result.data);'.

  ENDMETHOD.

  METHOD build_ixml_from_data.

    DATA li_element TYPE REF TO if_ixml_element.

    IF mi_doc IS INITIAL.
      mi_doc = cl_ixml=>create( )->create_document( ).
    ENDIF.

    li_element = mi_doc->create_element( iv_name ).
    mi_doc->append_child( li_element ).

    build_ixml_from_data_traverse(
      iv_ref    = iv_ref
      ii_parent = li_element ).

  ENDMETHOD.

  METHOD build_ixml_from_data_traverse.
    WRITE '@KERNEL console.dir("sdfsd");'.
  ENDMETHOD.

  METHOD traverse_write_type.
    DATA lo_type TYPE REF TO cl_abap_typedescr.
    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).
    CASE lo_type->type_kind.
      WHEN cl_abap_typedescr=>typekind_int
          OR cl_abap_typedescr=>typekind_int1 
          OR cl_abap_typedescr=>typekind_int2
          OR cl_abap_typedescr=>typekind_int8
          OR cl_abap_typedescr=>typekind_decfloat
          OR cl_abap_typedescr=>typekind_decfloat16
          OR cl_abap_typedescr=>typekind_decfloat34.
        rv_type = 'num'.
      WHEN OTHERS.
        rv_type = 'str'.
    ENDCASE.
  ENDMETHOD.
  
  METHOD traverse_write.
* TODO: refactor this method

    DATA lo_type TYPE REF TO cl_abap_typedescr.
    DATA lo_struc TYPE REF TO cl_abap_structdescr.
    DATA lt_comps TYPE cl_abap_structdescr=>component_table.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_sub TYPE REF TO if_ixml_element.
    DATA ls_compo LIKE LINE OF lt_comps.
    DATA lv_ref TYPE REF TO data.
    FIELD-SYMBOLS <any> TYPE any.
    FIELD-SYMBOLS <table> TYPE ANY TABLE.
    FIELD-SYMBOLS <field> TYPE any.

*     WRITE '@KERNEL console.dir(iv_ref.getPointer());'.
    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).
*    WRITE '@KERNEL console.dir(lo_type.get().kind.get());'.
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        mi_writer->open_element( name = 'object' ).

        lo_struc ?= lo_type.
        lt_comps = lo_struc->get_components( ).
        ASSIGN iv_ref->* TO <any>.
        LOOP AT lt_comps INTO ls_compo.
          ASSIGN COMPONENT ls_compo-name OF STRUCTURE <any> TO <field>.
          GET REFERENCE OF <field> INTO lv_ref.
          mi_writer->open_element( name = traverse_write_type( lv_ref ) ).
          mi_writer->write_attribute( name = 'name' value = to_upper( ls_compo-name ) ).
          traverse_write( lv_ref ).
          mi_writer->close_element( ).
        ENDLOOP.

        mi_writer->close_element( ).
      WHEN cl_abap_typedescr=>kind_elem.
        mi_writer->write_value( iv_ref->* ).
      WHEN cl_abap_typedescr=>kind_table.
        mi_writer->open_element( name = 'array' ).

        ASSIGN iv_ref->* TO <table>.
        LOOP AT <table> ASSIGNING <any>.
          GET REFERENCE OF <any> INTO lv_ref.
          IF cl_abap_typedescr=>describe_by_data( lv_ref->* )->kind = cl_abap_typedescr=>kind_elem.
            mi_writer->open_element( name = traverse_write_type( lv_ref ) ).
          ENDIF.
          traverse_write( lv_ref ).
          IF cl_abap_typedescr=>describe_by_data( lv_ref->* )->kind = cl_abap_typedescr=>kind_elem.
            mi_writer->close_element( ).
          ENDIF.
        ENDLOOP.

        mi_writer->close_element( ).
      WHEN OTHERS.
        ASSERT 1 = 'todo_traverse_write'.
    ENDCASE.

  ENDMETHOD.

  METHOD traverse.
* traversal for reading mi_doc to output
* todo, rewrite this method

    DATA lo_type TYPE REF TO cl_abap_typedescr.
    DATA lo_struc TYPE REF TO cl_abap_structdescr.
    DATA lo_table TYPE REF TO cl_abap_tabledescr.
    DATA lt_comps TYPE cl_abap_structdescr=>component_table.
    DATA li_element TYPE REF TO if_ixml_element.
    DATA li_sub TYPE REF TO if_ixml_element.
    DATA li_node TYPE REF TO if_ixml_node.
    DATA ls_compo LIKE LINE OF lt_comps.
    DATA lv_length TYPE i.
    DATA lv_rowref TYPE REF TO data.
    FIELD-SYMBOLS <structure> TYPE any.
    FIELD-SYMBOLS <field> TYPE any.
    FIELD-SYMBOLS <tab> TYPE ANY TABLE.

*    WRITE '@KERNEL console.dir(iv_ref.getPointer());'.
    lo_type = cl_abap_typedescr=>describe_by_data( iv_ref->* ).
    CASE lo_type->kind.
      WHEN cl_abap_typedescr=>kind_struct.
        lo_struc ?= lo_type.

        li_element = mi_doc->find_from_name_ns(
          depth = 0
          name  = to_upper( iv_name ) ).
*        WRITE '@KERNEL console.dir(li_element);'.
        IF li_element IS INITIAL.
          RETURN.
        ENDIF.

        lt_comps = lo_struc->get_components( ).
        ASSIGN iv_ref->* TO <structure>.
        LOOP AT lt_comps INTO ls_compo.
          li_sub = li_element->find_from_name_ns(
            name      = ls_compo-name 
            namespace = '' 
            depth     = 0 ).
*          WRITE '@KERNEL console.dir(li_sub);'.
          IF li_sub IS INITIAL.
            CONTINUE.
          ENDIF.

          ASSIGN COMPONENT ls_compo-name OF STRUCTURE <structure> TO <field>.
          <field> = li_sub->get_value( ).
        ENDLOOP.
      WHEN cl_abap_typedescr=>kind_table.
        lo_table ?= lo_type.

        li_element = mi_doc->find_from_name_ns(
          depth = 0
          name  = to_upper( iv_name ) ).
*        WRITE '@KERNEL console.dir(li_element);'.
        IF li_element IS INITIAL.
          RETURN.
        ENDIF.

        ASSIGN iv_ref->* TO <tab>.
        CREATE DATA lv_rowref LIKE LINE OF <tab>.
        ASSIGN lv_rowref->* TO <structure>.

        lv_length = li_element->get_children( )->get_length( ).
        DO lv_length TIMES.
          li_node = li_element->get_children( )->get_item( sy-index ).
*          WRITE '@KERNEL console.dir(li_node.get());'.
* todo
          INSERT <structure> INTO TABLE <tab>.
        ENDDO.
        
      WHEN OTHERS.
*        WRITE '@KERNEL console.dir(lo_type.get().kind.get());'.
    ENDCASE.
*    WRITE '@KERNEL console.dir(iv_ref.getPointer());'.
    
  ENDMETHOD.

  METHOD parse_xml.

    DATA li_factory TYPE REF TO if_ixml_stream_factory.
    DATA li_istream TYPE REF TO if_ixml_istream.
    DATA li_parser  TYPE REF TO if_ixml_parser.
    DATA li_ixml    TYPE REF TO if_ixml.
    DATA lv_subrc   TYPE i.
  
    li_ixml = cl_ixml=>create( ).
    mi_doc  = li_ixml->create_document( ).
 
    li_factory = li_ixml->create_stream_factory( ).
    li_istream = li_factory->create_istream_string( iv_xml ).
    li_parser = li_ixml->create_parser( stream_factory = li_factory
                                        istream        = li_istream
                                        document       = mi_doc ).
    li_parser->add_strip_space_element( ).
    lv_subrc = li_parser->parse( ).
    li_istream->close( ).

    ASSERT lv_subrc = 0.

  ENDMETHOD.

  METHOD parse_json.

    DATA li_reader TYPE REF TO if_sxml_reader.
    DATA li_node TYPE REF TO if_sxml_node.
    DATA li_close TYPE REF TO if_sxml_close_element.
    DATA li_open TYPE REF TO if_sxml_open_element.
    DATA li_value TYPE REF TO if_sxml_value_node.
    DATA lt_attributes TYPE if_sxml_attribute=>attributes.
    DATA li_attribute TYPE REF TO if_sxml_attribute.
    DATA li_current TYPE REF TO if_ixml_node.
    DATA lv_name TYPE string.
    DATA li_new TYPE REF TO if_ixml_node.
    DATA li_element TYPE REF TO if_ixml_element.

    li_reader = cl_sxml_string_reader=>create( cl_abap_codepage=>convert_to( iv_json ) ).

    mi_doc = cl_ixml=>create( )->create_document( ).
    li_current = mi_doc->get_root( ).

    DO.
      li_node = li_reader->read_next_node( ).
      IF li_node IS INITIAL.
        EXIT.
      ENDIF.

      CASE li_node->type.
        WHEN if_sxml_node=>co_nt_element_open.
          li_open ?= li_node.
*          WRITE: / 'open: ', li_open->qname-name.

          lt_attributes = li_open->get_attributes( ).
          LOOP AT lt_attributes INTO li_attribute.
*            WRITE / li_attribute->get_value( ).
            lv_name = li_attribute->get_value( ).
          ENDLOOP.
          IF lv_name IS NOT INITIAL.
            li_element = mi_doc->create_element_ns( lv_name ).
            li_new ?= li_element.
            li_current->append_child( li_new ).
            li_current = li_new.
          ENDIF.
        WHEN if_sxml_node=>co_nt_element_close.
          li_close ?= li_node.
*          WRITE: / 'close: ', li_close->qname-name.
          li_current = li_current->get_parent( ).
        WHEN if_sxml_node=>co_nt_value.
          li_value ?= li_node.
*          WRITE / li_value->get_value( ).
          li_current->set_value( li_value->get_value( ) ).
      ENDCASE.
    ENDDO.

  ENDMETHOD.

ENDCLASS.