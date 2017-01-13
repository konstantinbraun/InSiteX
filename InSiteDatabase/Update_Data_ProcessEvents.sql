update Data_ProcessEvents
set StatusID = 50, DoneFrom='System', DoneOn=SYSDATETIME()
where CreatedOn < '2016-01-03' and StatusID <> 50
;

