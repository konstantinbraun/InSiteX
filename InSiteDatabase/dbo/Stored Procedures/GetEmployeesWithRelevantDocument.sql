CREATE PROCEDURE [dbo].[GetEmployeesWithRelevantDocument]
(
	@SystemID int,
	@BpID int,
	@RelevantDocumentID int 
)
AS

SELECT RelevantFor, EmployeeID
FROM Master_EmployeeRelevantDocuments 
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND RelevantDocumentID = @RelevantDocumentID
