UPDATE Master_Users
SET StatusId = 20
WHERE StatusID <> 20
AND ReleaseOn IS NOT NULL
AND LockedOn IS NULL
