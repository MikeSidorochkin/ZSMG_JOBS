class ZCL_SM_JOB_RUNTIME definition
  public
  final
  create private .

public section.

  types:
    BEGIN OF ts_job_runtime_info,
        eventid                 TYPE  tbtcm-eventid,
        eventparm               TYPE  tbtcm-eventparm,
        external_program_active TYPE  tbtcm-xpgactive,
        jobcount                TYPE  tbtcm-jobcount,
        jobname                 TYPE  tbtcm-jobname,
        stepcount               TYPE  tbtcm-stepcount,
      END OF ts_job_runtime_info .

  methods CONSTRUCTOR .
  methods IS_JOB_RUNNING
    returning
      value(RV_IS_RUNNING) type ABAP_BOOL .
  methods GET_RUNTIME_INFO
    returning
      value(RS_RUNTIME_INFO) type ZCL_SM_JOB_RUNTIME=>TS_JOB_RUNTIME_INFO .
  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCL_SM_JOB_RUNTIME .
protected section.
private section.

  data MS_RUNTIME_INFO type TS_JOB_RUNTIME_INFO .
  class-data GO_INSTANCE type ref to ZCL_SM_JOB_RUNTIME .
ENDCLASS.



CLASS ZCL_SM_JOB_RUNTIME IMPLEMENTATION.


  METHOD constructor.
    CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
      IMPORTING
        eventid                 = ms_runtime_info-eventid
        eventparm               = ms_runtime_info-eventparm
        external_program_active = ms_runtime_info-external_program_active
        jobcount                = ms_runtime_info-jobcount
        jobname                 = ms_runtime_info-jobname
        stepcount               = ms_runtime_info-stepcount
      EXCEPTIONS
        no_runtime_info         = 1
        OTHERS                  = 2.
  ENDMETHOD.


  METHOD get_instance.
    go_instance = ro_instance = COND #( WHEN go_instance IS BOUND THEN go_instance
                                        ELSE NEW zcl_sm_job_runtime( ) ).
  ENDMETHOD.


  METHOD get_runtime_info.
    rs_runtime_info = ms_runtime_info.
  ENDMETHOD.


  METHOD is_job_running.
    SELECT SINGLE jobname INTO @DATA(lv_jobname)
      FROM tbtco WHERE jobname  =   @ms_runtime_info-jobname  AND
                       jobcount <>  @ms_runtime_info-jobcount AND
                       status   =   'R'.

    rv_is_running = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.
ENDCLASS.
