*"* use this source file for your ABAP unit test classes
CLASS ltcl_integration_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA go_environment TYPE REF TO if_cds_test_environment.
    METHODS:
      det_status FOR TESTING RAISING cx_static_check.

    CLASS-METHODS:
      class_setup,
      class_teardown.
    METHODS:
      teardown.
ENDCLASS.


CLASS ltcl_integration_test IMPLEMENTATION.

  METHOD det_status.

    "Create data
    MODIFY ENTITIES OF zcaa361_i_travel_sfh
      ENTITY Travel
        CREATE FROM VALUE #( (
          Travel_ID  = '1'
          %control-Travel_ID = if_abap_behv=>mk-on
        ) )
      FAILED   DATA(ls_failed)
      REPORTED DATA(ls_reported).

    cl_abap_unit_assert=>assert_initial(   ls_failed-travel ).
    cl_abap_unit_assert=>assert_initial( ls_reported-travel ).

    "This triggers the determination
    COMMIT ENTITIES.

    "Get data after determination is triggered
    READ ENTITIES OF zcaa361_i_travel_sfh
      ENTITY Travel
        FROM VALUE #( (
          Travel_ID       = '1'
          %control-Status = if_abap_behv=>mk-on
        ) )
      RESULT DATA(lt_travel).

    cl_abap_unit_assert=>assert_not_initial( lt_travel ).

    cl_abap_unit_assert=>assert_not_initial(
        VALUE #( lt_travel[ KEY entity COMPONENTS Travel_ID = '1' ] OPTIONAL )
      ).

    cl_abap_unit_assert=>assert_equals(
        exp = 'N'
        act = lt_travel[ KEY entity COMPONENTS Travel_ID = '1' ]-Status
      ).


  ENDMETHOD.

  METHOD class_setup.
    go_environment = cl_cds_test_environment=>create_for_multiple_cds(
        i_for_entities = VALUE #( ( i_for_entity = 'ZCAA361_I_TRAVEL_SFH' ) )
      ).

  ENDMETHOD.

  METHOD class_teardown.
    go_environment->destroy( ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
    go_environment->clear_doubles( ).
  ENDMETHOD.

ENDCLASS.
