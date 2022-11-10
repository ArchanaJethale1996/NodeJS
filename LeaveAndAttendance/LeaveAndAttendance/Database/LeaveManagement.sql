----------------------------------------------------------------------------------------------------------------------------------------------------------
													Problem Statement : Leave and Attendance System
----------------------------------------------------------------------------------------------------------------------------------------------------------
																	DATABASE QUERIES
----------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------
						DDL
------------------------------------------------------------------------
 
 //Tables for Leave and Attendance System
 
 CREATE TABLE Employee (
     EmplID int,
     FirstName varchar(255) NOT NULL,
     LastName varchar(255),
     dob date,
     JoinDate date NOT NULL,
     designation varchar(255) NOT NULL,
     salary int NOT NULL,
     gender varchar(1)
     PRIMARY KEY (EmplID)
 );
 
 CREATE TABLE Login (
     EmplID int,
     username varchar(255) NOT NULL,
     password1 varchar(255) NOT NULL,
     credential_emp varchar(255) NOT NULL,
     PRIMARY KEY (username),
     FOREIGN KEY (EmplID) REFERENCES Employee(EmplID)
 );
 
  CREATE TABLE LeaveApp (
     EmplID int,
     AppNo int,
     fromdate date NOT NULL,
     toDate date,
     noofdays int,
     Reason VARCHAR(560) NOT NULL,
     TypeOfLeave varchar(255) NOT NULL,
     PRIMARY KEY (AppNo),
     FOREIGN KEY (EmplID) REFERENCES Employee(EmplID)
 );
 
 CREATE TABLE LeaveBalance (
 	 LeaveBal int,
     EmplID int,
     EL int NOT NULL,
     CL int NOT NULL,
     LOP int NOT NULL,
     Compensatory int NOT NULL,
	 other int NOT NULL,
     PRIMARY KEY (LeaveBal),
     FOREIGN KEY (EmplID) REFERENCES Employee(EmplID)
 );
 
 CREATE TABLE Dailylog (
 	 LogID int,
     EmplID int,
     DateToday int NOT NULL,
     InTime int NOT NULL,
     OutTime int NOT NULL,
     AverageTime int NOT NULL,
     PRIMARY KEY (LogID),
     FOREIGN KEY (EmplID) REFERENCES Employee(EmplID)
 );
 
 CREATE TABLE Holidays (
 	 HolidayID int,
     DateHoliday date,
     HolidayReason varchar(255),
     PRIMARY KEY (HolidayID)
 );



------------------------------------------------------------------------
					DML - Insert
------------------------------------------------------------------------
  
------------------------------------------------------------------------
						INSERTING- ASSUMED VALUE
------------------------------------------------------------------------

//Employee Data
USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[AddEmployee]    Script Date: 07/27/2018 12:58:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddEmployee]
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Employee 
			(EmplID,FirstName,LastName,dob,JoinDate,designation,salary,gender)
	VALUES  (101, 'Ami', 'Dan', '1996-06-14','2018-07-02','Project Engineer',3,'M'),
			(102, 'Ram', 'Sharma', '1994-01-23','2018-06-02','Project Engineer',3,'M'),
			(103, 'Sannu', 'Dim', '1995-04-14','2018-06-15','Project Engineer',3,'M'),
			(104, 'Sham', 'Varma', '1988-10-03','2018-06-02','Project Lead',3.5,'M'),
			(105, 'Kesav', 'Mane', '1996-06-14','2018-07-02','Delivery Head',4,'M'),
			(106, 'Tanvi', 'Mule', '1995-08-24','2018-07-12','Project Engineer',3,'F'),
			(107, 'Anaja', 'Aradya', '1992-07-12','2018-06-27','Analatic Engineer',3.5,'F'),
			(108, 'Neethu', 'Nath', '1994-01-13','2018-07-02','Manager',3.9,'F'),
			(109, 'Snehal', 'Rasal', '1993-07-16','2018-06-23','Project Lead',3.5,'F'),
			(110, 'Arti', 'Dubey', '1989-03-13','2018-07-12','Project Engineer',3,'F'),
			(111, 'Aman', 'Khan', '1979-02-23','2018-06-12','Research Engineer',3,'M'),
			(112, 'Keshava', 'Shinde', '1990-02-18','2018-07-02','Research Engineer',3,'M');
			
