CREATE TABLE [dbo].[Course]
(
	[CourseId] VARCHAR(50) NOT NULL PRIMARY KEY, 
    [CLecturerId] VARCHAR(50) NULL, 
    [CSemesterId] VARCHAR(50) NULL, 
    [CourseName] VARCHAR(50) NULL,
)
