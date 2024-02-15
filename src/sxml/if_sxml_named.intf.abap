INTERFACE if_sxml_named PUBLIC.

  TYPES: BEGIN OF pathnode,
           BEGIN OF qname,
             name      TYPE string,
             namespace TYPE string,
           END OF qname,
           prefix         TYPE string,
           child_position TYPE i,
         END OF pathnode.
  TYPES path TYPE STANDARD TABLE OF pathnode WITH DEFAULT KEY.

  TYPES: BEGIN OF nsbinding,
           prefix TYPE string,
           nsuri  TYPE string,
         END OF nsbinding.
  TYPES nsbindings TYPE HASHED TABLE OF nsbinding WITH UNIQUE KEY prefix.

  CONSTANTS co_use_default_xmlns TYPE string VALUE ':'.

ENDINTERFACE.