END

------------------------------------------------------------------------

//Login
USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[AddLoginInfo]    Script Date: 07/27/2018 12:59:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddLoginInfo]
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Login 
			(EmplID,username,password1,credential_emp)
	VALUES  (101, 'admin', 'admin','Admin'),
			(102, 'Ram.Sharma','123','Employee'),
			(103, 'Sannu.Dim', '123','Employee'),
			(104, 'Sham.Varma', '123','Employee'),
			(105, 'Kesav.Mane', '123','Employee'),
			(106, 'Tanvi.Mule', '123','Employee'),
			(107, 'Anaja.Aradya', '123','Employee'),
			(108, 'Neethu.Nath', '123','Employee'),
			(109, 'Snehal.Rasal', '123','Employee'),
			(110, 'Arti.Dubey','123','Employee'),
			(111, 'Aman.Khan','123','Employee'),
			(112, 'Keshava.Shinde', '123','Employee')
			;
			
END


------------------------------------------------------------------------
						DDL-SP
------------------------------------------------------------------------
 
------------------------------------------------------------------------
						Employee- Home
------------------------------------------------------------------------
GetLogin

USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[GetLogin]    Script Date: 07/27/2018 13:03:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[GetLogin] @username varchar(255),@password1 varchar(255)
as
select Login.EmplID,credential_emp,FirstName,LastName,designation from Login, Employee where username=@username and password1=@password1 and Login.EmplID=Employee.EmplID
------------------------------------------------------------------------


------------------------------------------------------------------------
						Employee- Check Attendance
------------------------------------------------------------------------
GetMonthAttendance

USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[Get_Month_Attendance]    Script Date: 07/27/2018 13:04:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_Month_Attendance] @StartDate datetime,@EndDate datetime,@EmplId int
AS 
BEGIN
	Declare @week_day varchar(25)
	Declare @InTime time(7)=''
	Declare @OutTime time(7)=''
	Declare @ManHours time(7)=''
	Declare @My_status varchar(25)
	DECLARE @DateHoliday date
	DECLARE @HolidayReason varchar(255)
	declare @temp Table
	(
		DayDate date,
		Week_Day varchar(25),
		status_day varchar(25),
		My_status varchar(25),
		inTime time(7),
		outTime time(7),
		ManHours time(7)
	);
	Declare @todayDate date=GetDate();
	Declare @joinDate date;
	select @joinDate=JoinDate from Employee where EmplID=@EmplId;
	
	WHILE @StartDate <= @EndDate
		begin
		IF DATENAME(dw,@StartDate) IN (N'Saturday', N'Sunday')
			   SET @week_day='Weekend';
		ELSE 
			   SET @week_day='Weekday';
		select @InTime=InTime,@OutTime=OutTime,@ManHours=ManHours from AttendanceLog where AttendanceLog.EmplID=@EmplID and @StartDate=AttendanceLog.attendance_date;		   
		
		IF @week_day=N'Weekend'
		BEGIN
			SET @My_status='WO';
		END	
		ELSE
		BEGIN
			IF DATEPART(hh,@ManHours)=0 
				SET @My_status='A';
			ELSE IF DATEPART(hh,@ManHours)<8
				SET @My_status='HD';
			ELSE IF DATEPART(hh,@ManHours)>=8 
				SET @My_status='P';	
		END;
		
		SET @HolidayReason='';
		select @HolidayReason=HolidayReason from Holidays where @StartDate=DateHoliday;
		IF @HolidayReason!='' AND @week_day!=N'Weekend'
		BEGIN 				
			SET @My_status=	'Holiday';
			SET @week_day=@HolidayReason;
		END
		
		
		IF (@My_status='A' AND @StartDate<@joinDate)
		BEGIN	
			SET @My_status='NJ';
		END
		ELSE IF (@My_status='A' AND @StartDate>@todayDate)
		BEGIN	
			SET @My_status='DNYC';
		END
		 INSERT INTO @temp (DayDate,Week_Day,status_day,inTime,outTime,ManHours,My_status) VALUES (@StartDate,DATENAME(dw,@StartDate),@week_day,@InTime,@OutTime,@ManHours,@My_status);
		 SET @StartDate = Dateadd(Day,1, @StartDate);
		 SET @week_day='';
		 SET @InTime ='';
		 SET @OutTime ='';
		 SET @ManHours ='';
		 SET @My_status ='';
	end ;

	select CONVERT(VARCHAR(10), DayDate , 111) as DayDate,Week_Day,status_day,My_status,CONVERT(VARCHAR(8), inTime, 108) as inTime,CONVERT(VARCHAR(8), outTime, 108) as outTime,CONVERT(VARCHAR(8), ManHours, 108) as ManHours from @temp;
