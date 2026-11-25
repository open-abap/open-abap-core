INTERFACE if_aunit_text_description PUBLIC.
  TYPES ty_t_params TYPE STANDARD TABLE OF string WITH DEFAULT KEY.

  TYPES: BEGIN OF ty_s_description,
           id     TYPE string,
           params TYPE ty_t_params,
         END OF ty_s_description.
  TYPES ty_t_descriptions TYPE STANDARD TABLE OF ty_s_description WITH DEFAULT KEY.

  METHODS get_string
    IMPORTING
      description   TYPE ty_s_description
    RETURNING
      VALUE(result) TYPE string.

  METHODS get_string_table
    IMPORTING
      descriptions  TYPE ty_t_descriptions
    RETURNING
      VALUE(result) TYPE string_table.
ENDINTERFACE.
