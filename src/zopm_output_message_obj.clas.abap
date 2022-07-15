CLASS zopm_output_message_obj DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES t_medium_type TYPE nast-nacha .

    CONSTANTS:
      BEGIN OF c_medium_types,
        print_output     TYPE t_medium_type VALUE '1',
        fax              TYPE t_medium_type VALUE '2',
        telex            TYPE t_medium_type VALUE '4',
        external_send    TYPE t_medium_type VALUE '5',
        edi              TYPE t_medium_type VALUE '6',
        simple_mail      TYPE t_medium_type VALUE '7',
        special_function TYPE t_medium_type VALUE '8',
        workflow_event   TYPE t_medium_type VALUE '9',
        ale_distribution TYPE t_medium_type VALUE 'A',
        workflow_task    TYPE t_medium_type VALUE 'T',
      END OF c_medium_types .

    METHODS constructor
      IMPORTING
        !output_message    TYPE nast
        !output_program TYPE tnapr.

    METHODS process
      IMPORTING
        !dialog_ind TYPE abap_bool
      RAISING
        zcx_return3 .

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA m_output_message TYPE nast .
    DATA m_output_program TYPE tnapr .

    METHODS _process_print_output
      IMPORTING
        !dialog_ind        TYPE abap_bool
      RETURNING
        VALUE(pdf_content) TYPE fpcontent .
    METHODS _process_external_send .
ENDCLASS.

CLASS zopm_output_message_obj IMPLEMENTATION.

  METHOD constructor.

    me->m_output_message = output_message.
    me->m_output_program = output_program.

  ENDMETHOD.

  METHOD process.

    DATA lx_return3 TYPE REF TO zcx_return3.
    DATA lx_root TYPE REF TO cx_root.

    TRY.

        DATA(business_object) =
          zbo_business_object_factory=>get_factory(
            )->get_business_object_by_appl(
              message_application = me->m_output_message-kappl
              message_object_key  = me->m_output_message-objky ).

        "Medium type
        CASE me->m_output_message-nacha.

          WHEN c_medium_types-print_output.

            DATA process_print_output TYPE REF TO zopm_outp_print_output_i.

            process_print_output ?= business_object.

            process_print_output->execute(
              dialog_ind       = dialog_ind
              output_message   = me->m_output_message
              output_program   = me->m_output_program ).

          WHEN c_medium_types-external_send.

            DATA process_external_send TYPE REF TO zopm_outp_external_send_i.

            process_external_send ?= business_object.

            process_external_send->execute(
              output_message   = me->m_output_message
              output_program   = me->m_output_program ).

          WHEN OTHERS.

            DATA lv_dummy TYPE string.

            "Medium &1 is not supported.
            MESSAGE e004
              WITH me->m_output_message-nacha
              INTO lv_dummy.

            CREATE OBJECT lx_return3.
            lx_return3->add_system_message( ).
            RAISE EXCEPTION lx_return3.

        ENDCASE.

      CATCH zcx_return3 INTO lx_return3.

        RAISE EXCEPTION lx_return3.

      CATCH cx_root INTO lx_root.

        CREATE OBJECT lx_return3.
        lx_return3->add_exception_object( lx_root ).
        RAISE EXCEPTION lx_return3.

    ENDTRY.

  ENDMETHOD.


  METHOD _process_external_send.

*    "--------------------------------------
*    "Read data
*    "--------------------------------------
*    DATA ls_doc_read_data TYPE gts_doc_read_data.
*
*    ls_doc_read_data = me->gs_data.
*
*    "--------------------------------------
*    "Set language
*    "--------------------------------------
*    IF nast-tdspras IS NOT INITIAL.
*      ls_doc_read_data-header-vendor_language_id = nast-tdspras.
*    ENDIF.
*
*    "--------------------------------------
*    "Create email
*    "--------------------------------------
*    DATA ls_email_data TYPE zeml_email_bo=>gts_data.
*
*    ls_email_data = _email_set_attributes( ls_doc_read_data ).
*
*    "--------------------------------------
*    "Set email data
*    "--------------------------------------
*    DATA ls_email_text_data TYPE gts_email_text_data.
*
*    _email_get_text(
*      EXPORTING
*        is_doc_read_data  = ls_doc_read_data
*      CHANGING
*        cs_email_text_data = ls_email_text_data
*        cr_text_data       = ls_email_data-email_data ).
*
*    "-----------------------------------------------------
*    "Add PDF file
*    DATA ls_attachment TYPE zeml_email_bo=>gts_attachment.
*
*    ls_attachment =
*      _email_add_pdf_file(
*        nast             = nast
*        tnapr            = tnapr
*        is_doc_read_data = ls_doc_read_data ).
*
*    APPEND ls_attachment TO ls_email_data-attachments.
*
*    "-----------------------------------------------------
*    "Add CSV file
*    ls_attachment = _email_add_csv_file( ls_doc_read_data ).
*
*    APPEND ls_attachment TO ls_email_data-attachments.
*
*    "-----------------------------------------------------
*    "Add BAM flexplein logo picture
*    ls_attachment = _email_add_logo_picture( ).
*
*    APPEND ls_attachment TO ls_email_data-attachments.
*
*    "--------------------------------------
*    "Send email
*    "--------------------------------------
*    DATA lo_email_bo TYPE REF TO zeml_email_bo.
*
*    lo_email_bo =
*      zeml_email_bo_ft=>get_factory(
*        )->create_email(
*          ls_email_data ).
*
*    lo_email_bo->send( ).

  ENDMETHOD.


  METHOD _process_print_output.

*    DATA ls_doc_read_data TYPE gts_doc_read_data.
*
*    ls_doc_read_data = me->gs_data.
*
*    IF nast-tdspras IS NOT INITIAL.
*      ls_doc_read_data-header-vendor_language_id = nast-tdspras.
*    ENDIF.
*
*    DATA lv_no_dialog_ind TYPE abap_bool.
*    IF dialog_ind = abap_false.
*      lv_no_dialog_ind = abap_true.
*    ENDIF.
*
*    rv_pdf_content = _doc_create_pdf_document(
*      nast             = nast
*      tnapr            = tnapr
*      iv_no_dialog_ind = lv_no_dialog_ind
*      is_doc_data_read = ls_doc_read_data ).

  ENDMETHOD.
ENDCLASS.
