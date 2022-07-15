INTERFACE zopm_outp_print_output_i
  PUBLIC .

  METHODS execute
    IMPORTING dialog_ind     TYPE abap_bool
              output_message TYPE nast
              output_program TYPE tnapr
    RAISING   zcx_return3.

ENDINTERFACE.
