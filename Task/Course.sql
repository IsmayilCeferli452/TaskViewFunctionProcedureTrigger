create database Course

use Course

create table Students(
[Id] int primary key identity(1,1),
[Name] nvarchar(50) not null,
[Surname] nvarchar(50),
[Age] int check ([Age] > 18),
[Address] nvarchar(100),
[Email] nvarchar(50) unique
)

select * from Students

insert into Students([Name],[Surname],[Age],[Address],[Email])
values ('Ismayil','Ceferli',24,'Hezi Aslanov','ismayil123@gmail.com'),
	   ('Afide','Veliyeva',38,'Iceriseher','afide123@gmail.com'),
	   ('Nesir','Dadasov',27,'Bineqedi','nesir123@gmail.com'),
	   ('Ayxan','Eliyev',25,'Insaatcilar','ayxan123@gmail.com'),
	   ('Hacixan','Hacixanov',19,'Insaatcilar','haci123@gmail.com'),
	   ('Nurlan','Umudov',22,'Hovsan','nurlan123@gmail.com'),
	   ('Behruz','Eliyev',37,'28 May','behruz123@gmail.com'),
	   ('Resad','Agayev',21,'Neftciler','resad123@gmail.com')

	   
create table StudentArchives(
[Id] int primary key identity(1,1),
[Operation] nvarchar(20),
[Date] datetime,
[StudentId] int,
[StudentName] nvarchar(50),
[StudentSurname] nvarchar(50),
[StudentAge] int,
[StudentAddress] nvarchar(100),
[StudentEmail] nvarchar(50)
)


select * from Students
select * from StudentArchives

--Delete(procedure)
create procedure usp_deleteStudent
@id int
as
begin
	delete from Students where Students.Id = @id
end

--Trigger(StudentArchives)
create trigger trg_deleteStudentArchives on Students
after delete
as
begin
	insert into StudentArchives([Operation],[Date],[StudentId],[StudentName],[StudentSurname]
	,[StudentAge],[StudentAddress],[StudentEmail])
	select 'Delete', GETDATE(), [Id], [Name],[Surname], [Age], [Address], [Email] from deleted
end

--Test
select * from Students
select * from StudentArchives

exec usp_deleteStudent 1
exec usp_deleteStudent 5
exec usp_deleteStudent 8



