TYPE-POOL abap.

TYPES abap_encoding TYPE c LENGTH 20.

TYPES: BEGIN OF abap_trans_srcbind,
         name  TYPE string,
         value TYPE REF TO data,
       END OF abap_trans_srcbind.

TYPES abap_trans_srcbind_tab TYPE STANDARD TABLE OF abap_trans_srcbind WITH DEFAULT KEY.
TYPES abap_trans_resbind_tab TYPE abap_trans_srcbind_tab.


CONSTANTS abap_max_comp_name_ln TYPE i VALUE 30.
