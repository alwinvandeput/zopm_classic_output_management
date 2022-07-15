INTERFACE zopm_outp_external_send_i
  PUBLIC .

  METHODS execute
    IMPORTING
              output_message TYPE nast
              output_program TYPE tnapr
    RAISING   zcx_return3.

ENDINTERFACE.
