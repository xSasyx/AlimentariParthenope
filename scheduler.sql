 BEGIN 
    DBMS_SCHEDULER.CREATE_JOB( 
        job_name        => 'job_controllo_sconti', 
        job_type        => 'PLSQL_BLOCK', 
        job_action      => 'BEGIN aggiorna_sconti_scaduti; END;', 
        start_date      => SYSTIMESTAMP, 
        repeat_interval => 'FREQ=DAILY; BYHOUR=0; BYMINUTE=0; BYSECOND=0', 
        enabled         => TRUE, 
        comments        => 'Aggiorna sconti scaduti ogni giorno a mezzanotte' 
    ); 
END;




 
BEGIN 
    DBMS_SCHEDULER.CREATE_JOB( 
        job_name => 'gestisci_clienti_inattivi_job', 
        job_type => 'PLSQL_BLOCK', 
        job_action => 'BEGIN gestisci_clienti_inattivi; END;', 
        start_date => SYSTIMESTAMP, 
        repeat_interval => 'FREQ=MONTHLY', 
        enabled => TRUE 
    ); 
 END; 


 