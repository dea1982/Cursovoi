use ejd;

-- Выводим список учеников, у которых возраст больше определенной даты.
select name, surname, patronymic
from students s
where birthday > '2012-01-01';

-- Выводим список учеников, которым выставлялись отметки.
select name, surname, patronymic
from students
join journals on students.id = journals.st_id;

-- Подсчет и сортировка каждого периода обучения.
select title, count(title)
from study_periods sp
group by title
order by title;

-- Выборка на вложеный запрос только тех учеников, у которых закреплен родитель
select students.name, students.surname
from students
where (select id from parents where parents.st_id = students.id);

-- Представление на сортировку по фамилии по алфавиту
create or replace view students_view as select * from students order by surname;

-- Представление на сортировку отмето по возрастанию
create or replace view marks_view as select * from journals order by mark;

-- Процедура подсчета среднего арифметического по отметкам учеников с округлением
delimiter //
create procedure proc_avg()
begin
	select st_id, `date`, round(avg(mark)) from journals group by subject_id order by st_id;
end //
delimiter ;
-- Триггер на добавление в таблицу
delimiter //
create trigger students_count after insert on students
for each row
begin
	select count(*) into @total from students;
end //
delimiter ;