END


------------------------------------------------------------------------
						Employee- Mark Attendance
------------------------------------------------------------------------
//Check if already Attendance of that day stored
USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[CheckAttendanceMark]    Script Date: 07/27/2018 13:59:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CheckAttendanceMark] @EmplID int,@attendance_date date
AS  
BEGIN  
	Select COUNT(attendance_date) as attendance from AttendanceLog where (attendance_date=@attendance_date AND EmplID=@EmplID) 
END  

------------------------------------------------------------------------
//Change The Attendance of particular Date
USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[ChangeAttendanceMark]    Script Date: 07/27/2018 14:01:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ChangeAttendanceMark] @EmplID int,@attendance_date date,@InTime time(7),@OutTime time(7)
AS  
BEGIN  
 
update AttendanceLog set InTime=@InTime,OutTime=@OutTime, ManHours=(CONVERT(time(7),DATEADD(s, DATEDIFF(s,@InTime,@OutTime),'00:00:00')))
where EmplID=@EmplID AND attendance_date=@attendance_date
END  

------------------------------------------------------------------------
//Insert Attendance

USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[MarkAttendance]    Script Date: 07/27/2018 14:02:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[MarkAttendance] @EmplID int,@attendance_date date,@InTime time(7),@OutTime time(7)
AS  
BEGIN  
 
INSERT INTO AttendanceLog (EmplID,attendance_date,InTime,OutTime,ManHours)
VALUES (@EmplID,@attendance_date,@InTime,@OutTime,(CONVERT(time(7),DATEADD(s, DATEDIFF(s,@InTime,@OutTime),'00:00:00'))))

END  


------------------------------------------------------------------------
						Employee- Apply Leave
------------------------------------------------------------------------
//Can Apply Leave

USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[CanApplyLeave]    Script Date: 07/27/2018 13:00:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CanApplyLeave] @EmplID int,@TypeOfLeave varchar(255)
AS  
BEGIN  
 DECLARE @days int;
 DECLARE @cmd AS NVARCHAR(max)
 SET @cmd='SELECT '+@TypeOfLeave+' as days from LeaveBalance where EmplID = '+CONVERT(varchar(10),@EmplID)+';';
 EXEC(@cmd);
END  

------------------------------------------------------------------------
//Show Leave Balance

USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[LeaveBalanceRead]    Script Date: 07/27/2018 14:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[LeaveBalanceRead] @EmplID int
as
SELECT [LeaveBal],[EmplID],[EL],[CL],[LOP],[Compensatory],[other]
  FROM [LeaveManagement].[dbo].[LeaveBalance] where EmplID=@EmplID
  
