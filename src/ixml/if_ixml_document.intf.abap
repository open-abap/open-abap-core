INTERFACE if_ixml_document PUBLIC.
  METHODS:
    set_encoding
      IMPORTING
        encoding TYPE REF TO object,
    set_standalone
      IMPORTING
        standalone TYPE abap_bool,
    set_namespace_prefix
      IMPORTING
        prefix TYPE string,
    append_child
      IMPORTING
        new_child TYPE REF TO if_ixml_node,
    get_first_child
      RETURNING
        VALUE(child) TYPE REF TO if_ixml_node,
    create_attribute_ns
      IMPORTING
        name TYPE string
        prefix TYPE string
      RETURNING
        VALUE(element) TYPE REF TO if_ixml_element,
    create_element_ns
      IMPORTING
        name TYPE string
        prefix TYPE string
      RETURNING
        VALUE(element) TYPE REF TO if_ixml_element,
    create_element
      IMPORTING
        name TYPE string
      RETURNING
        VALUE(element) TYPE REF TO if_ixml_element,
    create_iterator_filtered
      IMPORTING input TYPE any
      RETURNING VALUE(val) TYPE REF TO if_ixml_node_iterator,
    create_filter_and
      IMPORTING
        filter1 TYPE any
        filter2 TYPE any
      RETURNING
        VALUE(val) TYPE any,
    create_iterator
      RETURNING VALUE(rval) TYPE REF TO if_ixml_node_iterator,
    create_filter_node_type
      IMPORTING typ TYPE string
      RETURNING VALUE(val) TYPE any,
    create_simple_element_ns
      IMPORTING
        name TYPE string
        parent TYPE string
        prefix TYPE string
      RETURNING VALUE(val) TYPE REF TO if_ixml_element,
    create_filter_attribute
      IMPORTING name TYPE string
      RETURNING VALUE(val) TYPE any,
    create_simple_element
      IMPORTING
        name TYPE string
        parent TYPE string
      RETURNING VALUE(val) TYPE REF TO if_ixml_element,
    find_from_name
      IMPORTING
        name TYPE string
        namespace TYPE string
      RETURNING
        VALUE(element) TYPE REF TO if_ixml_element,
    find_from_name_ns
      IMPORTING
        depth TYPE i
        name  TYPE string
      RETURNING
        VALUE(element) TYPE REF TO if_ixml_element,
    find_from_path
      IMPORTING
        path TYPE string
      RETURNING
        VALUE(val) TYPE REF TO if_ixml_element,
    get_elements_by_tag_name_ns
      IMPORTING
        name TYPE string
        namespace TYPE string
      RETURNING VALUE(val) TYPE any,
    get_elements_by_tag_name
      IMPORTING
        depth TYPE i
        name TYPE string
        namespace TYPE string
      RETURNING VALUE(val) TYPE any,
    get_root RETURNING VALUE(node) TYPE REF TO if_ixml_node,
    get_root_element RETURNING VALUE(root) TYPE REF TO if_ixml_element.
ENDINTERFACE.