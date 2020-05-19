@AbapCatalog.sqlViewName: 'ZCAA361ITRASFH'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel'
@AbapCatalog.preserveKey: true
define root view ZCAA361_I_Travel_SFH
  as select from zcaa361_tra_sfh                as Travel  
  
  composition [0..*] of ZCAA361_I_Booking_SFH   as _Booking
  association [0..1] to /DMO/I_Agency           as _Agency   on $projection.Agency_ID = _Agency.AgencyID
  association [0..1] to /DMO/I_Customer         as _Customer on $projection.Customer_ID = _Customer.CustomerID
  association [0..1] to I_Currency              as _Currency on $projection.Currency_Code = _Currency.Currency
{
  key travel_id       as Travel_ID,
      agency_id       as Agency_ID,
      customer_id     as Customer_ID,
      begin_date      as Begin_Date,
      end_date        as End_Date,
      @Semantics.amount.currencyCode: 'Currency_Code'
      booking_fee     as Booking_Fee,
      @Semantics.amount.currencyCode: 'Currency_Code'
      total_price     as Total_Price,
      @Semantics.currencyCode: true
      currency_code   as Currency_Code,
      status          as Status,
      description     as Description,
      @Semantics.user.createdBy: true
      created_by      as Created_By,
      @Semantics.systemDateTime.createdAt: true
      created_at      as Created_At,
      @Semantics.user.lastChangedBy: true
      last_changed_by as Last_Changed_By,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as Last_Changed_At,      
      
      /* Associations */
      _Booking,
      _Agency,
      _Customer,
      _Currency
}
