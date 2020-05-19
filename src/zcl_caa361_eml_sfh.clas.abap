CLASS zcl_caa361_eml_sfh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_caa361_eml_sfh IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    SELECT SINGLE FROM /dmo/flight
      FIELDS carrier_id, connection_id, flight_date
      INTO @DATA(ls_flight).

    READ ENTITIES OF zcaa361_i_travel_sfh
      ENTITY travel
      BY \_Booking
      FROM VALUE #( ( Travel_ID = '1337' ) )
      RESULT DATA(lt_bookings).

    MODIFY ENTITIES OF zcaa361_i_travel_sfh
      ENTITY travel
      UPDATE FROM VALUE
        #( ( travel_id            = '1337'
             description          = 'I like ABAP'
             %control-description = if_abap_behv=>mk-on ) )

             CREATE BY \_booking
              FROM VALUE
                #( (
                  travel_id = '1337'
                  %target   = VALUE #(
                  (
                     booking_id    = VALUE #( lt_bookings[ lines( lt_bookings ) ]-booking_id OPTIONAL ) + 1
                     booking_date  = cl_abap_context_info=>get_system_date( )
                     carrier_id    = ls_flight-carrier_id
                     connection_id = ls_flight-connection_id
                     flight_date   = ls_flight-flight_date
                     Customer_ID   = '4'
                      %control     = VALUE #( booking_id    = if_abap_behv=>mk-on
                                              booking_date  = if_abap_behv=>mk-on
                                              carrier_id    = if_abap_behv=>mk-on
                                              connection_id = if_abap_behv=>mk-on
                                              flight_date   = if_abap_behv=>mk-on
                                              Customer_ID   = if_abap_behv=>mk-on )
                      ) )
                  ) )
    failed data(ls_failed)
    reported data(ls_reported).

    COMMIT ENTITIES
    RESPONSE OF zcaa361_i_travel_sfh
        FAILED     DATA(ls_failed_commit)
        REPORTED   DATA(ls_reported_commit).

  ENDMETHOD.

ENDCLASS.
