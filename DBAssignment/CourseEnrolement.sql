CREATE TABLE [dbo].[CourseEnrolement]
(
	[CECourseId] VARCHAR(50) NOT NULL, 
    [CEStudentId] VARCHAR(50) NOT NULL,
	[TestField] VARCHAR(50) NULL, 
    [CESemesterId] VARCHAR(50) NULL, 
    PRIMARY KEY ([CECourseId], [CEStudentId]),
	CONSTRAINT FK_CourseEnrolement_Student FOREIGN KEY ([CEStudentId]) REFERENCES [Student](StudentId), 
	CONSTRAINT FK_CourseEnrolement_Course FOREIGN KEY ([CECourseId]) REFERENCES [Course](CourseId), 
);

GO
CREATE TRIGGER [dbo].[Trigger_Limit_CourseEnrolement]
    ON [dbo].[CourseEnrolement]
    INSTEAD OF INSERT
    AS
    BEGIN
       
        DECLARE @times int
        DECLARE @insertedCEStudentId varchar(50)
        DECLARE @insertedCECourseId varchar(50)
        DECLARE @insertedCESemesterId varchar(50)
        DECLARE @isTuitionPaid bit 

        SELECT @isTuitionPaid = (TuitionPaid)
        FROM inserted i , [dbo].[Semester] s
        WHERE i.CESemesterId =  s.SemesterId

        SELECT @isTuitionPaid = (TuitionPaid)
        FROM [dbo].[CourseEnrolement] ce, [dbo].[Semester] s
        WHERE ce.CESemesterId =  s.SemesterId

        SELECT @insertedCEStudentId = (CEStudentId)
        FROM inserted

        SELECT @insertedCESemesterId = (CESemesterId)
        FROM inserted

        SELECT @insertedCECourseId = (CECourseId)
        FROM inserted

        SELECT @times = COUNT(*)
        FROM [dbo].[CourseEnrolement]
        WHERE @insertedCEStudentId = [dbo].[CourseEnrolement].[CEStudentId]
        
        IF (@times<5 AND @isTuitionPaid=1)
        BEGIN
            INSERT INTO [dbo].[CourseEnrolement] (CEStudentId, CECourseId, TestField, CESemesterId) VALUES (@insertedCEStudentId, @insertedCECourseId, @times, @insertedCESemesterId) 
        END
        SET @times = 0;
        SET @insertedCECourseId = '';
        SET @insertedCEStudentId = '';

    END