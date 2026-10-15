CLASS cx_fhc_runtime DEFINITION PUBLIC INHERITING FROM cx_static_check FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg.
    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF internal_error,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF internal_error.
    CONSTANTS:
      BEGIN OF determination_failed,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF determination_failed.
    CONSTANTS:
      BEGIN OF start_date_initial,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '100',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF start_date_initial.
    CONSTANTS:
      BEGIN OF end_date_initial,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '101',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_initial.
    CONSTANTS:
      BEGIN OF date_range_invalid,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '102',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF date_range_invalid.
    CONSTANTS:
      BEGIN OF date_range_out_of_validity,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '103',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF date_range_out_of_validity.
    CONSTANTS:
      BEGIN OF invalid_date_extension,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '104',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_date_extension.
    CONSTANTS:
      BEGIN OF language_initial,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '105',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF language_initial.
    CONSTANTS:
      BEGIN OF factorycalendar_id_initial,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '106',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF factorycalendar_id_initial.
    CONSTANTS:
      BEGIN OF date_initial,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '107',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF date_initial.
    CONSTANTS:
      BEGIN OF factorydate_initial,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '108',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF factorydate_initial.
    CONSTANTS:
      BEGIN OF date_out_of_validity,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '109',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF date_out_of_validity.
    CONSTANTS:
      BEGIN OF factorycalendar_not_found,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '110',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF factorycalendar_not_found.
    CONSTANTS:
      BEGIN OF holidaycalendar_id_initial,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '111',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF holidaycalendar_id_initial.
    CONSTANTS:
      BEGIN OF holidaycalendar_not_found,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '112',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF holidaycalendar_not_found.
    CONSTANTS:
      BEGIN OF holiday_not_found,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '113',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF holiday_not_found.
    CONSTANTS:
      BEGIN OF holiday_id_initial,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '114',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF holiday_id_initial.
    CONSTANTS:
      BEGIN OF no_assignments_found,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '115',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_assignments_found.
    CONSTANTS:
      BEGIN OF invalid_number_of_days,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '116',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_number_of_days.
    CONSTANTS:
      BEGIN OF runtime_object_initial,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '200',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF runtime_object_initial.
    CONSTANTS:
      BEGIN OF only_factorycalendar,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '201',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF only_factorycalendar.
    CONSTANTS:
      BEGIN OF easter_year_out_of_range,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '300',
        attr1 TYPE scx_attrname VALUE 'ATTRIBUTE1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF easter_year_out_of_range.
    CONSTANTS:
      BEGIN OF buffer_update_failed,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '301',
        attr1 TYPE scx_attrname VALUE 'ATTRIBUTE1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF buffer_update_failed.
    CONSTANTS:
      BEGIN OF no_buffer_entries_found,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '302',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF no_buffer_entries_found.
    CONSTANTS:
      BEGIN OF buffer_range_out_of_bounds,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '304',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF buffer_range_out_of_bounds.
    CONSTANTS:
      BEGIN OF buffer_range_not_set,
        msgid TYPE symsgid VALUE 'FHC_RUNTIME',
        msgno TYPE symsgno VALUE '305',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF buffer_range_not_set.

    DATA attribute1 TYPE string.
    DATA attribute2 TYPE string.
    DATA attribute3 TYPE string.
    DATA attribute4 TYPE string.

    METHODS constructor
      IMPORTING
        textid     LIKE if_t100_message=>t100key OPTIONAL
        previous   LIKE previous OPTIONAL
        attribute1 TYPE string OPTIONAL
        attribute2 TYPE string OPTIONAL
        attribute3 TYPE string OPTIONAL
        attribute4 TYPE string OPTIONAL.

ENDCLASS.

CLASS cx_fhc_runtime IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    me->attribute1 = attribute1.
    me->attribute2 = attribute2.
    me->attribute3 = attribute3.
    me->attribute4 = attribute4.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
