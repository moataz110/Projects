CREATE DATABASE PostGradOffice;
go
use PostGradOffice; 
CREATE TABLE PostGradUser(
id int primary key identity(1,1),
email varchar(50) not null,
password varchar(30) not null
) 
CREATE TABLE Admin(
id int primary key foreign key references PostGradUser on delete cascade on update cascade
)
CREATE TABLE GucianStudent(
id int primary key foreign key references PostGradUser on delete cascade on update cascade,
firstName varchar(20),
lastName varchar(20),
type varchar(3),
faculty varchar(30),
address varchar(50),
GPA decimal(3,2),
undergradID int
)
CREATE TABLE NonGucianStudent(
id int primary key foreign key references PostGradUser on delete cascade on update cascade,
firstName varchar(20),
lastName varchar(20),
type varchar(3),
faculty varchar(30),
address varchar(50),
GPA decimal(3,2),
)
CREATE TABLE GUCStudentPhoneNumber(
id int primary key foreign key references GucianStudent on delete cascade on update cascade,
phone int
)
CREATE TABLE NonGUCStudentPhoneNumber(
id int primary key foreign key references NonGucianStudent on delete cascade on update cascade,
phone int
)
CREATE TABLE Course(
id int primary key identity(1,1),
fees int,
creditHours int,
code varchar(10)
)
CREATE TABLE Supervisor(
id int primary key foreign key references PostGradUser,
name varchar(20),
faculty varchar(30)
);
CREATE TABLE Examiner(
id int primary key foreign key references PostGradUser on delete cascade on update cascade,
name varchar(20),
fieldOfWork varchar(100),
isNational BIT
)
CREATE TABLE Payment(
id int primary key identity(1,1),
amount decimal(7,2),
noOfInstallments int,
fundPercentage decimal(4,2)
)
CREATE TABLE Thesis(
serialNumber int primary key identity(1,1),
field varchar(20),
type varchar(3) not null,
title varchar(100) not null,
startDate date not null,
endDate date not null,
defenseDate date,
years as (year(endDate)-year(startDate)),
grade decimal(4,2),
payment_id int foreign key references payment on delete cascade on update cascade,
noOfExtensions int
)
CREATE TABLE Publication(
id int primary key identity(1,1),
title varchar(100) not null,
dateOfPublication date,
place varchar(100),
accepted BIT,
host varchar(100)
);
 
