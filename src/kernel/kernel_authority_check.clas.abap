CLASS kernel_authority_check DEFINITION PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS call
      IMPORTING
        object        TYPE csequence OPTIONAL
        user          TYPE csequence OPTIONAL
        authorization TYPE cl_aunit_auth_check_types_def=>authorization OPTIONAL.

    CLASS-METHODS restrict
      IMPORTING authorizations TYPE cl_aunit_auth_check_types_def=>user_role_authorizations.

    CLASS-METHODS reset.

    CLASS-METHODS get_execution_status
      EXPORTING
        passed_execution TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs
        failed_execution TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
  PRIVATE SECTION.
    CLASS-DATA gv_restricted TYPE abap_bool.
    CLASS-DATA gt_authorizations TYPE cl_aunit_auth_check_types_def=>user_role_authorizations.
    CLASS-DATA gt_passed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    CLASS-DATA gt_failed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.

    CLASS-METHODS is_authorized
      IMPORTING
        object                TYPE csequence
        user                  TYPE csequence
        authorization         TYPE cl_aunit_auth_check_types_def=>authorization
      RETURNING VALUE(result) TYPE abap_bool.

    CLASS-METHODS authorization_matches
      IMPORTING
        configured            TYPE cl_aunit_auth_check_types_def=>authorization
        requested             TYPE cl_aunit_auth_check_types_def=>authorization
      RETURNING VALUE(result) TYPE abap_bool.
ENDCLASS.

CLASS kernel_authority_check IMPLEMENTATION.

  METHOD call.
    DATA lv_user TYPE sy-uname.
    DATA lv_subrc TYPE sysubrc.
    DATA ls_log TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msg.

    lv_user = user.
    IF lv_user IS INITIAL.
      lv_user = sy-uname.
    ENDIF.

    ls_log-object = object.
    ls_log-user = lv_user.
    ls_log-authorizations = authorization.

    IF gv_restricted = abap_false OR is_authorized(
        object        = object
        user          = lv_user
        authorization = authorization ) = abap_true.
      lv_subrc = 0.
      ls_log-description = 'Authorization check passed'.
      APPEND ls_log TO gt_passed.
    ELSE.
      lv_subrc = 4.
      ls_log-description = 'Authorization check failed'.
      APPEND ls_log TO gt_failed.
    ENDIF.
    sy-subrc = lv_subrc.
  ENDMETHOD.

  METHOD restrict.
    gt_authorizations = authorizations.
    gv_restricted = abap_true.
    CLEAR gt_passed.
    CLEAR gt_failed.
  ENDMETHOD.

  METHOD reset.
    CLEAR gv_restricted.
    CLEAR gt_authorizations.
    CLEAR gt_passed.
    CLEAR gt_failed.
  ENDMETHOD.

  METHOD get_execution_status.
    passed_execution = gt_passed.
    failed_execution = gt_failed.
  ENDMETHOD.

  METHOD is_authorized.
    DATA ls_user_auth LIKE LINE OF gt_authorizations.
    DATA ls_object TYPE cl_aunit_auth_check_types_def=>authorizations_for_object.
    DATA lt_users TYPE cl_aunit_auth_check_types_def=>auth_users.
    DATA ls_configured TYPE cl_aunit_auth_check_types_def=>authorization.

    result = abap_false.
    IF object IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT gt_authorizations INTO ls_user_auth.
      lt_users = ls_user_auth-users.
      IF lt_users IS NOT INITIAL.
        READ TABLE lt_users WITH KEY table_line = user TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
      ENDIF.

      LOOP AT ls_user_auth-role_authorizations INTO ls_object WHERE object = object.
        IF ls_object-authorizations IS INITIAL.
          result = abap_true.
          RETURN.
        ENDIF.
        LOOP AT ls_object-authorizations INTO ls_configured.
          IF authorization_matches(
              configured = ls_configured
              requested  = authorization ) = abap_true.
            result = abap_true.
            RETURN.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD authorization_matches.
    DATA ls_requested LIKE LINE OF requested.
    DATA ls_configured LIKE LINE OF configured.
    DATA ls_requested_value LIKE LINE OF ls_requested-fieldvalues.
    DATA ls_configured_value LIKE LINE OF ls_configured-fieldvalues.
    DATA lv_value TYPE c LENGTH 40.
    DATA lv_matched TYPE abap_bool.

    result = abap_true.
    IF configured IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT requested INTO ls_requested.
      IF ls_requested-fieldvalues IS INITIAL.
        CONTINUE.
      ENDIF.
      READ TABLE configured INTO ls_configured
        WITH TABLE KEY primary_key COMPONENTS fieldname = ls_requested-fieldname.
      IF sy-subrc <> 0.
        result = abap_false.
        RETURN.
      ENDIF.

      LOOP AT ls_requested-fieldvalues INTO ls_requested_value.
        lv_value = ls_requested_value-lower_value.
        lv_matched = abap_false.
        LOOP AT ls_configured-fieldvalues INTO ls_configured_value.
          IF ls_configured_value-lower_value = '*'
              OR ( ls_configured_value-upper_value IS INITIAL
                AND ( ( ls_configured_value-lower_value CS '*'
                    AND lv_value CP ls_configured_value-lower_value )
                  OR ( ls_configured_value-lower_value NS '*'
                    AND lv_value = ls_configured_value-lower_value ) ) )
              OR ( ls_configured_value-upper_value IS NOT INITIAL
                AND lv_value >= ls_configured_value-lower_value
                AND lv_value <= ls_configured_value-upper_value ).
            lv_matched = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF lv_matched = abap_false.
          result = abap_false.
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
