CLASS unit_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS print_output_to_screen ."FOR TESTING. "Must be executed in SAP GUI
    METHODS external_send          FOR TESTING.

    METHODS _get_nast
      IMPORTING sales_order_no TYPE vbak-vbeln
      RETURNING VALUE(nast)    TYPE nast.

    METHODS _get_tnapr
      RETURNING VALUE(tnapr) TYPE tnapr.

    METHODS _get_last_sales_order_no
      RETURNING VALUE(sales_order_no) TYPE zsd_sales_order_bo_i=>t_sales_order_no.

ENDCLASS.

CLASS unit_test IMPLEMENTATION.

  METHOD print_output_to_screen.

    TRY.

        DATA(sales_order_no) = me->_get_last_sales_order_no( ).

        DATA(nast) = me->_get_nast( sales_order_no ).

        DATA(tnapr) = me->_get_tnapr( ).

        DATA return_code TYPE syst-subrc.

        DATA(output_message) = NEW zopm_output_message_obj(
          output_message  = nast
          output_program  = tnapr ).

        output_message->process(
          dialog_ind  = abap_true ).

      CATCH cx_root INTO DATA(root_exc).

        cl_abap_unit_assert=>fail(
            msg    = root_exc->get_text( )
            detail = root_exc->get_longtext( ) ).

    ENDTRY.

  ENDMETHOD.

  METHOD external_send.

    TRY.

        DATA(sales_order_no) = me->_get_last_sales_order_no( ).

        DATA(nast) = me->_get_nast( sales_order_no ).

        nast-nacha = zopm_output_message_obj=>c_medium_types-external_send.

        DATA(tnapr) = me->_get_tnapr( ).

        DATA return_code TYPE syst-subrc.

        DATA(output_message) = NEW zopm_output_message_obj(
          output_message  = nast
          output_program  = tnapr ).

        output_message->process(
          dialog_ind  = abap_true ).

      CATCH cx_root INTO DATA(root_exc).

        cl_abap_unit_assert=>fail(
            msg    = root_exc->get_text( )
            detail = root_exc->get_longtext( ) ).

    ENDTRY.

  ENDMETHOD.

  METHOD _get_nast.

    nast-mandt    = sy-mandt.
    nast-kappl    = zbo_business_object_factory=>c_message_applications-sales_order. "'V1'
    nast-objky    = sales_order_no.
    nast-kschl    = 'ZSD1'.
    nast-spras    = 'E'.
*    nast-parnr  = 9002503.
*    nast-parvw  = 'LF'.
    nast-nacha    = zopm_output_message_obj=>c_medium_types-print_output.     "'1'
    nast-anzal    = 1.
    nast-vsztp    = 3.
    nast-manue    = 'X'.
    nast-ldest    = 'LP01'.
    nast-dimme    = 'X'.
    nast-tdid     = 'BEWG'.
    nast-tdspras  = 'E'.
    nast-tdarmod  = 1.
    nast-objtype  = zbo_business_object_factory=>c_bor_names-sales_order.  "''PR_SLSORD''

  ENDMETHOD.

  METHOD _get_tnapr.

    "tnapr-pgnam = 'RM08NAST'.
    "tnapr-ronam = 'ENTRY_ERS_PDF'.
    tnapr-sform = 'ZSD_SALES_ORDER'.
    tnapr-nacha = 1.

  ENDMETHOD.

  METHOD _get_last_sales_order_no.

    SELECT vbeln
      FROM vbak
      ORDER BY
        erdat DESCENDING,
        erzet DESCENDING,
        vbeln DESCENDING
      INTO TABLE @DATA(sales_orders)
      UP TO 1 ROWS.

    cl_abap_unit_assert=>assert_subrc(
      exp = 0
      act = sy-subrc ).

    sales_order_no = sales_orders[ 1 ].

  ENDMETHOD.

ENDCLASS.