Create table Defense (serialNumber int, 
date datetime, 
location varchar(15),
grade decimal(4,2), 
primary key (serialNumber, date), 
foreign key (serialNumber) references Thesis on delete cascade on update cascade)
Create table GUCianProgressReport (
sid int foreign key references GUCianStudent on delete cascade on update cascade
, no int
, date datetime
, eval int
, state int
, description varchar(200)
, thesisSerialNumber int foreign key references Thesis on delete cascade on update cascade
, supid int foreign key references Supervisor
, primary key (sid, no) )
Create table NonGUCianProgressReport (sid int foreign key references NonGUCianStudent on delete 
cascade on update cascade,
no int
, date datetime
, eval int
, state int
, description varchar(200)
, thesisSerialNumber int foreign key references Thesis on delete cascade on update cascade
, supid int foreign key references Supervisor
, primary key (sid, no) )
Create table Installment (date datetime,
paymentId int foreign key references Payment on delete cascade on update cascade
, amount decimal(8,2)
, done bit
, primary key (date, paymentId))
Create table NonGucianStudentPayForCourse(sid int foreign key references NonGucianStudent on 
delete cascade on update cascade, 
paymentNo int foreign key references Payment on delete cascade on update cascade,
cid int foreign key references Course on delete cascade on update cascade, 
primary key (sid, paymentNo, cid))
Create table NonGucianStudentTakeCourse (sid int foreign key references NonGUCianStudent on delete 
cascade on update cascade
, cid int foreign key references Course on delete cascade on update cascade
, grade decimal (4,2)
, primary key (sid, cid) )
Create table GUCianStudentRegisterThesis (sid int foreign key references GUCianStudent on delete 
cascade on update cascade,
supid int foreign key references Supervisor
, serial_no int foreign key references Thesis on delete cascade on update cascade
, primary key(sid, supid, serial_no))
Create table NonGUCianStudentRegisterThesis (sid int foreign key references NonGUCianStudent on 
delete cascade on update cascade, 
supid int foreign key references Supervisor, 
serial_no int foreign key references Thesis on delete cascade on update cascade , 
primary key (sid, supid, serial_no))
Create table ExaminerEvaluateDefense(date datetime,
serialNo int,
examinerId int foreign key references Examiner on delete cascade on update cascade,
comment varchar(300), 
primary key(date, serialNo, examinerId), 
foreign key (serialNo, date) references Defense (serialNumber, date) on delete cascade on update 
cascade)
Create table ThesisHasPublication(serialNo int foreign key references Thesis on delete cascade on 
update cascade,
pubid int foreign key references Publication on delete cascade on update cascade,
primary key(serialNo,pubid))
go
create proc studentRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@faculty varchar(20),
@Gucian bit,
@email varchar(50),
@address varchar(50)
as
begin
insert into PostGradUser(email,password)
values(@email,@password)
declare @id int
SELECT @id=SCOPE_IDENTITY()
if(@Gucian=1)
insert into GucianStudent(id,firstName,lastName,faculty,address) 
values(@id,@first_name,@last_name,@faculty,@address)
else
insert into NonGucianStudent(id,firstName,lastName,faculty,address) 
values(@id,@first_name,@last_name,@faculty,@address)
end
go
create proc supervisorRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@faculty varchar(20),
@email varchar(50)
as
begin
insert into PostGradUser(email,password)
values(@email,@password)
declare @id int
SELECT @id=SCOPE_IDENTITY()
declare @name varchar(50)
set @name = CONCAT(@first_name,@last_name)
insert into Supervisor(id,name,faculty) values(@id,@name,@faculty)
end
go
Create proc userLogin
@id int,
@password varchar(20),
@success bit output
as
begin
if exists(
select ID,password
from PostGradUser
where id=@id and password=@password)
set @success =1
else
set @success=0
end
go
create proc addMobile
@ID varchar(20),
@mobile_number varchar(20)
as
begin
if @ID is not null and @mobile_number is not null
begin
--check Gucian student or not
if(exists(select * from GucianStudent where id=@ID))
insert into GUCStudentPhoneNumber values(@ID,@mobile_number)
if(exists(select * from NonGucianStudent where id=@ID))
insert into NonGUCStudentPhoneNumber values(@ID,@mobile_number)
end
end
go
CREATE Proc AdminListSup
As
Select u.id,u.email,u.password,s.name, s.faculty
from PostGradUser u inner join Supervisor s on u.id = s.id
go
CREATE Proc AdminViewSupervisorProfile
@supId int
As
Select u.id,u.email,u.password,s.name, s.faculty
from PostGradUser u inner join Supervisor s on u.id = s.id
WHERE @supId = s.id
go
CREATE Proc AdminViewAllTheses
As
Select 
serialNumber,field,type,title,startDate,endDate,defenseDate,years,grade,payment_id,noOfExtensions
From Thesis
go
CREATE Proc AdminViewOnGoingTheses
@thesesCount int output
As
Select @thesesCount=Count(*)
From Thesis
where endDate > Convert(Date,CURRENT_TIMESTAMP)
go
CREATE Proc AdminViewStudentThesisBySupervisor
As
Select s.name,t.title,gs.firstName
From Thesis t inner join GUCianStudentRegisterThesis sr on t.serialNumber=sr.serial_no
inner join Supervisor s on s.id=sr.supid inner join GucianStudent gs on sr.sid=gs.id
where t.endDate > Convert(Date,CURRENT_TIMESTAMP)
union
Select s.name,t.title,gs.firstName
From Thesis t inner join NonGUCianStudentRegisterThesis sr on t.serialNumber=sr.serial_no
inner join Supervisors on s.id=sr.supid inner join NonGucianStudent gs on sr.sid=gs.id
where t.endDate > Convert(Date,CURRENT_TIMESTAMP)
go
go
CREATE Proc AdminListNonGucianCourse
@courseID int
As
if(exists(select * from Course where id=@courseID))
Select ng.firstName,ng.lastName,c.code,n.grade
From NonGucianStudentTakeCourse n inner join Course c on n.cid=c.id inner join NonGucianStudent ng 
on ng.id=n.sid
where n.cid=@courseID
go
CREATE Proc AdminUpdateExtension
@ThesisSerialNo int
As
if(exists(select * from Thesis where serialNumber=@ThesisSerialNo))
begin
declare @noOfExtensions int
select @noOfExtensions=noOfExtensions from Thesis where serialNumber=@ThesisSerialNo
update Thesis
set noOfExtensions=@noOfExtensions+1
where serialNumber=@ThesisSerialNo
end
go
CREATE Proc AdminIssueThesisPayment
@ThesisSerialNo int,
@amount decimal,
@noOfInstallments int,
@fundPercentage decimal
As
if(exists(select * from Thesis where serialNumber=@ThesisSerialNo))
begin
insert into Payment(amount,noOfInstallments,fundPercentage) 
values(@amount,@noOfInstallments,@fundPercentage)
declare @id int
SELECT @id=SCOPE_IDENTITY()
update Thesis
set payment_id=@id
where serialNumber=@ThesisSerialNo
end
go
CREATE Proc AdminViewStudentProfile
@sid int
As
if(exists(select * from GucianStudent where id=@sid))
Select u.id,u.email,u.password,s.firstName,s.lastName,s.type,s.faculty,s.address,s.address,s.GPA
from PostGradUser u inner join GucianStudent s on u.id=s.id
WHERE @sid = s.id
else if(exists(select * from NonGucianStudent where id=@sid))
Select u.id,u.email,u.password,s.firstName,s.lastName,s.type,s.faculty,s.address,s.address,s.GPA
from PostGradUser u inner join NonGucianStudent s on u.id=s.id
WHERE @sid = s.id
go
CREATE Proc AdminIssueInstallPayment
@paymentID int,
@InstallStartDate date
As
if(exists(select * from Payment where id=@paymentID))
begin
declare @numOfInst int
select @numOfInst=noOfInstallments
from Payment
where id=@paymentID
declare @payAmount int
select @payAmount=amount
from Payment
where id=@paymentID
DECLARE @Counter INT
SET @Counter=1
WHILE (@counter<=@numOfInst)
BEGIN
 declare @instdate date
 set @instdate=@InstallStartDate
 declare @instAmount int
 set @instAmount=@payAmount/@numOfInst
 if(@counter=1)
 insert into 
