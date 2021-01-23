INTERFACE if_ixml_element PUBLIC.
  METHODS:
    remove_attribute_ns
      IMPORTING foo TYPE string,
    get_attributes
      RETURNING VALUE(attr) TYPE REF TO if_ixml_named_node_map,
    get_next
      RETURNING VALUE(next) TYPE REF TO if_ixml_element,
    get_name
      RETURNING VALUE(name) TYPE string,
    append_child
      IMPORTING
        new_child TYPE REF TO if_ixml_element
      RETURNING
        VALUE(rc) TYPE i,
    clone
      RETURNING VALUE(val) TYPE REF TO if_ixml_node,
    create_filter_node_type
      IMPORTING name TYPE string
      RETURNING VALUE(val) TYPE REF TO any,
    create_iterator
      RETURNING VALUE(val) TYPE REF TO if_ixml_node_iterator,
    find_from_name_ns
      IMPORTING
        name TYPE string
        namespace TYPE string
        depth TYPE i
      RETURNING VALUE(val) TYPE REF TO if_ixml_element,
    find_from_name
      IMPORTING
        name TYPE string
        namespace TYPE string
        depth TYPE i
      RETURNING VALUE(val) TYPE REF TO if_ixml_element,
    get_attribute_node
      IMPORTING name TYPE string
      RETURNING VALUE(val) TYPE REF TO if_ixml_attribute,
    get_attribute_ns
      IMPORTING
        name TYPE string
      RETURNING VALUE(val) TYPE string,
    get_attribute
      IMPORTING
        name TYPE string
        namespace TYPE string OPTIONAL
      RETURNING VALUE(val) TYPE string,
    get_children
      RETURNING VALUE(val) TYPE REF TO if_ixml_node_list,
    get_elements_by_tag_name
      IMPORTING name TYPE string
      RETURNING VALUE(val) TYPE any,
    get_elements_by_tag_name_ns
      IMPORTING name TYPE string
      RETURNING VALUE(val) TYPE any,
    get_first_child
      RETURNING VALUE(val) TYPE REF TO if_ixml_node,
    get_value
      RETURNING VALUE(val) TYPE string,
    remove_attribute
      IMPORTING name TYPE string,
    remove_node,
    render
      IMPORTING
        ostream TYPE any,
    set_attribute_node_ns
      IMPORTING
        attr TYPE any,
    set_attribute
      IMPORTING
        name TYPE string
        namespace TYPE string
        value TYPE string,
    set_attribute_ns
      IMPORTING
        name TYPE string
        prefix TYPE string
        value TYPE string,
    set_value
      IMPORTING
        value TYPE string
      RETURNING VALUE(rc) TYPE i.
ENDINTERFACE.