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
      gui_download,
      gui_upload,
      file_open_dialog,
      get_platform
        RETURNING
          VALUE(platform) TYPE i,
      file_save_dialog.
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