Installment(date,paymentId,amount,done)values(@InstallStartDate,@paymentID,@instAmount,0)
 else
 begin
 set @instdate=DATEADD(MM, 6, @instdate);
 insert into 
Installment(date,paymentId,amount,done)values(@instdate,@paymentID,@instAmount,0)
 end
 SET @counter=@counter+1
END
end
go
CREATE Proc AdminListAcceptPublication
As
select t.serialNumber,p.title
from ThesisHasPublication tp inner join Thesis t on tp.serialNo=t.serialNumber
inner join Publication p on p.id=tp.pubid
where p.accepted=1
go
CREATE Proc AddCourse
@courseCode varchar(10),
@creditHrs int,
@fees decimal
As
insert into Course values(@fees,@creditHrs,@courseCode)
go
CREATE Proc linkCourseStudent
@courseID int,
@studentID int
As
if(exists(select * from Course ) and exists(select * from NonGucianStudent where id=@studentID))
insert into NonGucianStudentTakeCourse(sid,cid,grade)values(@studentID,@courseID,null)
go
CREATE Proc addStudentCourseGrade
@courseID int,
@studentID int,
@grade decimal
As
if(exists(select * from NonGucianStudentTakeCourse where sid=@studentID and cid=@courseID))
update NonGucianStudentTakeCourse
set grade =@grade
where cid=@courseID and sid=@studentID
go
CREATE Proc ViewExamSupDefense
@defenseDate datetime
As
select s.serial_no,ee.date,e.name,sup.name
from ExaminerEvaluateDefense ee inner join examiner e on ee.examinerId=e.id
inner join GUCianStudentRegisterThesis s on ee.serialNo=s.serial_no
inner join Supervisor sup on sup.id=s.supid
go
CREATE Proc EvaluateProgressReport
@supervisorID int,
@thesisSerialNo int,
@progressReportNo int,
@evaluation int
As
if(exists(select * from Thesis where serialNumber=@thesisSerialNo ) and @evaluation in(0,1,2,3) )
begin
if(exists(select * from GUCianStudentRegisterThesis where serial_no=@thesisSerialNo and 
supid=@supervisorID))
begin
declare @gucSid int
select @gucSid=sid
from GUCianStudentRegisterThesis
where serial_no=@thesisSerialNo
update GUCianProgressReport
set eval=@evaluation
where sid=@gucSid and thesisSerialNumber=@thesisSerialNo and no=@progressReportNo
end
else if(exists(select * from NonGUCianStudentRegisterThesis where serial_no=@thesisSerialNo and 
supid=@supervisorID))
begin
declare @nonGucSid int
select @nonGucSid=sid
from NonGUCianStudentRegisterThesis
where serial_no=@thesisSerialNo
update NonGUCianProgressReport
set eval=@evaluation
where sid=@nonGucSid and thesisSerialNumber=@thesisSerialNo and no=@progressReportNo
end
end
go
CREATE Proc ViewSupStudentsYears
@supervisorID int
As
if(exists(select * from Supervisor where id=@supervisorID))
begin
select s.firstName,s.lastName,t.years
from GUCianStudentRegisterThesis sr inner join GucianStudent s on sr.sid=s.id
inner join Thesis t on t.serialNumber=sr.serial_no
union
select s.firstName,s.lastName,t.years
from NonGUCianStudentRegisterThesis sr inner join NonGucianStudent s on sr.sid=s.id
inner join Thesis t on t.serialNumber=sr.serial_no
end
go
CREATE Proc SupViewProfile
@supervisorID int
As
if(exists(select * from Supervisor where id=@supervisorID))
begin
select u.id,u.email,u.password,s.name,s.faculty
from PostGradUser u inner join Supervisor s on u.id=s.id
end
go
---------------------------------------
create proc UpdateSupProfile
@supervisorID int, @name varchar(20), @faculty varchar(20)
as
update Supervisor
set name = @name, faculty = @faculty
where id = @supervisorID
go
create proc ViewAStudentPublications
@StudentID int
as
select P.*
from GUCianStudentRegisterThesis GUC
inner join Thesis T
on GUC.serial_no = T.serialNumber
inner join ThesisHasPublication TP
on T.serialNumber = TP.serialNo
inner join Publication P
on P.id = TP.pubid
where GUC.sid = @StudentID
union all
select P.*
from NonGUCianStudentRegisterThesis NON
inner join Thesis T
on NON.serial_no = T.serialNumber
inner join ThesisHasPublication TP
on T.serialNumber = TP.serialNo
inner join Publication P
on P.id = TP.pubid
where NON.sid = @StudentID
go
create proc AddDefenseGucian
@ThesisSerialNo int , @DefenseDate Datetime , @DefenseLocation varchar(15)
as
insert into Defense values(@ThesisSerialNo,@DefenseDate,@DefenseLocation,null)
go
create proc AddDefenseNonGucian
@ThesisSerialNo int , @DefenseDate Datetime , @DefenseLocation varchar(15)
as
declare @idOfStudent int
select @idOfStudent = sid
from NonGUCianStudentRegisterThesis
where serial_no = @ThesisSerialNo
if(not exists(select grade
from NonGucianStudentTakeCourse
where sid = @idOfStudent and grade < 50))
begin
insert into Defense values(@ThesisSerialNo,@DefenseDate,@DefenseLocation,null)
end
go
create proc AddExaminer
@ThesisSerialNo int , @DefenseDate Datetime , @ExaminerName varchar(20),@Password varchar(30), 
@National bit, @fieldOfWork varchar(20)
as
insert into PostGradUser values(@ExaminerName,@Password)
declare @id int
set @id = SCOPE_IDENTITY()
insert into Examiner values(@id,@ExaminerName,@fieldOfWork,@National)
insert into ExaminerEvaluateDefense values(@DefenseDate,@ThesisSerialNo,@id,null)
go
create proc CancelThesis
@ThesisSerialNo int
as
if(exists(
select *
from GUCianProgressReport
where thesisSerialNumber = @ThesisSerialNo
))
begin 
declare @gucianEval int
set @gucianEval = (
select top 1 eval
from GUCianProgressReport
where thesisSerialNumber = @ThesisSerialNo
order by no desc
)
if(@gucianEval = 0)
begin
delete from Thesis where serialNumber = @ThesisSerialNo
end
end
else
begin
declare @nonGucianEval int
set @nonGucianEval = (
select top 1 eval
from NonGUCianProgressReport
where thesisSerialNumber = @ThesisSerialNo
order by no desc
)
if(@nonGucianEval = 0)
begin
delete from Thesis where serialNumber = @ThesisSerialNo
end
end
go
create proc AddGrade
@ThesisSerialNo int
as
declare @grade decimal(4,2)
select @grade = grade
from Defense
where serialNumber = @ThesisSerialNo
update Thesis
set grade = @grade
where serialNumber = @ThesisSerialNo
go
create proc AddDefenseGrade
@ThesisSerialNo int , @DefenseDate Datetime , @grade decimal(4,2)
as
update Defense
set grade = @grade
where serialNumber = @ThesisSerialNo and date = @DefenseDate
go
create proc AddCommentsGrade
@ThesisSerialNo int , @DefenseDate Datetime , @comments varchar(300)
as
update ExaminerEvaluateDefense
set comment = @comments
where serialNo = @ThesisSerialNo and date = @DefenseDate
go
create proc viewMyProfile
@studentId int
as
if(exists(
select * from GucianStudent where id = @studentId
))
begin
select G.*,P.email 
from GucianStudent G
inner join PostGradUser P
on G.id = P.id
where G.id = @studentId
end
else
begin
select N.*,P.email 
from NonGucianStudent N
inner join PostGradUser P
on N.id = P.id
where N.id = @studentId
end
go
create proc editMyProfile
@studentID int, @firstName varchar(20), @lastName varchar(20), @password varchar(30), @email 
varchar(50)
, @address varchar(50), @type varchar(3)
as
update GucianStudent
set firstName = @firstName, lastName = @lastName, address = @address, type = @type
where id = @studentID
update NonGucianStudent
set firstName = @firstName, lastName = @lastName, address = @address, type = @type
where id = @studentID
update PostGradUser
set email = @email, password = @password
where id = @studentID
go
create proc addUndergradID
@studentID int, @undergradID varchar(10)
as
update GucianStudent
set undergradID = @undergradID
where id = @studentID
go
create proc ViewCoursesGrades
@studentID int
as
select grade
from NonGucianStudentTakeCourse 
where sid = @studentID
go
create proc ViewCoursePaymentsInstall
@studentID int
as
select P.id as 'Payment Number', P.amount as 'Amount of Payment',P.fundPercentage as 'Percentage of 
fund for payment', P.noOfInstallments as 'Number of installments',
I.amount as 'Installment Amount',I.date as 'Installment date', I.done as 'Installment done or not'
from NonGucianStudentPayForCourse NPC
inner join Payment P
on NPC.paymentNo = P.id and NPC.sid = @studentID
inner join Installment I
on I.paymentId = P.id
go
create proc ViewThesisPaymentsInstall
@studentID int
as
select P.id as 'Payment Number', P.amount as 'Amount of Payment', P.fundPercentage as 
'Fund',P.noOfInstallments as 'Number of installments',
I.amount as 'Installment amount',I.date as 'Installment date', I.done as 'Installment done or not'
from GUCianStudentRegisterThesis G
inner join Thesis T
on G.serial_no = T.serialNumber and G.sid = @studentID
inner join Payment P
on T.payment_id = P.id
inner join Installment I
on I.paymentId = P.id
union
select P.id as 'Payment Number',P.amount as 'Amount of Payment', P.fundPercentage as 
'Fund',P.noOfInstallments as 'Number of installments',
I.amount as 'Installment amount',I.date as 'Installment date', I.done as 'Installment done or not'
from NonGUCianStudentRegisterThesis NG
inner join Thesis T
on NG.serial_no = T.serialNumber and NG.sid = @studentID
inner join Payment P
on T.payment_id = P.id
inner join Installment I
on I.paymentId = P.id
go
create proc ViewUpcomingInstallments
@studentID int
as
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Installment I
inner join NonGucianStudentPayForCourse NPC
on I.paymentId = NPC.paymentNo and NPC.sid = @studentID and I.date > CURRENT_TIMESTAMP
union
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Thesis T
inner join Payment P
on T.payment_id = P.id
inner join Installment I 
on I.paymentId = P.id
inner join GUCianStudentRegisterThesis G
on G.serial_no = T.serialNumber and G.sid = @studentID
where I.date > CURRENT_TIMESTAMP
union
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Thesis T
inner join Payment P
on T.payment_id = P.id
inner join Installment I 
on I.paymentId = P.id
inner join NonGUCianStudentRegisterThesis G
on G.serial_no = T.serialNumber and G.sid = @studentID
where I.date > CURRENT_TIMESTAMP
go
create proc ViewMissedInstallments
@studentID int
as
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Installment I
inner join NonGucianStudentPayForCourse NPC
on I.paymentId = NPC.paymentNo and NPC.sid = @studentID and I.date < CURRENT_TIMESTAMP and 
I.done = '0'
union
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Thesis T
inner join Payment P
on T.payment_id = P.id
inner join Installment I 
on I.paymentId = P.id
inner join GUCianStudentRegisterThesis G
on G.serial_no = T.serialNumber and G.sid = @studentID
where I.date < CURRENT_TIMESTAMP and I.done = '0'
union
select I.date as 'Date of Installment' ,I.amount as 'Amount'
from Thesis T
inner join Payment P
on T.payment_id = P.id
inner join Installment I 
on I.paymentId = P.id
inner join NonGUCianStudentRegisterThesis G
on G.serial_no = T.serialNumber and G.sid = @studentID
where I.date < CURRENT_TIMESTAMP and I.done = '0'
go
create proc AddProgressReport
@thesisSerialNo int, @progressReportDate date, @studentID int,@progressReportNo int
as
declare @gucian int
if(exists(
select id
from GucianStudent
where id = @studentID
))
begin
set @gucian = '1'
end
else
begin
set @gucian = '0'
end
if(@gucian = '1')
begin
insert into GUCianProgressReport 
values(@studentID,@progressReportNo,@progressReportDate,null,null,null,@thesisSerialNo,null)
end
else
begin
insert into NonGUCianProgressReport 
values(@studentID,@progressReportNo,@progressReportDate,null,null,null,@thesisSerialNo,null)
end
go
create proc FillProgressReport
@thesisSerialNo int, @progressReportNo int, @state int, @description varchar(200),@studentID int
as
declare @gucian bit
if(exists(
select * from GucianStudent
where id = @studentID
))
begin
set @gucian = '1'
end
else
begin
set @gucian = '0'
end
if(@gucian = '1')
begin
update GUCianProgressReport
set state = @state, description = @description, date = CURRENT_TIMESTAMP
where thesisSerialNumber = @thesisSerialNo and sid = @studentID and no = @progressReportNo
end
else
begin
update NonGUCianProgressReport
set state = @state, description = @description, date = CURRENT_TIMESTAMP
where thesisSerialNumber = @thesisSerialNo and sid = @studentID and no = @progressReportNo
end
go
create proc ViewEvalProgressReport
@thesisSerialNo int, @progressReportNo int,@studentID int
as
select eval
from GUCianProgressReport
where sid = @studentID and thesisSerialNumber = @thesisSerialNo and no = @progressReportNo
union
select eval
from NonGUCianProgressReport
where sid = @studentID and thesisSerialNumber = @thesisSerialNo and no = @progressReportNo
go
create proc addPublication
@title varchar(50), @pubDate datetime, @host varchar(50), @place varchar(50), @accepted bit
as
insert into Publication values(@title,@pubDate,@place,@accepted,@host)
go
create proc linkPubThesis
@PubID int, @thesisSerialNo int
as
insert into ThesisHasPublication values(@thesisSerialNo,@PubID)
go

