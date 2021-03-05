CLASS cl_gui_frontend_services DEFINITION PUBLIC.
  PUBLIC SECTION.
    CONSTANTS filetype_all TYPE string VALUE 'abc'.
    CONSTANTS action_cancel TYPE i VALUE 1.

    CONSTANTS platform_nt351 TYPE i VALUE 1.
    CONSTANTS platform_nt40 TYPE i VALUE 2.
    CONSTANTS platform_nt50 TYPE i VALUE 3.
    CONSTANTS platform_windows95 TYPE i VALUE 4.
    CONSTANTS platform_windows98 TYPE i VALUE 5.
    CONSTANTS platform_windowsxp TYPE i VALUE 6.

    CLASS-METHODS:
      gui_download
        IMPORTING
          bin_filesize TYPE i
          filename     TYPE string
          filetype     TYPE string
        CHANGING
          data_tab TYPE any,
      gui_upload
        IMPORTING
          filename TYPE string
          filetype TYPE string
        EXPORTING
          filelength TYPE i
        CHANGING
          data_tab TYPE any,
      file_open_dialog
        IMPORTING
          window_title     TYPE string
          default_filename TYPE string
          file_filter      TYPE string
        CHANGING
          file_table  TYPE filetable
          rc          TYPE i
          user_action TYPE i,
      get_platform
        RETURNING
          VALUE(platform) TYPE i,
      file_save_dialog
        IMPORTING
          window_title         TYPE string
          default_extension    TYPE string
          default_file_name    TYPE string
          file_filter          TYPE string
        CHANGING
          filename   TYPE string
          path       TYPE string
          fullpath   TYPE string
          user_actin TYPE i.
ENDCLASS.

CLASS cl_gui_frontend_services IMPLEMENTATION.
  METHOD gui_download.
    ASSERT 1 = 'gui_download not supported'.
  ENDMETHOD.

  METHOD gui_upload.
    ASSERT 1 = 'gui_upload not supported'.
  ENDMETHOD.

  METHOD file_open_dialog.
    ASSERT 1 = 'file_open_dialog not supported'.
  ENDMETHOD.

  METHOD file_save_dialog.
    ASSERT 1 = 'file_save_dialog not supported'.
  ENDMETHOD.

  METHOD get_platform.
    platform = platform_windowsxp.
  ENDMETHOD.
ENDCLASS.