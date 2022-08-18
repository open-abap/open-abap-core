TYPE-POOL abap.

TYPES abap_encoding TYPE c LENGTH 20.

TYPES: BEGIN OF abap_trans_srcbind,
         name  TYPE string,
         value TYPE REF TO data,
       END OF abap_trans_srcbind.

TYPES abap_trans_srcbind_tab TYPE STANDARD TABLE OF abap_trans_srcbind WITH DEFAULT KEY.
TYPES abap_trans_resbind_tab TYPE abap_trans_srcbind_tab.
TYPES abap_compname TYPE c LENGTH 30.
TYPES abap_typekind TYPE c LENGTH 1.
TYPES abap_structkind TYPE c LENGTH 1.
TYPES abap_editmask TYPE c LENGTH 7.
TYPES abap_abstypename TYPE c LENGTH 200.
TYPES abap_visibility TYPE c LENGTH 1.
TYPES abap_parmkind TYPE c LENGTH 1.

CONSTANTS abap_max_comp_name_ln TYPE i VALUE 30.

TYPES: BEGIN OF abap_componentdescr,
         name       TYPE string,
         type       TYPE REF TO cl_abap_datadescr,
         as_include TYPE abap_bool,
         type_kind  TYPE c LENGTH 1,
       END OF abap_componentdescr.
TYPES abap_component_tab TYPE STANDARD TABLE OF abap_componentdescr WITH DEFAULT KEY.

TYPES: BEGIN OF abap_compdescr,
         length    TYPE i,
         decimals  TYPE i,
         type_kind TYPE abap_typekind,
         name      TYPE abap_compname,
       END OF abap_compdescr.
TYPES abap_compdescr_tab TYPE STANDARD TABLE OF abap_compdescr WITH KEY name.

TYPES: BEGIN OF abap_table_keycompdescr,
         name TYPE string,
       END OF abap_table_keycompdescr.

TYPES: BEGIN OF abap_table_keydescr,
         components      TYPE STANDARD TABLE OF abap_table_keycompdescr WITH DEFAULT KEY,
         name            TYPE string,
         is_primary      TYPE abap_bool,
         access_kind     TYPE string,
         is_unique       TYPE abap_bool,
         key_kind        TYPE string,
       END OF abap_table_keydescr.

TYPES abap_table_keydescr_tab TYPE STANDARD TABLE OF abap_table_keydescr WITH DEFAULT KEY.