insert into PostGradUser values ('mizo@','123'); 
go
 
create trigger deleteSupervisor
on Supervisor
instead of delete
as
delete from GUCianProgressReport where supid in (select id from deleted)
delete from NonGUCianProgressReport where supid in (select id from deleted)
delete from GUCianStudentRegisterThesis where supid in (select id from deleted)
delete from NonGUCianStudentRegisterThesis where supid in (select id from deleted)
delete from Supervisor where id in (select id from deleted)
delete from PostGradUser where id in (select id from deleted)
go
go
create proc loginUsingEmailandPassowrd 
@email varchar(30),
@password varchar(20),
@success bit output
as
begin
if exists(
select email,password
from PostGradUser
where email=@email and password=@password)
set @success =1
else
set @success=0
end
go

go 
create proc AdminRegister @email varchar(25) , @password varchar(20)
as
insert into PostGradUser values (@email,@password)
declare @x int
select @x = id  from PostGradUser where email = @email and password = @password
insert into Admin values (@x)

go
exec AdminRegister 'aa','123'

INSERT INTO PostGradUser(email, password)
Values('ahmed.mohamed@gmail.com','ahmed21');

INSERT INTO PostGradUser(email, password)
Values('mohamed.walid@yahoo.com', '123456');

INSERT INTO PostGradUser(email, password)
Values('mariam.wael@gmail.com', '10859632');

