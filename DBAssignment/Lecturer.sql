CREATE TABLE [dbo].[Lecturer]
(
	[LecturerId] VARCHAR(50) NOT NULL,
    [LSemesterId] VARCHAR(50) NOT NULL, 
    [LCourseId] VARCHAR(50) NULL,
    [LecturerName] VARCHAR(50) NULL, 
    PRIMARY KEY ([LecturerId], [LSemesterId]),
)

