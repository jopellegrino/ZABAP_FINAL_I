CLASS zcl_work_order_crud_test_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      test_create_work_order RETURNING VALUE(rv_create) TYPE abap_bool,
      test_read_work_order RETURNING VALUE(rv_read) TYPE ztwork_order_joh,
      test_update_work_order RETURNING VALUE(rv_update) TYPE String,
      test_delete_work_order RETURNING VALUE(rv_delete) TYPE abap_bool.

    DATA ls_ztwork_order_joh TYPE ztwork_order_joh.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_work_order_crud_test_joh IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


  ENDMETHOD.

  METHOD test_create_work_order.                                                "CREA UNA ORDEN DE TRABAJO

    DATA(lo_work_order_crud_handler) = NEW zclwork_order_crud_handler_joh(  ).  "INSTANCIA DE LA CLASE CRUD


    ls_ztwork_order_joh-customer_id     = 'CUST0003'.                           "DATOS DE LA ORDEN A CREAR
    ls_ztwork_order_joh-technician_id   = 'TECH0004'.
    ls_ztwork_order_joh-status          = 'PE'.
    ls_ztwork_order_joh-priority        = 'M'.
    ls_ztwork_order_joh-description     = 'REPARACION DE BOMBAS'.


    rv_create = lo_work_order_crud_handler->create_work_order(
                                         iv_customer_id_crud   = ls_ztwork_order_joh-customer_id
                                         iv_technician_id_crud = ls_ztwork_order_joh-technician_id
                                         iv_status_crud        = ls_ztwork_order_joh-status
                                         iv_priority_crud      = ls_ztwork_order_joh-priority
                                         iv_description        = ls_ztwork_order_joh-description    ).


  ENDMETHOD.

******************************************************************

  METHOD test_read_work_order.

    DATA(lo_work_order_crud_handler) = NEW zclwork_order_crud_handler_joh(  ).      "INSTANCIA DE LA CLASE CRUD

    DATA work_order_id TYPE zde_work_order_id_joh VALUE 0000000001.                 "VALOR DE work_order_id DEL REGISTRO QUE SE DESEA LEER

    rv_read = lo_work_order_crud_handler->read_work_order( iv_work_order_id_crud = work_order_id ).    "PASO DEL PARAMETRO AL METODO Y ASIGNA EL VALOR DE LA LECTURA A LA VARIABLE RESULTING

  ENDMETHOD.

******************************************************************

  METHOD test_update_work_order.

    DATA(lo_work_order_crud_handler) = NEW zclwork_order_crud_handler_joh(  ).      "INSTANCIA DE LA CLASE CRUD

    ls_ztwork_order_joh-work_order_id = 0000000001.                                 "MODIFICACION DE 'PE' A 'RJ'
    ls_ztwork_order_joh-status        = 'RJ'.

    DATA(rv_update_crud) = lo_work_order_crud_handler->update_work_order(           "METODO CRUD MODIFCA LOS DATOS DE STATUS PE A RJ
                             iv_work_order_id_crud = ls_ztwork_order_joh-work_order_id
                             iv_status_crud        = ls_ztwork_order_joh-status         ).

    IF rv_update_crud EQ abap_true.                                                 "RESPUESTA DEPENDIENDO DE SI SE EFECTUO LA MODIFICACION
      rv_update = 'ACTUALIZACION CORRECTA'.
    ELSE.
      rv_update = 'HUBO UN ERROR EN LA ACTUALIZACION'.
    ENDIF.
  ENDMETHOD.

******************************************************************

  METHOD test_delete_work_order.

    DATA(lo_work_order_crud_handler) = NEW zclwork_order_crud_handler_joh(  ).

    ls_ztwork_order_joh-work_order_id = 0000000003.

    rv_delete = lo_work_order_crud_handler->delete_work_order( iv_work_order_id_crud = ls_ztwork_order_joh-work_order_id ).


  ENDMETHOD.

ENDCLASS.