INSERT INTO PostGradUser(email, password)
Values('farida.sameh@gmail.com', '124587933');

INSERT INTO PostGradUser(email, password)
Values('ali.ahmed@gmail.com','58963254');

INSERT INTO PostGradUser(email, password)
Values('hassan.ali@gmail.com','78856963');

INSERT INTO PostGradUser(email, password)
Values('rana.abdullah@yahoo.com','789632145');

INSERT INTO PostGradUser(email, password)
Values('abdelrahman.magdy@gmail.com','45698745');

INSERT INTO PostGradUser(email, password)
Values('yara.salem@yahoo.com','7412058635');

INSERT INTO PostGradUser(email, password)
Values('adham.seif@yahoo.com','478963211456');

INSERT INTO PostGradUser(email, password)
Values('mahmoud.ali@yahoo.com','48536912');

INSERT INTO PostGradUser(email, password)
Values('aliaa.amgad@yahoo.com','7852100');

INSERT INTO PostGradUser(email, password)
Values('sarah.hamza@gmail.com','741258963');

INSERT INTO PostGradUser(email, password)
Values('ahali@gmail.com','Ali0123');

INSERT INTO PostGradUser(email, password)
Values('kingmazen@gmail.com','mizomizo');

iNSERT INTO PostGradUser(email, password)
Values('kingmazen@gmail.com','mizomizo');


