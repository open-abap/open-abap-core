INTERFACE if_aunit_info_step PUBLIC.
  DATA name TYPE string READ-ONLY.

  METHODS get_description
    RETURNING
      VALUE(result) TYPE if_aunit_text_description=>ty_s_description.
ENDINTERFACE.
