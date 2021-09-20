INTERFACE if_abap_channel_types PUBLIC.
  TYPES: BEGIN OF ty_apc_tcp_frame,
           frame_type          TYPE i,
           fixed_length        TYPE i,
           terminator          TYPE string,
           length_field_length TYPE i,
           length_field_offset TYPE i,
           length_field_header TYPE i,
         END OF ty_apc_tcp_frame.
ENDINTERFACE.