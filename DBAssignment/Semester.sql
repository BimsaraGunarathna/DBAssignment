CREATE TABLE [dbo].[Semester]
(
	[SemesterId] VARCHAR(50) NOT NULL, 
    [TuitionPaid] BIT NULL, 
    [SStudentId] VARCHAR(50) NOT NULL,
    PRIMARY KEY ([SemesterId], [SStudentId])
)

GO
CREATE TRIGGER [dbo].[Trigger_Atleat_One_Course_Per_Semester]
    ON [dbo].[Semester]
    INSTEAD OF INSERT
    AS
    BEGIN

        DECLARE @insertedSemesterId VARCHAR(50);
        SELECT @insertedSemesterId = (SemesterId)
            FROM inserted

        DECLARE @insertedStudentId VARCHAR(50);
        SELECT @insertedStudentId = (SStudentId)
            FROM inserted

        DECLARE 
            @Lecturer_Name_Holder VARCHAR(50),
            @Lecturer_Semester_Id_Holder VARCHAR(50),
            @Lecturer_Id_Holder   VARCHAR(50);

        DECLARE Cursor_Lecturer CURSOR
        FOR SELECT 
            LecturerId,
            LSemesterId,
            LecturerName
        FROM 
            [dbo].[Lecturer];
        
        INSERT INTO [dbo].[Semester] ([SemesterId], [SStudentId], [TuitionPaid]) VALUES ( @insertedSemesterId, @insertedStudentId, 1)

        OPEN Cursor_Lecturer;
        
        WHILE @@FETCH_STATUS = 0
            BEGIN
                FETCH NEXT FROM Cursor_Lecturer INTO 
                    @Lecturer_Id_Holder,
                    @Lecturer_Semester_Id_Holder,
                    @Lecturer_Name_Holder;
                    
                INSERT INTO [dbo].[Lecturer] ([LecturerId], [LSemesterId], [LCourseId], [LecturerName]) VALUES ( @Lecturer_Id_Holder, @insertedSemesterId, 1, @Lecturer_Name_Holder)
            END;
        CLOSE Cursor_Lecturer;
        DEALLOCATE Cursor_Lecturer; 
        
    END