/*GucianStudent*/
INSERT GucianStudent(id,firstName, lastName, type,faculty,address,GPA,undergradID)
Values(1,'Ahmed','Mohamed', 'yes', 'MET', 'Nasr City', 1.7, 490001);

INSERT GucianStudent(id,firstName, lastName, type,faculty,address,GPA,undergradID)
Values(2,'Mohamed','Walid', 'yes', 'IET', '6th of october', 1.0, 491256);


INSERT GucianStudent(id,firstName, lastName, type,faculty,address,GPA,undergradID)
Values(3,'Mariam','Wael', 'yes', 'Pharamcy', 'Maadi', 1.5,494578);

INSERT GucianStudent(id,firstName, lastName, type,faculty,address,GPA,undergradID)
Values(16,'mazne','Wael', 'yes', 'Pharamcy', 'Maadi', 1.5,null);



/*NonGucianStudent*/
INSERT INTO NonGucianStudent(id,firstName, lastName, type,faculty,address,GPA)
Values(4,'Farida','Sameh', 'No', 'Engineering', 'Tagamoo', 2.1);
INSERT INTO NonGucianStudent(id,firstName, lastName, type,faculty,address,GPA)
Values(5,'Ali','Ahmed', 'No', 'Pharmacy', 'Nasr City', 2.5);
INSERT INTO NonGucianStudent(id,firstName, lastName, type,faculty,address,GPA)
Values(6,'Hassan','Ali', 'No', 'Pharmacy', 'Nasr City', 2.8);


/*Supervisors*/

INSERT INTO Supervisor(id, name, faculty)
Values(7,'Rana Abdullah','Engineering')


INSERT INTO Supervisor(id, name, faculty)
Values(8,'Abdelrahman Magdy', 'Pharmacy')


