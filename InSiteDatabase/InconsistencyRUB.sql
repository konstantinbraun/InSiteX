begin transaction

delete from Data_PresenceAccessEvents
where systemid=1 and bpid = 57 and PresenceDay >= '2016-01-01'

delete from Data_AccessEvents
  where systemid=1 and bpid = 57 and AccessResult=1 and IsManualEntry=1 and AccessOn >= '2016-01-01'

update Data_AccessEvents
set AccessEventLinkedID = null
  where systemid=1 and bpid = 57 and AccessResult=1 and AccessOn >= '2016-01-01'


rollback transaction

commit transaction
