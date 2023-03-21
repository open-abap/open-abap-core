CLASS cl_mime_repository_api DEFINITION PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES if_mr_api.
    ALIASES get_api FOR if_mr_api~get_api.
ENDCLASS.

CLASS cl_mime_repository_api IMPLEMENTATION.
  METHOD if_mr_api~get_api.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_mr_api~get.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_mr_api~create_folder.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_mr_api~put.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_mr_api~delete.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_mr_api~file_list.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_mr_api~properties.
    ASSERT 1 = 'todo'.
  ENDMETHOD.

  METHOD if_mr_api~get_io_for_url.
    ASSERT 1 = 'todo'.
  ENDMETHOD.
ENDCLASS.