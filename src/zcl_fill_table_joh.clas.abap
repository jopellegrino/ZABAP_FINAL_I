CLASS zcl_fill_table_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_fill_table_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    "LLENAR TABLA DE CAMPOS STATUS Y PRIORITY

    DELETE FROM ztstatus_joh.

    MODIFY ztstatus_joh FROM TABLE @( VALUE #( ( status_code        = 'PE'
                                                 status_description = 'Estatus Pendiente' )
                                               ( status_code        = 'CO'
                                                 status_description = 'Estatus Completed' )
                                               ( status_code        = 'CL'
                                                 status_description = 'Estatus Closed' )
                                               ( status_code        = 'AP'
                                                 status_description = 'Estatus Approved' )
                                               ( status_code        = 'RJ'
                                                 status_description = 'Estatus Rejected' )  ) ).

    DELETE FROM ztpriority_joh.
    MODIFY ztpriority_joh FROM TABLE @( VALUE #( ( priority_code        = 'H'
                                                   priority_description = 'Priority High' )
                                                 ( priority_code        = 'M'
                                                   priority_description = 'Priority Medium' )
                                                 ( priority_code        = 'L'
                                                   priority_description = 'Priority Low' ) ) ).

*   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    "LLENAR CAMPOS DE ztcustomer_joh

    DELETE FROM ztcustomer_joh.
    MODIFY ztcustomer_joh FROM TABLE @(  VALUE #( ( customer_id = 'CUST0001'
                                                    name        = 'Laura Martínez'
                                                    address     = 'Calle Sol 123, Valencia'
                                                    phone       = '+34 600 123 456'             )
                                                  ( customer_id = 'CUST0002'
                                                    name        = 'Carlos Gómez'
                                                    address     = 'Av. Mar 45, Cullera'
                                                    phone       = '+34 600 654 321'             )
                                                  ( customer_id = 'CUST0003'
                                                    name        = 'Sofía Ruiz'
                                                    address     = 'Plaza Luna 9, Gandía'
                                                    phone       = '+34 600 789 123'              )
                                                  ( customer_id = 'CUST0004'
                                                    name        = 'Miguel Torres'
                                                    address     = 'Calle Río 12, Alzira'
                                                    phone       = '+34 600 321 987'             )
                                                  ( customer_id = 'CUST0005'
                                                    name        = 'Ana Beltrán'
                                                    address     = 'Av. Naranja 88, Xàtiva'
                                                    phone       = '+34 600 456 789'              )
                                                  ( customer_id = 'CUST0006'
                                                    name        = 'David Navarro'
                                                    address     = 'Calle Olivo 7, Ontinyent'
                                                    phone       = '+34 600 987 654'             )
                                                  ( customer_id = 'CUST0007'
                                                    name        = 'Isabel Ferrer'
                                                    address     = 'Plaza Mayor 1, Gandía'
                                                    phone       = '+34 600 111 222'             )
                                                  ( customer_id = 'CUST0008'
                                                    name        = 'Jorge Molina'
                                                    address     = 'Av. Mediterráneo 33, Cullera'
                                                    phone       = '+34 600 333 444'              )
                                                  ( customer_id = 'CUST0009'
                                                    name        = 'Beatriz Sánchez'
                                                    address     = 'Calle Arena 5, Valencia'
                                                    phone       = '+34 600 555 666'              )
                                                  ( customer_id = 'CUST0010'
                                                    name        = 'Luis Ortega'
                                                    address     = 'Camino Real 20, Sueca'
                                                    phone       = '+34 600 777 888'              ) ) ).

*   """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    "LLENAR DE DATOS ZTTECHNICIAN_JOH

    DELETE FROM zttechnician_joh.
    MODIFY zttechnician_joh FROM TABLE @(  VALUE #( ( technician_id = 'TECH0001'
                                                    name           = 'Laura Sánchez'
                                                    specialty      = 'Redes y cableado'    )

                                                  ( technician_id = 'TECH0002'
                                                    name           = 'Carlos Díaz'
                                                    specialty      = 'Soporte técnico'     )

                                                  ( technician_id = 'TECH0003'
                                                    name           = 'Sofía Romero'
                                                    specialty      = 'Seg. informática'    )

                                                  ( technician_id = 'TECH0004'
                                                    name           = 'Miguel Torres'
                                                    specialty      = 'Manten. de hardware' )

                                                  ( technician_id = 'TECH0005'
                                                    name           = 'Ana Beltrán'
                                                    specialty      = 'Instal. de software' )

                                                  ( technician_id = 'TECH0007'
                                                    name           = 'Isabel Ferrer'
                                                    specialty      = 'Bases de datos'      )

                                                  ( technician_id = 'TECH0008'
                                                    name           = 'Jorge Molina'
                                                    specialty      = 'Cloud computing'     )

                                                  ( technician_id = 'TECH0009'
                                                    name           = 'Beatriz Sánchez'
                                                    specialty      = 'Electrónica digital' )

                                                  ( technician_id = 'TECH0010'
                                                    name           = 'Luis Ortega'
                                                    specialty      = 'Automat. industrial' )  ) ).


    "VALORES DE PRUEBA """"CREATE ORDER""""

    DATA ls_ztwork_order_joh TYPE ztwork_order_joh.

*    ls_ztwork_order_joh-work_order_id
*    ls_ztwork_order_joh-customer_id =
*    ls_ztwork_order_joh-technician_id
*    ls_ztwork_order_joh-creation_date
*    ls_ztwork_order_joh-status
*    ls_ztwork_order_joh-priority
*    ls_ztwork_order_joh-description




  ENDMETHOD.
ENDCLASS.
