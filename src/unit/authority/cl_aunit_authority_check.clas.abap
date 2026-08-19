CLASS cl_aunit_authority_check DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    INTERFACES if_aunit_auth_check_controller.
    INTERFACES if_aunit_auth_check_result_log.
    INTERFACES if_aunit_authority_objset.

    CLASS-METHODS get_controller
      RETURNING VALUE(controller) TYPE REF TO if_aunit_auth_check_controller.

    CLASS-METHODS create_auth_object_set
      IMPORTING
        user_role_authorizations TYPE cl_aunit_auth_check_types_def=>user_role_authorizations OPTIONAL
      RETURNING
        VALUE(auth_objset)       TYPE REF TO if_aunit_authority_objset.

  PRIVATE SECTION.
    CLASS-DATA go_controller TYPE REF TO cl_aunit_authority_check.

    DATA mt_authorizations TYPE cl_aunit_auth_check_types_def=>user_role_authorizations.
    DATA mt_pass_expected TYPE cl_aunit_auth_check_types_def=>user_role_authorizations.
    DATA mt_fail_expected TYPE cl_aunit_auth_check_types_def=>user_role_authorizations.
    DATA mt_pass_failed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA mt_fail_passed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA mt_pass_not_executed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA mt_fail_not_executed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA mt_pass_unexpected TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA mt_fail_unexpected TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.

    METHODS add_role_authorizations
      IMPORTING
        role_authorizations TYPE cl_aunit_auth_check_types_def=>role_auth_objects
        users               TYPE cl_aunit_auth_check_types_def=>auth_users.

    METHODS remove_objects
      IMPORTING
        role_authorizations TYPE cl_aunit_auth_check_types_def=>role_auth_objects
        users               TYPE cl_aunit_auth_check_types_def=>auth_users.

    METHODS flatten
      IMPORTING authorizations TYPE cl_aunit_auth_check_types_def=>user_role_authorizations
      RETURNING VALUE(result)  TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.

    METHODS contains_context
      IMPORTING
        contexts              TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs
        context               TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msg
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS evaluate_expectations
      RETURNING VALUE(result) TYPE abap_bool.
ENDCLASS.

