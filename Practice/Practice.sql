--use Practice

select * from Students
select * from Employees

insert into Students([Name],[Surname],[Age])
values  ('Nesir','Dadasov',27),
		('Fatime','Qayxanova',22),
		('Afide','Veliyeva',38),
		('Nurlan','Umudov',22),
		('Behruz','Eliyev',37)

update Students
set [Id] = 9
where [Age] = 37

--View
create view getStudentsWithId
as
select * from Students where Students.Id > 3

select * from getStudentsWithId

create view getStudentsWithAge
as
select top 5 * from Students where Students.Age > 20

select * from getStudentsWithAge

--Function
create function sayHelloWorld()
returns nvarchar(50)
as
begin
	return 'Hello World'
end

select dbo.sayHelloWorld() as 'Message'
--variable
declare @text nvarchar(50) = (select dbo.sayHelloWorld() as 'Message')
print @text

create function dbo.ShowText(@text nvarchar(100))
returns nvarchar(50)
as
begin
	return @text
end

select dbo.ShowText('Example') as 'Message'

create function dbo.SumOfNums(@num1 int, @num2 int)
returns int
as
begin
	return @num1 + @num2
end

select dbo.SumOfNums(1,2) as 'Sum'

declare @id int = (select dbo.SumOfNums(1,2) as 'Sum')
select * from Students where [Id] = @id

print @id

create function dbo.getStudentsByAge(@age int)
returns int
as
begin
declare @count int
select @count = COUNT(*) from Students where [Age] > @age
return @count
end

select dbo.getStudentsByAge(20) as 'Count'

create function dbo.GetAllStudents()
returns table
as
return (select * from Students)

select * from dbo.GetAllStudents()

create function dbo.searchStudentsByName(@text nvarchar(100))
returns table
as
return(
	select * from Students where Students.Name like '%' + @text + '%'
)

select * from dbo.searchStudentsByName('c')


--Procedure
create procedure usp_ShowText
as
begin
	print 'Example'
end

exec usp_ShowText

create procedure usp_ShowText2
@text nvarchar(100)
as
begin
	print @text
end

exec usp_ShowText2 'Example2'

select * from Students

create procedure usp_createStudent
@id int,
@name nvarchar(50),
@surname nvarchar(50),
@age int
as
begin
	insert into Students([Id],[Age],[Name],[Surname])
	values(@id,@age,@name,@surname)
end

exec usp_createStudent 10,24,'Ismayil','Ceferli'

select * from Students

create procedure usp_deleteStudentById
@id int
as
begin
	delete from Students where [Id] = @id
end

exec usp_deleteStudentById 9

create function dbo.getStudentsByAvgAge(@id int)
returns int
as
begin
	declare @avgAge int
	select @avgAge = AVG([Age]) from Students where [Id] > @id
	return @avgAge
end

select dbo.getStudentsByAvgAge(3)

create procedure usp_changeStudentNameByCondition
@id int,
@name nvarchar(50)
as
begin
	declare @avgAge int = (select dbo.getStudentsByAvgAge(@id))
	update Students
	set [Name] = @name
	where [Age] > @avgAge
end

exec usp_changeStudentNameByCondition 3, 'XXX'

select * from Students

--Trigger

create table StudentsLogs(
[Id] int primary key identity(1,1),
[StudentId] int,
[Operation] nvarchar(20),
[Date] datetime
)

create trigger trg_createStudentLogs on Students
after insert
as
begin
	insert into StudentsLogs([StudentId],[Operation],[Date])
	select [Id], 'Insert', GETDATE() from inserted
end

insert into Students([Id],[Name],[Surname],[Age])
values(10,'Rufet','Ismayilov',19)

select * from StudentsLogs
select * from Students

create trigger trg_deleteStudentLogs on Students
after delete
as
begin
	insert into StudentsLogs([StudentId],[Operation],[Date])
	select [Id], 'Insert', GETDATE() from deleted
end

delete from Students where [Id] = 9
delete from Students where [Id] = 7

select * from StudentsLogs
select * from Students