------------------------------------------------------------------------
//Insert Leave App 
USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[InsertLeaveTable]    Script Date: 07/27/2018 14:08:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertLeaveTable] @EmplID int,@fromdate date,@toDate date,@noofdays int,@Reason varchar(255),@TypeOfLeave varchar(255),@type1 varchar(12)
AS  
BEGIN   
 DECLARE @cmd AS NVARCHAR(max)
 INSERT INTO LeaveApp (EmplID,fromdate,toDate,noofdays,Reason,TypeOfLeave,type1)
 VALUES (@EmplID,@fromdate,@toDate,@noofdays,@Reason,@TypeOfLeave,@type1);
 SET @cmd='UPDATE LeaveBalance SET '+  @TypeOfLeave+' = '+ @TypeOfLeave+' - '+CONVERT(varchar(10),@noofdays)+' WHERE EmplID = '+CONVERT(varchar(10),@EmplID)+';';
 EXEC(@cmd);
END  


----------------------------------------------------------------------------
								ADMIN
----------------------------------------------------------------------------

------------------------------------------------------------------------
						Admin- Approve Leave
------------------------------------------------------------------------
Get Approve Leave

USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[GetApproveLeave]    Script Date: 07/27/2018 13:05:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetApproveLeave]
AS
BEGIN
	SET NOCOUNT ON;
	select e.EmplID,FirstName,LastName,CONVERT(VARCHAR(10),l.fromdate,111) as fromdate,CONVERT(VARCHAR(10),l.toDate,111) as toDate,noofdays,Reason,TypeOfLeave,type1 from LeaveApp l,Employee e where l.EmplID=e.EmplID;
END

----------------------------------------------------------------------------
Search Approve Leave

USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[Report_Search_Approve]    Script Date: 07/27/2018 13:05:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_Search_Approve] @pattern varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	select e.EmplID,FirstName,LastName,CONVERT(VARCHAR(10),l.fromdate,111) as fromdate,CONVERT(VARCHAR(10),l.toDate,111) as toDate,noofdays,Reason,TypeOfLeave,type1 from LeaveApp l,Employee e where l.EmplID=e.EmplID AND (FirstName LIKE @pattern OR LastName LIKE @pattern OR e.EmplID LIKE @pattern);
END





------------------------------------------------------------------------
						Admin- Show Average
------------------------------------------------------------------------
//Average of Particular Span
USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[Report_Average]    Script Date: 07/27/2018 14:10:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_Average] @startDate date,@endDate date
AS 
BEGIN
	SET NOCOUNT ON;
	select EmplID,AVG(DATEPART(hh,ManHours)) as hraverage,AVG(DATEPART(n,ManHours)) as minaverage INTO #AverageTable from AttendanceLog  
	where attendance_date between @startDate AND @endDate
	group by EmplID
	order by EmplID; 
	select Employee.EmplID,FirstName,LastName,hraverage,minaverage from #AverageTable,Employee where #AverageTable.EmplID=Employee.EmplID;
END


------------------------------------------------------------------------
						Admin- Approve Leave
------------------------------------------------------------------------
//Get Approve Leave
USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[GetApproveLeave]    Script Date: 07/27/2018 14:13:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetApproveLeave]
AS
BEGIN
	SET NOCOUNT ON;
	select e.EmplID,FirstName,LastName,CONVERT(VARCHAR(10),l.fromdate,111) as fromdate,CONVERT(VARCHAR(10),l.toDate,111) as toDate,noofdays,Reason,TypeOfLeave,type1 from LeaveApp l,Employee e where l.EmplID=e.EmplID;
END

---------------------------------------------------------------------------
//Search Approve Leave
USE [LeaveManagement]
GO
/****** Object:  StoredProcedure [dbo].[Report_Search_Approve]    Script Date: 07/27/2018 14:13:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_Search_Approve] @pattern varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	select e.EmplID,FirstName,LastName,CONVERT(VARCHAR(10),l.fromdate,111) as fromdate,CONVERT(VARCHAR(10),l.toDate,111) as toDate,noofdays,Reason,TypeOfLeave,type1 from LeaveApp l,Employee e where l.EmplID=e.EmplID AND (FirstName LIKE @pattern OR LastName LIKE @pattern OR e.EmplID LIKE @pattern);
END

----------------------------------------------------------------------------------------------------------------------------------------------------------