*&---------------------------------------------------------------------*
*& Report ZOPM_PROCESS_MESSAGE_PRC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zopm_process_message_prc.

TABLES:
  nast,
  tnapr.

FORM entry_pdf
  USING
    retcode LIKE sy-subrc
    xscreen LIKE boole-boole.

  DATA lx_return3 TYPE REF TO zcx_return3.

  TRY.

      DATA(output_message) = NEW zopm_output_message_obj(
        output_message = nast
        output_program = tnapr ).

      output_message->process(
        dialog_ind  = xscreen ).

      retcode = 0.

    CATCH zcx_return3 INTO lx_return3.

      PERFORM handle_errors
        USING lx_return3
              xscreen.

  ENDTRY.

ENDFORM.                    "ENTRY_ERS_PDF

*&---------------------------------------------------------------------*
*&      Form  handle_errors
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->LX_RETURN3 text
*      -->XSCREEN    text
*----------------------------------------------------------------------*
FORM handle_errors
  USING
    lx_return3 TYPE REF TO zcx_return3
    xscreen    TYPE boole-boole.

  DATA lt_bapiret2_table TYPE bapiret2_t.

  lt_bapiret2_table = lx_return3->get_bapiret2_table( ).

  FIELD-SYMBOLS <ls_bapiret2> LIKE LINE OF lt_bapiret2_table.

  LOOP AT lt_bapiret2_table
    ASSIGNING <ls_bapiret2>.

    "If dialog screen, then message to screen.
    IF xscreen = 'X' AND
       <ls_bapiret2>-type CA 'AEX'.

      MESSAGE
        ID     <ls_bapiret2>-id
        TYPE   <ls_bapiret2>-type
        NUMBER <ls_bapiret2>-number
        WITH
          <ls_bapiret2>-message_v1
          <ls_bapiret2>-message_v2
          <ls_bapiret2>-message_v3
          <ls_bapiret2>-message_v4.

    ENDIF.

    CALL FUNCTION 'NAST_PROTOCOL_UPDATE'
      EXPORTING
        msg_arbgb = <ls_bapiret2>-id
        msg_nr    = <ls_bapiret2>-number
        msg_ty    = <ls_bapiret2>-type
        msg_v1    = <ls_bapiret2>-message_v1
        msg_v2    = <ls_bapiret2>-message_v2
        msg_v3    = <ls_bapiret2>-message_v3
        msg_v4    = <ls_bapiret2>-message_v4
      EXCEPTIONS
        OTHERS    = 1.

  ENDLOOP.

ENDFORM.
