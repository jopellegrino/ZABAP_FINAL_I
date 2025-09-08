CLASS zcl_test_values DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_test_values IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA(lo_work_order_crud_handler) = NEW zclwork_order_crud_handler_joh(  ). "INSTANCIA DE LA CLASE ENCARGADA DEL CRUD


    "VALORES DE PRUEBA """"CREATE ORDER""""

    DATA ls_ztwork_order_joh TYPE ztwork_order_joh.


*    ls_ztwork_order_joh-customer_id     = 'CUST0003'.
*    ls_ztwork_order_joh-technician_id   = 'TECH0004'.
*    ls_ztwork_order_joh-status          = 'CO'.
*    ls_ztwork_order_joh-priority        = 'M'.
*    ls_ztwork_order_joh-description     = 'Se necesita a un analista'.
*
*    DATA(rv_crud) = lo_work_order_crud_handler->create_work_order(  iv_customer_id_crud   = ls_ztwork_order_joh-customer_id
*                                                                    iv_technician_id_crud = ls_ztwork_order_joh-technician_id
*                                                                    iv_status_crud        = ls_ztwork_order_joh-status
*                                                                    iv_priority_crud      = ls_ztwork_order_joh-priority
*                                                                    iv_description        = ls_ztwork_order_joh-description ).
*    IF rv_crud EQ abap_true.
*      out->write( 'Se ha creado la orden correctamente' ).
*    ELSE.
*      out->write( 'Existe un error en los parametros ingresados y la orden no ha sido creada' ).
*    ENDIF.

    DATA(workorder_validator) = NEW zcl_workorder_validator_joh(  ).

*    DATA(lo_check_customer_exists) = workorder_validator->check_customer_exists( iv_customer_id_exist = 'CUST0001' ).
*

*    DATA(lo_check_customer_exists) = workorder_validator->check_technician_exists( iv_technician_id_exist = 'TECH0001' ).
*

*    DATA(lo_check_customer_exists) = workorder_validator->validate_status_and_priority(
*                                       iv_v_status   = 'RJ'
*                                       iv_v_priority = 'P'
*                                     ).


*    DATA(lo_check_customer_exists) = workorder_validator->validate_create_order(
*                                       iv_customer_id   = 'CUST0001'
*                                       iv_technician_id = 'TECH0004'
*                                       iv_priority      = 'M'
*                                       iv_status        = 'AP'
*                                     ).
*
*    IF lo_check_customer_exists EQ abap_true.
*      out->write( 'VALOR CORRECTO' ).
*    ELSE.
*      out->write( 'VALOR INCORRECTO' ).
*    ENDIF.
    ls_ztwork_order_joh-work_order_id = '0000000008'.
    ls_ztwork_order_joh-status = 'AP'.


    DATA(rv_update) = lo_work_order_crud_handler->validate_update_order(  iv_work_order_id_crud = ls_ztwork_order_joh-work_order_id
                                                                          iv_status_crud        = ls_ztwork_order_joh-status
                                                                              ).



    IF rv_update EQ abap_true.
      out->write( 'VALOR CORRECTO' ).
    ELSE.
      out->write( 'VALOR INCORRECTO' ).
    ENDIF.


  ENDMETHOD.

ENDCLASS.
