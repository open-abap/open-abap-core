INTERFACE if_http_client PUBLIC.
  DATA request TYPE REF TO if_http_request.
  DATA response TYPE REF TO if_http_response.

  DATA propertytype_logon_popup TYPE i.
  DATA co_disabled TYPE i.

  METHODS authenticate
    IMPORTING
      proxy_authentication TYPE abap_bool
      username             TYPE string
      password             TYPE string.
ENDINTERFACE.