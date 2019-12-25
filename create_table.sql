-- Курсовой ЭЖД

-- Создание БД
drop database if exists ejd;
create database ejd;
use ejd;

-- Создание таблицы "Классы"
drop table if exists classes;
create table classes (
	id serial primary key,
	class varchar(3) comment 'Класс',
	class_type enum('in-depth', 'general education') comment 'Тип класса',
	index (class)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Учителя"
drop table if exists teachers;
create table teachers (
	id serial primary key,
	name varchar(50) comment 'Имя учителя',
	surname varchar(50) comment 'Фамилия учителя',
	patronymic varchar(50) comment 'Отчество учителя',
	birthday date comment 'Дата рождения',
	gender enum('m', 'f') comment 'Пол',
	class_id bigint unsigned null comment 'id класса где классный руководитель',
	index teachers_name_surname_patronymic_idx(name, surname, patronymic),
	foreign key (class_id) references classes(id)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Предметы"
drop table if exists subjects;
create table subjects (
	id serial primary key,
	class_id bigint unsigned not null comment 'id класса',
	item_name varchar(50) comment 'Название предмета',
	teacher_id bigint unsigned not null comment 'id учителя',
	index (item_name),
	foreign key (teacher_id) references teachers(id),
	foreign key (class_id) references classes(id)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Ученики"
drop table if exists students;
create table students (
	id serial primary key,
	name varchar(50) comment 'Имя ученика',
	surname varchar(50) comment 'Фамилия ученика',
	patronymic varchar(50) comment 'Отчество ученика',
	birthday date comment 'Дата рождения',
	gender enum('m', 'f') comment 'Пол',
	class_id bigint unsigned not null comment 'id класса',
	index students_name_surname_patronymic_idx(name, surname, patronymic),
	foreign key (class_id) references classes(id)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Родители"
drop table if exists parents;
create table parents (
	id serial primary key,
	name varchar(50) comment 'Имя родителя',
	surname varchar(50) comment 'Фамилия родителя',
	patronymic varchar(50) comment 'Отчество родителя',
	gender enum('m', 'f') comment 'Пол',
	st_id bigint unsigned not null comment 'id ученика',
	index parents_name_surname_patronymic_idx(name, surname, patronymic),
	foreign key (st_id) references students(id)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Учебные периоды"
drop table if exists study_periods;
create table study_periods (
	id serial primary key,
	title varchar(50) comment 'Название',
	date_beginning date comment 'Дата начала',
	date_expiration date comment 'Дата окончания',
	index (title)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Каникулы"
drop table if exists holidays;
create table holidays (
	id serial primary key,
	title varchar(50) comment 'Название',
	date_beginning date comment 'Дата начала',
	date_expiration date comment 'Дата окончания',
	study_period_id bigint unsigned not null comment 'id учебных периодов',
	index (title),
	foreign key (study_period_id) references study_periods(id)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Посещаемость"
drop table if exists attendances;
create table attendances (
	id serial primary key,
	class_id bigint unsigned not null comment 'id класса',
	`date` date comment 'Дата',
	st_id bigint unsigned not null comment 'id ученика',
	attendance enum ('Б', 'От') comment 'Б - болел, От - отсутствовал',
	foreign key (class_id) references classes(id),
	foreign key (st_id) references students(id)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Сообщения"
drop table if exists messages;
create table messages (
	id serial primary key,
	from_user_id bigint unsigned not null comment 'id от ученик, родитель, учитель',
    to_user_id bigint unsigned not null comment 'id к ученик, родитель, учитель',
    body text comment 'Текст сообщения',
    created_at datetime default now() comment 'Дата и время создания',
    index  messages_from_user_id (from_user_id),
    index messages_to_user_id (to_user_id)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Журналы"
drop table if exists journals;
create table journals (
	id serial primary key,
	class_id bigint unsigned not null comment 'id класса',
	subject_id bigint unsigned not null comment 'id предмета',
	study_period_id bigint unsigned not null comment 'id учебных периодов',
	st_id bigint unsigned not null comment 'id ученика',
	`date` date comment 'Дата',
	mark enum('1', '2', '3', '4', '5') comment 'Отметка',
	teacher_id bigint unsigned not null comment 'id учителя',
	index (mark),
	foreign key (class_id) references classes(id),
	foreign key (subject_id) references subjects(id),
	foreign key (study_period_id) references study_periods(id),
	foreign key (st_id) references students(id),
	foreign key (teacher_id) references teachers(id)
) DEFAULT CHARSET=utf8;

-- Создание таблицы "Доска объявлений"
drop table if exists bulletin_boards;
create table bulletin_boards (
	id serial primary key,
	subject text comment 'Тема',
	message text comment 'Сообщение',
	teacher_id bigint unsigned not null comment 'id учителя',
	foreign key (teacher_id) references teachers(id)
) DEFAULT CHARSET=utf8;