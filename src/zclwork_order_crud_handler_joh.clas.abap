CLASS zclwork_order_crud_handler_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      create_work_order IMPORTING iv_customer_id_crud   TYPE zde_customer_id_joh
                                  iv_technician_id_crud TYPE zde_technician_id_joh
                                  iv_status_crud        TYPE zde_status_joh
                                  iv_priority_crud      TYPE zde_priority_joh
                                  iv_description        TYPE zde_description_joh
                        RETURNING VALUE(rv_valid_crud)  TYPE abap_bool,
      update_work_order IMPORTING iv_work_order_id_crud TYPE zde_work_order_id_joh
                                  iv_status_crud        TYPE zde_status_joh
                        RETURNING VALUE(rv_valid)       TYPE abap_bool,
      delete_work_order IMPORTING iv_work_order_id_crud TYPE zde_work_order_id_joh
                        RETURNING VALUE(rv_valid)       TYPE abap_bool,
      read_work_order IMPORTING iv_work_order_id_crud TYPE zde_work_order_id_joh
                      RETURNING VALUE(rv_valid)       TYPE ztwork_order_joh.


  PROTECTED SECTION.

  PRIVATE SECTION.

    METHODS: update_workorder_hist IMPORTING iv_work_order_id_hist TYPE zde_work_order_id_joh
                                             iv_status_hist        TYPE zde_status_joh
                                   RETURNING VALUE(rv_valid_hist)  TYPE abap_bool.



ENDCLASS.

CLASS zclwork_order_crud_handler_joh IMPLEMENTATION.

******************************************************************************************
  METHOD create_work_order.     "OPERACION DE CREATE EN ztwork_order_joh

    DATA(lo_workorder_validator) = NEW zcl_workorder_validator_joh(  ).                                     "INSTANCIA VALIDACION DE CAMPOS A SER INSERTADOS

    DATA(rv_validate_create_order) = lo_workorder_validator->validate_create_order(                         "VALIDA LOS VALORE DE customer_id, technician_id, priority Y status
                                     EXPORTING iv_customer_id   = iv_customer_id_crud
                                               iv_technician_id = iv_technician_id_crud
                                               iv_priority      = iv_priority_crud
                                               iv_status        = iv_status_crud          ).

    IF rv_validate_create_order EQ abap_true.

      SELECT FROM ztwork_order_joh          "OBTIENE LA WORK_ORDER MAXIMA PARA NO REPETIRLA
      FIELDS MAX( work_order_id )
      INTO @DATA(lv_max_wo).

      lv_max_wo = lv_max_wo + 1.

      INSERT ztwork_order_joh FROM TABLE @( VALUE #( ( work_order_id = lv_max_wo                      "INSERTA LOS VALORES VALIDADOS
                                                       customer_id   = iv_customer_id_crud
                                                       technician_id = iv_technician_id_crud
                                                       creation_date = cl_abap_context_info=>get_system_date( )
                                                       status        = iv_status_crud
                                                       priority      = iv_priority_crud
                                                       description   = iv_description     )  ) ).

      IF sy-subrc EQ 0.                     "VERIFICACION DE INSERT CORRECTO
        rv_valid_crud = abap_true.
      ELSE.
        rv_valid_crud = abap_false.
        RETURN.
      ENDIF.
    ELSE.
      rv_valid_crud = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.


******************************************************************************************
  METHOD update_work_order.             "OPERACION DE UPDATE EN ztwork_order_joh

    DATA(lo_workorder_validator) = NEW zcl_workorder_validator_joh(  ).

    DATA(rv_workorder_validator) = lo_workorder_validator->validate_update_order( iv_work_order_id = iv_work_order_id_crud
                                                                                  iv_status        = iv_status_crud           ).

    IF rv_workorder_validator EQ abap_true.

      SELECT SINGLE FROM ztstatus_joh        "VALIDA STATUS ESTA EN ztstatus_joh
      FIELDS status_code
      WHERE status_code EQ @iv_status_crud
      INTO @DATA(ls_status).

      IF sy-subrc NE 0.
        rv_valid = abap_false.
        RETURN.
      ELSE.

        UPDATE ztwork_order_joh              "ACTUALIZA EL STATUS DEL REGISTRO
                SET status          = @iv_status_crud
                WHERE work_order_id EQ @iv_work_order_id_crud.

        IF sy-subrc EQ 0.
          rv_valid = abap_true.
        ELSE.
          rv_valid = abap_false.
          RETURN.
        ENDIF.

      ENDIF.

      rv_valid = abap_true.

    ELSE.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    DATA(rv_update_workorder_hist) = update_workorder_hist( iv_status_hist        = iv_status_crud
                                                            iv_work_order_id_hist = iv_work_order_id_crud                                 ).

    IF rv_update_workorder_hist EQ abap_true.
      rv_valid = abap_true.
    ELSE.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.


******************************************************************************************
  METHOD update_workorder_hist.         "INSERTA UN REGISTRO EN ztworkorder_hist, POR CADA MODIFICACION REALIZADA EN ztwork_order_joh

    SELECT FROM ztworkorder_hist        "VERIFICA EL HIST MAXIMO, PARA NO REPETIR history_id
    FIELDS MAX( history_id )
    INTO @DATA(lv_max_history_id).

    lv_max_history_id = lv_max_history_id + 1.

    CASE iv_status_hist.                                "ELIGE LA change_description EN ztworkorder_hist DEPENDIENDO DEL ESTADO MODIFICADO
      WHEN 'PE'.
        rv_valid_hist = abap_false.
        RETURN.
      WHEN 'CO'.
        DATA(lv_change_descripcion) = 'Status has changed from PENDING to COMPLETED'.
      WHEN 'CL'.
        lv_change_descripcion = 'Status has changed from PENDING to CLOSED'.
      WHEN 'AP'.
        lv_change_descripcion = 'Status has changed from PENDING to APPROVED'.
      WHEN 'RJ'.
        lv_change_descripcion = 'Status has changed from PENDING to REJECTED'.
    ENDCASE.

    INSERT ztworkorder_hist FROM @( VALUE #( history_id         = lv_max_history_id                                     "INSERTA EN ztworkorder_hist EL CAMBIO REALIZADO
                                             work_order_id      = iv_work_order_id_hist
                                             modification_date  = cl_abap_context_info=>get_system_date(  )
                                             change_description = lv_change_descripcion                            ) ).
    IF sy-subrc EQ 0.
      rv_valid_hist = abap_true.
    ELSE.
      rv_valid_hist = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.


******************************************************************************************
  METHOD delete_work_order.

    DATA(lo_workorder_validator) = NEW zcl_workorder_validator_joh(  ).

    DATA(rv_validate_delete_order) = lo_workorder_validator->validate_delete_order( iv_work_order_id = iv_work_order_id_crud  ).

    IF rv_validate_delete_order EQ abap_true.

      DELETE FROM ztwork_order_joh WHERE work_order_id EQ @iv_work_order_id_crud.

      IF sy-subrc EQ 0.
        rv_valid = abap_true.
      ELSE.
        rv_valid = abap_false.
        RETURN.
      ENDIF.

    ELSE.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.

******************************************************************************************
  METHOD read_work_order.

    SELECT SINGLE FROM ztwork_order_joh
    FIELDS *
    WHERE work_order_id EQ @iv_work_order_id_crud
    INTO @DATA(ls_read_work_order).

    IF sy-subrc EQ 0.
      rv_valid = ls_read_work_order.
    ELSE.
      CLEAR rv_valid.
      RETURN.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
