CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validateDates FOR VALIDATION Travel~validateDates
      IMPORTING keys FOR Travel.

    METHODS set_initial_status
      FOR DETERMINATION Travel~setInitialStatus
      IMPORTING keys FOR Travel.

    METHODS book_travel FOR MODIFY IMPORTING keys
                                               FOR ACTION travel~bookTravel RESULT result.

    METHODS get_features FOR FEATURES IMPORTING keys
      REQUEST requested_features FOR travel RESULT result.


ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD validateDates.

    READ ENTITY zcaa361_i_travel_sfh\\travel FROM VALUE #(
    FOR <root_key> IN keys
      ( %key     = <root_key>
        %control = VALUE #(
                      begin_date = if_abap_behv=>mk-on
                      end_date   = if_abap_behv=>mk-on ) ) )
    RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result INTO DATA(ls_travel_result).

      IF ls_travel_result-end_date < ls_travel_result-begin_date.

        APPEND VALUE #( %key = ls_travel_result-%key ) TO failed.

        APPEND VALUE #(
            %key     = ls_travel_result-%key
            %msg     = new_message(
                         id       = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgid
                         number   = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgno
                         v1       = ls_travel_result-begin_date
                         v2       = ls_travel_result-end_date
                         v3       = ls_travel_result-travel_id
                         severity = if_abap_behv_message=>severity-error )
            %element-begin_date = if_abap_behv=>mk-on
            %element-end_date   = if_abap_behv=>mk-on
          ) TO reported.


      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_initial_status.

    MODIFY ENTITIES OF zcaa361_i_travel_sfh IN LOCAL MODE
      ENTITY Travel
        UPDATE FROM VALUE #( FOR travel IN keys (
            %key            = travel-%key
            Status          = /dmo/if_flight_legacy=>travel_status-new
            %control-Status = if_abap_behv=>mk-on
          ) )
      REPORTED reported.

  ENDMETHOD.

  METHOD book_travel.

    MODIFY ENTITIES OF zcaa361_i_travel_sfh IN LOCAL MODE
      ENTITY travel
         UPDATE FROM VALUE #( FOR key IN keys
           ( travel_id       = key-travel_id
             status          = /dmo/if_flight_legacy=>travel_status-booked
             %control-status = if_abap_behv=>mk-on ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zcaa361_i_travel_sfh IN LOCAL MODE
    ENTITY Travel
       FROM VALUE #( FOR key IN keys
         ( travel_id = key-travel_id
           %control-Travel_ID       = if_abap_behv=>mk-on
           %control-agency_id       = if_abap_behv=>mk-on
           %control-customer_id     = if_abap_behv=>mk-on
           %control-begin_date      = if_abap_behv=>mk-on
           %control-end_date        = if_abap_behv=>mk-on
           %control-booking_fee     = if_abap_behv=>mk-on
           %control-total_price     = if_abap_behv=>mk-on
           %control-currency_code   = if_abap_behv=>mk-on
           %control-status          = if_abap_behv=>mk-on
           %control-description     = if_abap_behv=>mk-on
           %control-created_by      = if_abap_behv=>mk-on
           %control-created_at      = if_abap_behv=>mk-on
           %control-last_changed_by = if_abap_behv=>mk-on
           %control-last_changed_at = if_abap_behv=>mk-on
           ) )
     RESULT DATA(lt_travel_result).

    result = VALUE #( FOR ls_travel IN lt_travel_result
                      ( travel_id = ls_travel-Travel_ID
                        %param = CORRESPONDING #( ls_travel )
                     ) ).

  ENDMETHOD.


  METHOD get_features.

    READ ENTITY zcaa361_i_travel_sfh\\travel FROM VALUE #(
      FOR <root_key> IN keys
        ( %key     = <root_key>
          %control = VALUE #( Status  = if_abap_behv=>mk-on ) ) )
      RESULT DATA(lt_travel_result).


    result = VALUE #(
                FOR ls_travel IN lt_travel_result
                  LET lv_is_not_booked   =   COND #( WHEN ls_travel-status = 'B'
                                                       THEN if_abap_behv=>fc-o-disabled
                                                       ELSE if_abap_behv=>fc-o-enabled )
                      lv_is_travel_initial = COND #( WHEN ls_travel-travel_id IS INITIAL
                                                       THEN if_abap_behv=>fc-f-mandatory
                                                       ELSE if_abap_behv=>fc-f-read_only ) IN
                    ( %key                         = ls_travel-%key
                      %update                      = lv_is_not_booked
                      %field-Travel_ID             = lv_is_travel_initial
                      %features-%action-bookTravel = lv_is_not_booked
                ) ).

  ENDMETHOD.

ENDCLASS.
