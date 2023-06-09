CLASS cl_gui_frontend_services DEFINITION PUBLIC.
  PUBLIC SECTION.
    CONSTANTS filetype_all TYPE string VALUE 'abc'.
    CONSTANTS action_cancel TYPE i VALUE 1.
    CONSTANTS action_ok TYPE i VALUE 1.

    CONSTANTS platform_nt351 TYPE i VALUE 1.
    CONSTANTS platform_nt40 TYPE i VALUE 2.
    CONSTANTS platform_nt50 TYPE i VALUE 3.
    CONSTANTS platform_windows95 TYPE i VALUE 4.
    CONSTANTS platform_windows98 TYPE i VALUE 5.
    CONSTANTS platform_windowsxp TYPE i VALUE 6.

    CLASS-METHODS
      gui_download
        IMPORTING
          bin_filesize          TYPE i OPTIONAL
          filename              TYPE string
          filetype              TYPE string OPTIONAL
          write_lf              TYPE abap_bool OPTIONAL
          write_field_separator TYPE char1 OPTIONAL
        CHANGING
          data_tab TYPE any.

    CLASS-METHODS file_exist
      IMPORTING
        file          TYPE string
      RETURNING
        VALUE(result) TYPE abap_bool.

    CLASS-METHODS
      directory_list_files
        IMPORTING
          directory  TYPE string
        CHANGING
          file_table TYPE any
          count      TYPE i.

    CLASS-METHODS
      gui_upload
        IMPORTING
          filename TYPE string
          filetype TYPE string OPTIONAL
          codepage TYPE abap_encoding DEFAULT space
          read_by_line TYPE abap_bool OPTIONAL
        EXPORTING
          filelength TYPE i
        CHANGING
          data_tab TYPE any.

    CLASS-METHODS
      file_open_dialog
        IMPORTING
          window_title      TYPE string OPTIONAL
          default_filename  TYPE string OPTIONAL
          default_extension TYPE string OPTIONAL
          multiselection    TYPE abap_bool OPTIONAL
          file_filter       TYPE string OPTIONAL
          initial_directory TYPE string OPTIONAL
        CHANGING
          file_table        TYPE filetable
          rc                TYPE i
          user_action       TYPE i OPTIONAL.

    CLASS-METHODS
      get_platform
        RETURNING
          VALUE(platform) TYPE i.

    CLASS-METHODS
      file_save_dialog
        IMPORTING
          window_title         TYPE string OPTIONAL
          default_extension    TYPE string OPTIONAL
          default_file_name    TYPE string OPTIONAL
          file_filter          TYPE string OPTIONAL
        CHANGING
          filename             TYPE string
          path                 TYPE string
          fullpath             TYPE string
          user_action          TYPE i OPTIONAL.

    CLASS-METHODS
      directory_browse
        IMPORTING
          window_title    TYPE string OPTIONAL
          initial_folder  TYPE string
        CHANGING
          selected_folder TYPE string.

    CLASS-METHODS
      execute
        IMPORTING
          document          TYPE string OPTIONAL
          application       TYPE string OPTIONAL
          parameter         TYPE string OPTIONAL
          default_directory TYPE string OPTIONAL
          maximized         TYPE string OPTIONAL
          minimized         TYPE string OPTIONAL
          synchronous       TYPE string OPTIONAL
          operation         TYPE string DEFAULT 'OPEN'.

    CLASS-METHODS
      get_file_separator
        CHANGING
          file_separator TYPE string.

    CLASS-METHODS
      directory_exist
        IMPORTING
          directory TYPE string
        RETURNING
          VALUE(result) TYPE abap_bool.

    CLASS-METHODS
      directory_create
        IMPORTING
          directory TYPE string
        CHANGING
          rc TYPE i.

    CLASS-METHODS
      clipboard_export
        IMPORTING
          no_auth_check TYPE abap_bool OPTIONAL
        EXPORTING
          data TYPE any
        CHANGING
          rc TYPE i.

    CLASS-METHODS
      get_system_directory
        CHANGING
          system_directory TYPE string.

    CLASS-METHODS
      get_gui_version
        CHANGING
          version_table TYPE filetable
          rc            TYPE i.

    CLASS-METHODS clipboard_import
      EXPORTING
        data   TYPE STANDARD TABLE
        length TYPE i.

    CLASS-METHODS file_delete
      IMPORTING
        filename TYPE string
      CHANGING
        rc       TYPE i.

    CLASS-METHODS get_sapgui_workdir
      CHANGING
        sapworkdir TYPE string.

ENDCLASS.

CLASS cl_gui_frontend_services IMPLEMENTATION.
  METHOD directory_exist.
    ASSERT 1 = 'directory_exist not supported'.
  ENDMETHOD.

  METHOD get_sapgui_workdir.
    ASSERT 1 = 'get_sapgui_workdir not supported'.
  ENDMETHOD.

  METHOD file_exist.
    ASSERT 1 = 'file_exist not supported'.
  ENDMETHOD.

  METHOD file_delete.
    ASSERT 1 = 'file_delete not supported'.
  ENDMETHOD.

  METHOD clipboard_import.
    ASSERT 1 = 'clipboard_import not supported'.
  ENDMETHOD.

  METHOD directory_list_files.
    ASSERT 1 = 'directory_list_files not supported'.
  ENDMETHOD.

  METHOD directory_create.
    ASSERT 1 = 'directory_create not supported'.
  ENDMETHOD.

  METHOD gui_download.
    ASSERT 1 = 'gui_download not supported'.
  ENDMETHOD.

  METHOD get_file_separator.
    ASSERT 1 = 'get_file_separator not supported'.
  ENDMETHOD.

  METHOD execute.
    ASSERT 1 = 'execute not supported'.
  ENDMETHOD.

  METHOD directory_browse.
    ASSERT 1 = 'directory_browse not supported'.
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

  METHOD clipboard_export.
    ASSERT 1 = 'clipboard_export not supported'.
  ENDMETHOD.

  METHOD get_system_directory.
    ASSERT 1 = 'get_system_directory not supported'.
  ENDMETHOD.

  METHOD get_gui_version.
    ASSERT 1 = 'get_gui_verison not supported'.
  ENDMETHOD.
ENDCLASS.