INSERT INTO Supervisor(id, name, faculty)
Values(9,'Yara Salem', 'Pharmacy')

INSERT INTO Supervisor(id, name, faculty)
Values(10,'Adham Seif','Engineering')

/*Admins*/

INSERT INTO Admin(id)
Values(11);

INSERT INTO Admin(id)
Values(12);

INSERT INTO Admin(id)
Values(13);



--GUCianStudentRegisterThesis
INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) 
Values (1,7,1);

INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) 
Values (2,8,2);

INSERT INTO GUCianStudentRegisterThesis(sid, supid, serial_no) 
Values (3,9,4);

/*NonGUCianStudentRegisterThesis*/
INSERT INTO NonGUCianStudentRegisterThesis(sid, supid, serial_no) 
Values (4,10,4);

INSERT INTO NonGUCianStudentRegisterThesis(sid, supid, serial_no) 
Values (5,7,6);

INSERT INTO NonGUCianStudentRegisterThesis(sid, supid, serial_no) 
Values (6,8,8);
/*fayad*/
/*not executed*/
INSERT INTO GUCianProgressReport ( sid, no,date , eval, state, thesisSerialNumber, supid ,description) VALUES(1,1,'5/14/2022' , 1, null , 9 , 7, null )
INSERT INTO GUCianProgressReport ( sid,  no,date , eval, state, thesisSerialNumber, supid ,description) VALUES(1,2,'5/14/2022' , 1, 0 , 9 , 7,'progress report for student 1' )
INSERT INTO GUCianProgressReport ( sid,  no,date , eval, state, thesisSerialNumber, supid,description) VALUES ( 2 ,3, '7/10/2022' , 2, 1 , 10 , 9,'progress report for student 2' )
INSERT INTO GUCianProgressReport ( sid,  no,date , eval, state, thesisSerialNumber, supid,description) VALUES ( 3 , 4,'7/10/2022' , 3, 0 , 11, 8 ,'progress report for student 3')
INSERT INTO NonGUCianProgressReport ( sid, no, date , eval, state, thesisSerialNumber, supid,description) VALUES ( 4 ,5, '2/7/2022' , 0, 1 , 1 ,10 ,'progress report for student 4')
INSERT INTO NonGUCianProgressReport ( sid, no, date , eval, state, thesisSerialNumber, supid,description) VALUES ( 5 , 6,'7/10/2022' , 2, 1 , 2 , 9 ,'progress report for student 5')
INSERT INTO NonGUCianProgressReport ( sid, no,date , eval, state, thesisSerialNumber, supid,description) VALUES ( 6  , 7,'12/27/2022' ,1, 0 , 3 , 7 ,'progress report for student 6')

/*moataz*/
/*Not executed*/
--set identity_insert Thesis ON;
insert into payment values(10000.00,2, 17)
insert into payment values(15000.00,3, 20)
insert into payment values(10000.00,2, 12)

insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('CS','M','thesis 1','11-01-2020','11-01-2022','11-04-2021',60.0,1,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id ,noOfExtensions)values ('DMET','M','thesis 2','11-01-2020','11-01-2021','11-05-2020',60.0,1,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions)values ('EMS','M','thesis 3','11-01-2020','11-01-2021','11-05-2020',60.0,1,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Mechatronics','M','thesis 4','11-01-2020','11-01-2022','11-05-2021',60.0,1,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Networks','M','thesis 5','11-01-2020','11-01-2022','11-06-2021',60.0,1,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Electronics','M','thesis 6','11-01-2020','11-01-2021','11-07-2021',60.0,1,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Management','M','thesis 7','11-01-2020','11-01-2022','11-08-2021',60.0,1,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Finance','M','thesis 8','11-01-2020','11-01-2022','11-09-2021',60.0,1,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('CS','PHD','thesis 9','11-01-2020','11-01-2022','11-010-2021',60.0,2,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('EMS','PHD','thesis 10','11-01-2020','11-01-2022','11-04-2021',60.0,2,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('DMET','PHD','thesis 11','11-01-2020','11-01-2022','11-05-2021',60.0,2,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Electronics','PHD','thesis 12','11-01-2020','11-01-2022','11-06-2021',60.0,2,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Management','PHD','thesis 13','11-01-2020','11-01-2022','11-07-2021',60.0,2,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Networks','PHD','thesis 14','11-01-2020','11-01-2022','11-08-2021',60.0,2,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Finance','PHD','thesis 15','11-01-2020','11-01-2022','11-09-2021',60.0,2,2)
--set identity_insert Thesis OFF;
/*medhat*/
/*executed*/


insert into Installment values('12-27-2022',1,5000,0)
insert into Installment values('01-01-2021',1,5000,0)

insert into Installment values('12-25-2021',2,5000,1)
insert into Installment values('01-22-2021',2,5000,0)
insert into Installment values('02-22-2021',2,5000,0)

insert into Installment values('09-15-2021',3,5000,1)
insert into Installment values('12-12-2021',3,5000,0)

/*not working*/
insert into NonGucianStudentPayForCourse values(4,1,1)
insert into NonGucianStudentPayForCourse values(5,2,2)
insert into NonGucianStudentPayForCourse values(6,3,3)

--set identity_insert Course ON;
insert into Course(fees, creditHours, code) values(10000,4,'101')
insert into Course(fees, creditHours, code) values(15000,6,'102')
insert into Course (fees, creditHours, code)values(20000,8,'103')
insert into Course (fees, creditHours, code) values(25000,8,'104')
insert into Course (fees, creditHours, code) values(30000,10,'105')
insert into Course (fees, creditHours, code) values(35000,12,'106')
insert into Course (fees, creditHours, code) values(25000,8,'107')
insert into Course (fees, creditHours, code) values(7000,3,'108')
insert into Course (fees, creditHours, code) values(10000,4,'109')
insert into Course (fees, creditHours, code) values(20000,8,'110')
insert into Course (fees, creditHours, code) values(23000,8,'111')
insert into Course (fees, creditHours, code) values(25000,9,'112')
insert into Course (fees, creditHours, code) values(25000,9,'113')
insert into Course (fees,creditHours, code) values(30000,10,'114')
insert into Course (fees, creditHours, code) values(12000,5,'115')



insert into NonGucianStudentTakeCourse values(4,1,85)
insert into NonGucianStudentTakeCourse values(5,2,90.5)
insert into NonGucianStudentTakeCourse values(6,3,93)
insert into NonGucianStudentTakeCourse values(5,4,89.6)
insert into NonGucianStudentTakeCourse values(4,5,87.9)
insert into NonGucianStudentTakeCourse values(6,6,80.4)
insert into NonGucianStudentTakeCourse values(6,7,76.8)
insert into NonGucianStudentTakeCourse values(5,8,80.5)
insert into NonGucianStudentTakeCourse values(4,9,92.7)
insert into NonGucianStudentTakeCourse values(5,10,82.32)
insert into NonGucianStudentTakeCourse values(6,11,87.0)
insert into NonGucianStudentTakeCourse values(4,12,88)
insert into NonGucianStudentTakeCourse values(4,13,70.526)
insert into NonGucianStudentTakeCourse values(5,14,99.3527)
insert into NonGucianStudentTakeCourse values(6,15,92.898)


/*last point*/

insert into examiner values (14,'Ahmed Ali','Data science',1);
insert into examiner values (15,'Mazen Alaa','Front End',0);


insert into Defense values (111,'11-04-2021','H12', 90 )
insert into Defense values (151,'11-06-2021','H13',80)
insert into Defense values (241,'11-06-2021','H14',60)
insert into Defense values (131,'11-05-2020' ,'H15',50)
insert into Defense values (161,'11-07-2021' ,'H16',85)
insert into Defense values (231,'11-05-2021' ,'H17',95)

insert into ExaminerEvaluateDefense values ('11-04-2021',111,14,'wonderful')
insert into ExaminerEvaluateDefense values('11-06-2021',151,14,'very good')
insert into ExaminerEvaluateDefense values('11-06-2021',241,15,'great')
insert into ExaminerEvaluateDefense values('11-05-2020',131,14,'very good')
insert into ExaminerEvaluateDefense values('11-07-2021',161,14,'good')
insert into ExaminerEvaluateDefense values('11-05-2021',231,15,'excellent')

insert into Publication values('fw','1-1-2020','cairo',1,'dd')
insert into Publication values('fw','1-1-2020','cairo',0,'dd')
insert into Publication values('fw','1-1-2020','ir',1,'dd')
insert into ThesisHasPublication values (111,1)
insert into ThesisHasPublication values(122,2)
insert into ThesisHasPublication values (131,3)

insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Finance','PHD','thesis 15','11-01-2020','11-01-2022','11-09-2021',60.0,2,2)
insert into Thesis ( field, type, title, startDate, endDate, defenseDate, grade, payment_id , noOfExtensions) values ('Finance','PHD','thesis 15','11-01-2020','11-01-2022','11-09-2021',60.0,2,2)
 
INSERT INTO GUCianProgressReport ( sid, no,date , eval, state, thesisSerialNumber, supid) VALUES(1,11,'5/14/2022' , 0, 0 , 15 , 7 )

INSERT INTO GUCianProgressReport ( sid, no , date,eval, state, thesisSerialNumber, supid) VALUES(2,12,'5/14/2022' , 1, 0 , 16 , 7 )
INSERT INTO GUCianProgressReport ( sid, no,date , eval, state, thesisSerialNumber, supid) VALUES(2,11,'5/14/2022' , 0, 0 , 17 , 7 )
INSERT INTO NonGUCianProgressReport ( sid,no, date , eval, state, thesisSerialNumber, supid) VALUES ( 4 ,13, '2/7/2022' , 0, 1, 17, 10 )



