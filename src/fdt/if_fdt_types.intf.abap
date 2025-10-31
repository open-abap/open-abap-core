INTERFACE if_fdt_types PUBLIC.
  TYPES element_number TYPE n LENGTH 34.
  TYPES id TYPE sysuuid_c32.
  TYPES object_type TYPE c LENGTH 2.

  TYPES: BEGIN OF s_message,
           id          TYPE id,
           object_type TYPE object_type,
           msgid       TYPE symsgid,
           msgty       TYPE symsgty,
           msgno       TYPE symsgno,
           msgv1       TYPE symsgv,
           msgv2       TYPE symsgv,
           msgv3       TYPE symsgv,
           msgv4       TYPE symsgv,
           text        TYPE c LENGTH 250,
           source      TYPE string,
           related_id  TYPE id,
           r_ref       TYPE REF TO data,
         END OF s_message.
  TYPES t_message TYPE STANDARD TABLE OF s_message WITH NON-UNIQUE KEY id object_type.

ENDINTERFACE.