CLASS cl_aunit_authority_check IMPLEMENTATION.
  METHOD get_controller.
    IF go_controller IS NOT BOUND.
      CREATE OBJECT go_controller.
    ENDIF.
    controller = go_controller.
  ENDMETHOD.

  METHOD create_auth_object_set.
    DATA lo_objset TYPE REF TO cl_aunit_authority_check.
    CREATE OBJECT lo_objset.
    lo_objset->mt_authorizations = user_role_authorizations.
    auth_objset = lo_objset.
  ENDMETHOD.

  METHOD if_aunit_auth_check_controller~restrict_authorizations_to.
    DATA lo_objset TYPE REF TO cl_aunit_authority_check.
    IF auth_objset IS NOT BOUND.
      RAISE EXCEPTION TYPE cx_abap_auth_check_exception
        EXPORTING textid = cx_abap_auth_check_exception=>missing_auth_objset.
    ENDIF.
    lo_objset ?= auth_objset.
    mt_authorizations = lo_objset->mt_authorizations.
    kernel_authority_check=>restrict( mt_authorizations ).
  ENDMETHOD.

  METHOD if_aunit_auth_check_controller~authorizations_expected_to.
    DATA lo_objset TYPE REF TO cl_aunit_authority_check.
    IF pass_execution IS NOT BOUND.
      RAISE EXCEPTION TYPE cx_abap_auth_check_exception
        EXPORTING textid = cx_abap_auth_check_exception=>missing_auth_objset.
    ENDIF.
    lo_objset ?= pass_execution.
    mt_pass_expected = lo_objset->mt_authorizations.
    CLEAR mt_fail_expected.
    IF fail_execution IS BOUND.
      lo_objset ?= fail_execution.
      mt_fail_expected = lo_objset->mt_authorizations.
    ENDIF.
  ENDMETHOD.

  METHOD if_aunit_auth_check_controller~assert_expectations.
    IF evaluate_expectations( ) = abap_false.
      cl_abap_unit_assert=>fail( 'AUTHORITY-CHECK expectations were not met' ).
    ENDIF.
  ENDMETHOD.

  METHOD if_aunit_auth_check_controller~check_expectations.
    check_passed = evaluate_expectations( ).
    CLEAR failed_expectations.
    APPEND LINES OF mt_pass_failed TO failed_expectations.
    APPEND LINES OF mt_fail_passed TO failed_expectations.
    APPEND LINES OF mt_pass_not_executed TO failed_expectations.
    APPEND LINES OF mt_fail_not_executed TO failed_expectations.
  ENDMETHOD.

  METHOD if_aunit_auth_check_controller~get_auth_check_execution_log.
    execution_log = me.
  ENDMETHOD.

  METHOD if_aunit_auth_check_controller~reset.
    CLEAR mt_authorizations.
    CLEAR mt_pass_expected.
    CLEAR mt_fail_expected.
    CLEAR mt_pass_failed.
    CLEAR mt_fail_passed.
    CLEAR mt_pass_not_executed.
    CLEAR mt_fail_not_executed.
    CLEAR mt_pass_unexpected.
    CLEAR mt_fail_unexpected.
    kernel_authority_check=>reset( ).
  ENDMETHOD.

  METHOD if_aunit_auth_check_result_log~get_execution_status.
    kernel_authority_check=>get_execution_status(
      IMPORTING
        passed_execution = passed_execution
        failed_execution = failed_execution ).
  ENDMETHOD.

  METHOD if_aunit_auth_check_result_log~get_failed_expectations.
    evaluate_expectations( ).
    expected_to_pass_but_failed = mt_pass_failed.
    expected_to_fail_but_passed = mt_fail_passed.
    expected_to_pass_not_executed = mt_pass_not_executed.
    expected_to_fail_not_executed = mt_fail_not_executed.
  ENDMETHOD.

  METHOD if_aunit_auth_check_result_log~get_unexpected_executions.
    evaluate_expectations( ).
    passed_but_not_expected = mt_pass_unexpected.
    failed_but_not_expected = mt_fail_unexpected.
  ENDMETHOD.

  METHOD if_aunit_authority_objset~clone.
    DATA lo_clone TYPE REF TO cl_aunit_authority_check.
    CREATE OBJECT lo_clone.
    lo_clone->mt_authorizations = mt_authorizations.
    clone = lo_clone.
  ENDMETHOD.

  METHOD if_aunit_authority_objset~append_auth_objset.
    DATA lo_objset TYPE REF TO cl_aunit_authority_check.
    IF auth_objset IS NOT BOUND.
      RAISE EXCEPTION TYPE cx_abap_auth_check_exception
        EXPORTING textid = cx_abap_auth_check_exception=>missing_auth_objset.
    ENDIF.
    lo_objset ?= auth_objset.
    APPEND LINES OF lo_objset->mt_authorizations TO mt_authorizations.
  ENDMETHOD.

  METHOD if_aunit_authority_objset~add_authobj.
    DATA lt_roles TYPE cl_aunit_auth_check_types_def=>role_auth_objects.
    DATA ls_role LIKE LINE OF lt_roles.
    DATA lt_authorizations TYPE cl_aunit_auth_check_types_def=>authorizations.
    DATA lt_authorization TYPE cl_aunit_auth_check_types_def=>authorization.
    ls_role-object = object.
    APPEND lt_authorization TO lt_authorizations.
    ls_role-authorizations = lt_authorizations.
    APPEND ls_role TO lt_roles.
    add_role_authorizations(
      role_authorizations = lt_roles
      users               = users ).
  ENDMETHOD.

  METHOD if_aunit_authority_objset~add_authobj_with_fldval.
    DATA lt_roles TYPE cl_aunit_auth_check_types_def=>role_auth_objects.
    DATA ls_role LIKE LINE OF lt_roles.
    DATA lt_authorizations TYPE cl_aunit_auth_check_types_def=>authorizations.
    DATA lt_authorization TYPE cl_aunit_auth_check_types_def=>authorization.
    ls_role-object = object.
    INSERT field INTO TABLE lt_authorization.
    APPEND lt_authorization TO lt_authorizations.
    ls_role-authorizations = lt_authorizations.
    APPEND ls_role TO lt_roles.
    add_role_authorizations(
      role_authorizations = lt_roles
      users               = users ).
  ENDMETHOD.

  METHOD if_aunit_authority_objset~add_authobj_with_fldvals.
    DATA lt_roles TYPE cl_aunit_auth_check_types_def=>role_auth_objects.
    DATA ls_role LIKE LINE OF lt_roles.
    ls_role-object = object.
    ls_role-authorizations = fields.
    APPEND ls_role TO lt_roles.
    add_role_authorizations(
      role_authorizations = lt_roles
      users               = users ).
  ENDMETHOD.

  METHOD if_aunit_authority_objset~add_authobjs_with_fldvals.
    add_role_authorizations(
      role_authorizations = role_authorizations
      users               = users ).
  ENDMETHOD.

  METHOD if_aunit_authority_objset~add_role_auths_for_users.
    APPEND LINES OF user_role_authorizations TO mt_authorizations.
  ENDMETHOD.

  METHOD if_aunit_authority_objset~remove_authobj.
    DATA lt_roles TYPE cl_aunit_auth_check_types_def=>role_auth_objects.
    DATA ls_role LIKE LINE OF lt_roles.
    ls_role-object = object.
    APPEND ls_role TO lt_roles.
    remove_objects(
      role_authorizations = lt_roles
      users               = users ).
  ENDMETHOD.

  METHOD if_aunit_authority_objset~remove_authobj_with_fldval.
    if_aunit_authority_objset~remove_authobj(
      object = object
      users  = users ).
  ENDMETHOD.

  METHOD if_aunit_authority_objset~remove_authobj_with_fldvals.
    if_aunit_authority_objset~remove_authobj(
      object = object
      users  = users ).
  ENDMETHOD.

  METHOD if_aunit_authority_objset~remove_authobjs_with_fldvals.
    remove_objects(
      role_authorizations = role_authorizations
      users               = users ).
  ENDMETHOD.

  METHOD if_aunit_authority_objset~remove_role_auths_for_users.
    DATA ls_user_auth LIKE LINE OF user_role_authorizations.
    LOOP AT user_role_authorizations INTO ls_user_auth.
      remove_objects(
        role_authorizations = ls_user_auth-role_authorizations
        users               = ls_user_auth-users ).
    ENDLOOP.
  ENDMETHOD.

  METHOD add_role_authorizations.
    DATA ls_user_auth TYPE cl_aunit_auth_check_types_def=>user_role_authorization.
    ls_user_auth-role_authorizations = role_authorizations.
    ls_user_auth-users = users.
    APPEND ls_user_auth TO mt_authorizations.
  ENDMETHOD.

  METHOD remove_objects.
    DATA ls_remove LIKE LINE OF role_authorizations.
    DATA ls_user_auth LIKE LINE OF mt_authorizations.
    DATA lv_index TYPE i.
    LOOP AT mt_authorizations INTO ls_user_auth.
      lv_index = sy-tabix.
      IF users IS NOT INITIAL AND ls_user_auth-users <> users.
        CONTINUE.
      ENDIF.
      LOOP AT role_authorizations INTO ls_remove.
        DELETE ls_user_auth-role_authorizations WHERE object = ls_remove-object.
      ENDLOOP.
      MODIFY mt_authorizations FROM ls_user_auth INDEX lv_index.
    ENDLOOP.
  ENDMETHOD.

  METHOD flatten.
    DATA ls_user_auth LIKE LINE OF authorizations.
    DATA ls_role TYPE cl_aunit_auth_check_types_def=>authorizations_for_object.
    DATA lt_users TYPE cl_aunit_auth_check_types_def=>auth_users.
    DATA lv_user LIKE LINE OF lt_users.
    DATA lt_auths TYPE cl_aunit_auth_check_types_def=>authorizations.
    DATA ls_auth TYPE cl_aunit_auth_check_types_def=>authorization.
    DATA ls_context TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msg.

    LOOP AT authorizations INTO ls_user_auth.
      lt_users = ls_user_auth-users.
      IF lt_users IS INITIAL.
        APPEND sy-uname TO lt_users.
      ENDIF.
      LOOP AT ls_user_auth-role_authorizations INTO ls_role.
        lt_auths = ls_role-authorizations.
        IF lt_auths IS INITIAL.
          CLEAR ls_auth.
          APPEND ls_auth TO lt_auths.
        ENDIF.
        LOOP AT lt_users INTO lv_user.
          LOOP AT lt_auths INTO ls_auth.
            CLEAR ls_context.
            ls_context-object = ls_role-object.
            ls_context-user = lv_user.
            ls_context-authorizations = ls_auth.
            APPEND ls_context TO result.
          ENDLOOP.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD contains_context.
    DATA ls_context LIKE LINE OF contexts.
    result = abap_false.
    LOOP AT contexts INTO ls_context.
      IF ls_context-object = context-object
          AND ls_context-user = context-user
          AND ls_context-authorizations = context-authorizations.
        result = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD evaluate_expectations.
    DATA lt_passed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA lt_failed TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA lt_pass_expected TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA lt_fail_expected TYPE cl_aunit_auth_check_types_def=>auth_ctxtset_msgs.
    DATA ls_context LIKE LINE OF lt_passed.

    CLEAR mt_pass_failed.
    CLEAR mt_fail_passed.
    CLEAR mt_pass_not_executed.
    CLEAR mt_fail_not_executed.
    CLEAR mt_pass_unexpected.
    CLEAR mt_fail_unexpected.

    kernel_authority_check=>get_execution_status(
      IMPORTING
        passed_execution = lt_passed
        failed_execution = lt_failed ).
    lt_pass_expected = flatten( mt_pass_expected ).
    lt_fail_expected = flatten( mt_fail_expected ).

    LOOP AT lt_pass_expected INTO ls_context.
      IF contains_context(
          contexts = lt_passed
          context  = ls_context ) = abap_true.
        CONTINUE.
      ELSEIF contains_context(
          contexts = lt_failed
          context  = ls_context ) = abap_true.
        ls_context-description = 'Expected to pass but failed'.
        APPEND ls_context TO mt_pass_failed.
      ELSE.
        ls_context-description = 'Expected to pass but was not executed'.
        APPEND ls_context TO mt_pass_not_executed.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_fail_expected INTO ls_context.
      IF contains_context(
          contexts = lt_failed
          context  = ls_context ) = abap_true.
        CONTINUE.
      ELSEIF contains_context(
          contexts = lt_passed
          context  = ls_context ) = abap_true.
        ls_context-description = 'Expected to fail but passed'.
        APPEND ls_context TO mt_fail_passed.
      ELSE.
        ls_context-description = 'Expected to fail but was not executed'.
        APPEND ls_context TO mt_fail_not_executed.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_passed INTO ls_context.
      IF contains_context(
          contexts = lt_pass_expected
          context  = ls_context ) = abap_false
          AND contains_context(
            contexts = lt_fail_expected
            context  = ls_context ) = abap_false.
        ls_context-description = 'Passed but was not expected'.
        APPEND ls_context TO mt_pass_unexpected.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_failed INTO ls_context.
      IF contains_context(
          contexts = lt_pass_expected
          context  = ls_context ) = abap_false
          AND contains_context(
            contexts = lt_fail_expected
            context  = ls_context ) = abap_false.
        ls_context-description = 'Failed but was not expected'.
        APPEND ls_context TO mt_fail_unexpected.
      ENDIF.
    ENDLOOP.

    result = abap_true.
    IF mt_pass_failed IS NOT INITIAL
        OR mt_fail_passed IS NOT INITIAL
        OR mt_pass_not_executed IS NOT INITIAL
        OR mt_fail_not_executed IS NOT INITIAL.
      result = abap_false.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
