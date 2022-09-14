TYPE-POOL abap.

TYPES: BEGIN OF abap_trans_srcbind,
         name  TYPE string,
         value TYPE REF TO data,
       END OF abap_trans_srcbind.

TYPES abap_encoding          TYPE c LENGTH 20.
TYPES abap_trans_srcbind_tab TYPE STANDARD TABLE OF abap_trans_srcbind WITH DEFAULT KEY.
TYPES abap_trans_resbind_tab TYPE abap_trans_srcbind_tab.
TYPES abap_abstypename       TYPE c LENGTH 200.
TYPES abap_attrname          TYPE c LENGTH 61.
TYPES abap_classname         TYPE c LENGTH 30.
TYPES abap_compname          TYPE c LENGTH 30.
TYPES abap_editmask          TYPE c LENGTH 7.
TYPES abap_evntname          TYPE c LENGTH 61.
TYPES abap_excpname          TYPE c LENGTH 30.
TYPES abap_helpid            TYPE c LENGTH 62.
TYPES abap_intfname          TYPE c LENGTH 30.
TYPES abap_keydefkind        TYPE c LENGTH 1.
TYPES abap_keyname           TYPE c LENGTH 255.
TYPES abap_methname          TYPE c LENGTH 61.
TYPES abap_parmkind          TYPE c LENGTH 1.
TYPES abap_parmname          TYPE c LENGTH 30.
TYPES abap_structkind        TYPE c LENGTH 1.
TYPES abap_typekind          TYPE c LENGTH 1.
TYPES abap_visibility        TYPE c LENGTH 1.

CONSTANTS abap_max_comp_name_ln TYPE i VALUE 30.

TYPES: BEGIN OF abap_componentdescr,
         name       TYPE string,
         type       TYPE REF TO cl_abap_datadescr,
         as_include TYPE abap_bool,
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
         components  TYPE STANDARD TABLE OF abap_table_keycompdescr WITH DEFAULT KEY,
         name        TYPE string,
         is_primary  TYPE abap_bool,
         access_kind TYPE string,
         is_unique   TYPE abap_bool,
         key_kind    TYPE string,
       END OF abap_table_keydescr.

TYPES abap_table_keydescr_tab TYPE STANDARD TABLE OF abap_table_keydescr WITH DEFAULT KEY.

TYPES: BEGIN OF abap_simple_componentdescr,
         name TYPE string,
         type TYPE REF TO cl_abap_datadescr,
       END OF abap_simple_componentdescr.
TYPES abap_component_view_tab TYPE STANDARD TABLE OF abap_simple_componentdescr WITH KEY name.

TYPES: BEGIN OF abap_parmbind,
         name  TYPE abap_parmname,
         kind  TYPE abap_parmkind,
         value TYPE REF TO data,
       END OF abap_parmbind.
TYPES abap_parmbind_tab TYPE HASHED TABLE OF abap_parmbind WITH UNIQUE KEY name.

TYPES: BEGIN OF abap_parmdescr,
         length      TYPE i,
         decimals    TYPE i,
         type_kind   TYPE abap_typekind,
         name        TYPE abap_parmname,
         parm_kind   TYPE abap_parmkind,
         by_value    TYPE abap_bool,
         is_optional TYPE abap_bool,
       END OF abap_parmdescr.
TYPES abap_parmdescr_tab TYPE STANDARD TABLE OF abap_parmdescr WITH KEY name.

TYPES: BEGIN OF abap_func_parmbind,
         value     TYPE REF TO data,
         tables_wa TYPE REF TO data,
         kind      TYPE i,
         name      TYPE abap_parmname,
       END OF abap_func_parmbind.
TYPES abap_func_parmbind_tab TYPE SORTED TABLE OF abap_func_parmbind WITH UNIQUE KEY kind name.

TYPES: BEGIN OF abap_func_excpbind,
         message TYPE REF TO data,
         value   TYPE i,
         name    TYPE abap_excpname,
       END OF abap_func_excpbind.
TYPES abap_func_excpbind_tab TYPE HASHED TABLE OF abap_func_excpbind WITH UNIQUE KEY name.

TYPES: BEGIN OF abap_excpdescr,
         name         TYPE abap_excpname,
         is_resumable TYPE abap_bool,
       END OF abap_excpdescr.
TYPES abap_excpdescr_tab TYPE STANDARD TABLE OF abap_excpdescr WITH KEY name.

TYPES: BEGIN OF abap_methdescr,
         parameters       TYPE abap_parmdescr_tab,
         exceptions       TYPE abap_excpdescr_tab,
         name             TYPE abap_methname,
         for_event        TYPE abap_evntname,
         of_class         TYPE abap_classname,
         visibility       TYPE abap_visibility,
         is_interface     TYPE abap_bool,
         is_inherited     TYPE abap_bool,
         is_redefined     TYPE abap_bool,
         is_abstract      TYPE abap_bool,
         is_final         TYPE abap_bool,
         is_class         TYPE abap_bool,
         alias_for        TYPE abap_methname,
         is_raising_excps TYPE abap_bool,
       END OF abap_methdescr.
TYPES abap_methdescr_tab TYPE STANDARD TABLE OF abap_methdescr WITH KEY name.

TYPES: BEGIN OF abap_attrdescr,
         length         TYPE i,
         decimals       TYPE i,
         name           TYPE abap_attrname,
         type_kind      TYPE abap_typekind,
         visibility     TYPE abap_visibility,
         is_interface   TYPE abap_bool,
         is_inherited   TYPE abap_bool,
         is_class       TYPE abap_bool,
         is_constant    TYPE abap_bool,
         is_virtual     TYPE abap_bool,
         is_read_only   TYPE abap_bool,
         alias_for      TYPE abap_attrname,
       END OF abap_attrdescr.
TYPES abap_attrdescr_tab TYPE STANDARD TABLE OF abap_attrdescr WITH KEY name.


TYPES: BEGIN OF abap_intfdescr,
         name           TYPE abap_intfname,
         is_inherited   TYPE abap_bool,
       END OF abap_intfdescr.
TYPES abap_intfdescr_tab TYPE STANDARD TABLE OF abap_intfdescr WITH KEY name.

TYPES: BEGIN OF abap_excpbind,
         name  TYPE abap_excpname,
         value TYPE i,
       END OF abap_excpbind.
TYPES abap_excpbind_tab TYPE HASHED TABLE OF abap_excpbind WITH UNIQUE KEY name.

TYPES: BEGIN OF abap_keydescr,
         name TYPE abap_keyname,
       END OF abap_keydescr.
TYPES abap_keydescr_tab TYPE STANDARD TABLE OF abap_keydescr WITH KEY name.