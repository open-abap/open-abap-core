INTERFACE if_aunit_info_message PUBLIC.
  METHODS get_complete_description
    RETURNING
      VALUE(result) TYPE if_aunit_text_description=>ty_t_descriptions.
ENDINTERFACE.
