CLASS lcl_response DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_http_response.
  PRIVATE SECTION.
    DATA status TYPE i.
ENDCLASS.

CLASS lcl_response IMPLEMENTATION.

  METHOD if_http_response~get_header_field.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_response~get_status.
    code = status.
  ENDMETHOD.

  METHOD if_http_response~get_cdata.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_response~get_content_type.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

  METHOD if_http_response~get_data.
    ASSERT 2 = 'todo'.
  ENDMETHOD.

ENDCLASS.