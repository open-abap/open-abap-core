TYPE-POOL adbc.

TYPES adbc_name       TYPE char30.
TYPES adbc_column_tab TYPE STANDARD TABLE OF adbc_name WITH DEFAULT KEY.

TYPES adbc_metadata_type TYPE c LENGTH 10.

TYPES: BEGIN OF adbc_rs_metadata_descr,
         column_name TYPE adbc_name,
         data_type   TYPE adbc_metadata_type,
         length      TYPE i,
         decimals    TYPE i,
       END OF adbc_rs_metadata_descr.

TYPES adbc_rs_metadata_descr_tab TYPE STANDARD TABLE OF adbc_rs_metadata_descr WITH KEY column_name.