CLASS zcaa361_gen_data_sfh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcaa361_gen_data_sfh IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zcaa361_tra_sfh.
    INSERT zcaa361_tra_sfh FROM ( SELECT FROM /dmo/travel FIELDS * ).
    out->write( 'ZCAA361_TRA_SFH'  ).

    DELETE FROM zcaa361_book_sfh.
    INSERT zcaa361_book_sfh FROM ( SELECT FROM /dmo/booking FIELDS * ).
    out->write( 'ZCAA361_BOOK_SFH'  ).
  ENDMETHOD.

ENDCLASS.
