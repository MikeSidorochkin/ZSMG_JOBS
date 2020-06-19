*&---------------------------------------------------------------------*
*& Report ZSM_STOP_DOUBLE_PLAN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsm_stop_double_plan.

IF zcl_sm_job_runtime=>get_instance( )->is_job_running( ).
  DATA(ls_rt_info) = zcl_sm_job_runtime=>get_instance( )->get_runtime_info( ).
  MESSAGE e001(00) WITH |Job { ls_rt_info-jobname } is running|.
ELSE.
  WAIT UP TO 100 SECONDS.
ENDIF.
