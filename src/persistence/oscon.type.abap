TYPE-POOL oscon.

CONSTANTS oscon_true  TYPE c LENGTH 1 VALUE 'X'.
CONSTANTS oscon_false TYPE c LENGTH 1 VALUE ' '.

CONSTANTS oscon_dmode_update_task TYPE i VALUE 1.
CONSTANTS oscon_dmode_default TYPE i VALUE oscon_dmode_update_task.

CONSTANTS oscon_ostatus_not_loaded TYPE i VALUE 0.
CONSTANTS oscon_ostatus_new        TYPE i VALUE 1.
CONSTANTS oscon_ostatus_loaded     TYPE i VALUE 2.
CONSTANTS oscon_ostatus_changed    TYPE i VALUE 3.
CONSTANTS oscon_ostatus_deleted    TYPE i VALUE 4.
CONSTANTS oscon_ostatus_transient  TYPE i VALUE 10.
CONSTANTS oscon_ostatus_loading    TYPE i VALUE 12.

CONSTANTS oscon_dbstatus_unknown      TYPE i VALUE 0.
CONSTANTS oscon_dbstatus_existing     TYPE i VALUE 1.
CONSTANTS oscon_dbstatus_not_existing TYPE i VALUE 2.