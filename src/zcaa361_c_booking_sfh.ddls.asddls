@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
@EndUserText.label: 'SFH: Booking Consumption View'

@UI: {
  headerInfo: { typeName: 'Booking',
                typeNamePlural: 'Bookings',
                title: { type: #STANDARD, value: 'BookingID' } } }

define view entity ZCAA361_C_Booking_SFH 

  as projection on ZCAA361_I_Booking_SFH {
  
    @UI.facet: [ { id:            'Booking',
                 purpose:       #STANDARD,
                 type:          #IDENTIFICATION_REFERENCE,
                 label:         'Booking',
                 position:      10 } ]
  
      @Search.defaultSearchElement: true
  key Travel_ID       as TravelID,
  
      @Search.defaultSearchElement: true
      @UI: { lineItem:       [ { position: 20, importance: #HIGH } ],
         identification: [ { position: 20 } ] }
  key Booking_ID      as BookingID,
  
      @UI: { lineItem:       [ { position: 30, importance: #HIGH } ],
             identification: [ { position: 30 } ] }
      Booking_Date    as BookingDate,
      
      @Search.defaultSearchElement: true
        @UI: { lineItem:       [ { position: 40, importance: #HIGH } ],
         identification: [ { position: 40 } ] }
      @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Customer', element: 'CustomerID' }}]
      Customer_ID     as CustomerID,
      
      @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Carrier', element: 'AirlineID' }}]
      @ObjectModel.text.element: ['CarrierName']
      @UI: { lineItem:       [ { position: 50, importance: #HIGH } ],
         identification: [ { position: 50 } ] }
      Carrier_ID      as CarrierID,
      
      _Carrier.Name   as CarrierName,
      
      @UI: { lineItem:       [ { position: 60, importance: #HIGH } ],
             identification: [ { position: 60 } ] }
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 'ConnectionID'},
                                           additionalBinding: [ { localElement: 'FlightDate',   element: 'FlightDate'},
                                                                { localElement: 'CarrierID',    element: 'AirlineID'},
                                                                { localElement: 'FlightPrice',  element: 'Price'},
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode' } ] } ]
      Connection_ID   as ConnectionID,
      
      @UI: { lineItem:       [ { position: 70, importance: #HIGH } ],
             identification: [ { position: 70 } ] }
      @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 'FlightDate' },
                                           additionalBinding: [ { localElement: 'ConnectionID', element: 'ConnectionID'},
                                                                { localElement: 'CarrierID',    element: 'AirlineID'},
                                                                { localElement: 'FlightPrice',  element: 'Price' },
                                                                { localElement: 'CurrencyCode', element: 'CurrencyCode' }]}]
      Flight_Date     as FlightDate,
      
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI: { lineItem:       [ { position: 80, importance: #HIGH } ],
         identification: [ { position: 80 } ] }
      Flight_Price    as FlightPrice,
      
       @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }}]
      Currency_Code   as CurrencyCode,
      
      @UI.hidden: true
      Last_Changed_At as LastChangedAt, -- Take over from parent
      
      /* Associations */
      _Travel : redirected to parent ZCAA361_C_Travel_SFH, 
      _Customer,
      _Carrier 
}

