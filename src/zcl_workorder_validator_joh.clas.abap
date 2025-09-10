CLASS zcl_workorder_validator_joh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    METHODS:
      validate_create_order IMPORTING iv_customer_id   TYPE zde_customer_id_joh
                                      iv_technician_id TYPE zde_technician_id_joh
                                      iv_priority      TYPE zde_priority_joh
                                      iv_status        TYPE zde_status_joh
                            RETURNING VALUE(rv_valid)  TYPE abap_bool,

      validate_update_order IMPORTING iv_work_order_id TYPE zde_work_order_id_joh
                                      iv_status        TYPE zde_status_joh
                            RETURNING VALUE(rv_valid)  TYPE abap_bool,

      validate_status_and_priority IMPORTING iv_v_status     TYPE zde_status_joh
                                             iv_v_priority   TYPE zde_priority_joh
                                   RETURNING VALUE(rv_valid) TYPE abap_bool,
      validate_delete_order IMPORTING iv_work_order_id TYPE zde_work_order_id_joh
                            RETURNING VALUE(rv_valid)  TYPE abap_bool.




  PROTECTED SECTION.

  PRIVATE SECTION.

    CONSTANTS: c_status_update_and_delete TYPE zde_status_joh VALUE 'PE'.

    METHODS: check_customer_exists IMPORTING iv_customer_id_exist TYPE zde_customer_id_joh
                            RETURNING VALUE(rv_exists)     TYPE abap_bool,

             check_technician_exists IMPORTING iv_technician_id_exist TYPE zde_technician_id_joh
                              RETURNING VALUE(rv_exists)       TYPE abap_bool.
ENDCLASS.



CLASS zcl_workorder_validator_joh IMPLEMENTATION.




  METHOD validate_create_order. "VERIFICA SI EL customer_id, technician_id EXISTE Y priority_code EXISTA EN LA TABLA ztpriority_joh.

*   """""VALIDATE CREATE ORDER

    DATA(lv_customer_exists) = check_customer_exists( iv_customer_id_exist = iv_customer_id ).

    IF lv_customer_exists EQ abap_false.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    DATA(lv_technician_exists) = check_technician_exists( iv_technician_id_exist = iv_technician_id ).
    IF lv_technician_exists EQ abap_false.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    DATA(lv_status_and_priority) = validate_status_and_priority( iv_v_status   = iv_status
                                                                 iv_v_priority = iv_priority    ).

    IF lv_status_and_priority EQ abap_false.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.


  METHOD check_customer_exists.             "VERIFICA SI EL customer_id EXISTE Y ESTA DENTRO DE ztcustomer_joh
    IF iv_customer_id_exist IS INITIAL.
      rv_exists = abap_false.
      RETURN.
    ELSE.
      rv_exists = abap_true.
    ENDIF.

    SELECT SINGLE FROM ztcustomer_joh
    FIELDS customer_id
    WHERE customer_id EQ @iv_customer_id_exist
    INTO @DATA(lv_customer_id).

    IF sy-subrc NE 0.
      rv_exists = abap_false.
      RETURN.
    ENDIF.
    rv_exists = abap_true.

  ENDMETHOD.

  METHOD check_technician_exists.           "VERIFICA SI EL technician_id EXISTE Y QUE ESTA EN LA TABLA zttechnician_joh
    IF iv_technician_id_exist IS INITIAL.
      rv_exists = abap_false.
      RETURN.
    ELSE.
      rv_exists = abap_true.
    ENDIF.

    SELECT SINGLE FROM zttechnician_joh
    FIELDS technician_id
    WHERE technician_id EQ @iv_technician_id_exist
    INTO @DATA(lv_tech_id).

    IF sy-subrc NE 0.
      rv_exists = abap_false.
      RETURN.
    ENDIF.
    rv_exists = abap_true.

  ENDMETHOD.



*   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  METHOD validate_status_and_priority.  "VALIDA QUE priority Y status ESTE EN LOS VALORES PERMITIDOS ztpriority_joh Y ztstatus_joh

    SELECT SINGLE FROM ztpriority_joh   "VALIDA PRIORIDAD
    FIELDS priority_code
    WHERE priority_code EQ @iv_v_priority
    INTO @DATA(ls_priority).

    IF sy-subrc NE 0.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    SELECT SINGLE FROM ztstatus_joh     "VALIDA STATUS
    FIELDS status_code
    WHERE status_code EQ @iv_v_status
    INTO @DATA(ls_status).

    IF sy-subrc NE 0.
      rv_valid = abap_false.
      RETURN.
    ENDIF.
    rv_valid = abap_true.

  ENDMETHOD.

*   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  METHOD validate_update_order.

    """""VALIDATE UPDATE ORDER

    SELECT SINGLE FROM ztwork_order_joh             "VERIFICA QUE LA WORKORDER ESTA EN ztwork_order_joh y EL STATUS TIENE VALOR DE 'PE'
    FIELDS work_order_id
    WHERE work_order_id EQ @iv_work_order_id
      AND status EQ @c_status_update_and_delete
    INTO @DATA(lv_wo_exist).

    IF sy-subrc NE 0.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.


*   """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



  METHOD validate_delete_order.

    """""VALIDA ELIMINATE ORDER

    SELECT SINGLE FROM ztwork_order_joh             "VALIDA QUE EL status EN ztwork_order_joh ES 'PE'
    FIELDS work_order_id
    WHERE work_order_id EQ @iv_work_order_id
    AND status EQ @c_status_update_and_delete
    INTO @DATA(lv_status_valid).

    IF sy-subrc NE 0.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    SELECT SINGLE FROM ztworkorder_hist             "VALIDA QUE LA work_order_id NO TENGA MODIFICACIONES EN ztworkorder_hist
    FIELDS work_order_id
    WHERE work_order_id EQ @iv_work_order_id
    INTO @DATA(lv_hist_valid).

    IF sy-subrc EQ 0.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    rv_valid = abap_true.



  ENDMETHOD.

ENDCLASS.
