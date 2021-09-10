INTERFACE if_apc_tcp_frame_types PUBLIC.
  TYPES: BEGIN OF ty_frame_type,
           frame_type          TYPE i,
           fixed_length        TYPE i,
           terminator          TYPE string,
           length_field_length TYPE i,
           length_field_offset TYPE i,
           length_field_header TYPE i,
         END OF ty_frame_type.

  CONSTANTS co_frame_type_fixed_length TYPE i VALUE 1.
  CONSTANTS co_frame_type_terminator   TYPE i VALUE 2.
  CONSTANTS co_frame_type_length_field TYPE i VALUE 3.
ENDINTERFACE.