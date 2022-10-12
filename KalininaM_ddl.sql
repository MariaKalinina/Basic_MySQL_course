DROP DATABASE IF EXISTS university;
CREATE DATABASE university;
USE university; 


DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id BIGINT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
	firstname varchar(50) COMMENT 'имя',
	fathers_name varchar(50) COMMENT 'отчество',
	lastname varchar(50) COMMENT 'фамилия',
	email varchar(100) UNIQUE, 
	password_hash varchar(100) NOT NULL,
	birthdate date NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	is_deleted bit DEFAULT 0,
	INDEX users_firstname_lastname_idx(firstname, lastname)
);

DROP TABLE IF EXISTS faculties;
CREATE TABLE faculties (
	id_name varchar(5) NOT NULL UNIQUE COMMENT 'аббревиатура обозначения факультета',
	name varchar(100) COMMENT 'название факультета',
	years tinyint COMMENT 'количество лет обучения',
	created_at DATETIME DEFAULT NOW(),
	is_deleted bit default 0,
	INDEX faculty_name_idx(name),
	PRIMARY KEY (id_name)
);

DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
	id BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	name varchar(100) NOT NULL COMMENT 'Название кафедры',
	faculty_id varchar(5) NOT NULL COMMENT 'Деканат, к которому относится кафедра',
	hod_id bigint COMMENT 'Идентификатор заведующего',
	created_at DATETIME DEFAULT NOW(),
	short_name varchar(5) COMMENT 'аббревиатура обозначения кафедры',
	is_deleted bit default 0,
	INDEX department_name_idx(name),
	
	PRIMARY KEY (id),
	FOREIGN KEY (faculty_id) REFERENCES faculties(id_name) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (hod_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS classes;
CREATE TABLE classes (
	id BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	faculty_id varchar(5) NOT NULL,
	edu_year tinyint NOT NULL, 
	group_num int NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	is_deleted bit default 0,
	INDEX classes_year_num_name_idx(edu_year, group_num, faculty_id),
	
	PRIMARY KEY (id),
	FOREIGN KEY (faculty_id) REFERENCES faculties(id_name) ON UPDATE CASCADE ON DELETE CASCADE
);


DROP TABLE IF EXISTS students;
CREATE TABLE students (
	id BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	user_id BIGINT NOT NULL,
	faculty_id varchar(5) NOT NULL,
	`status` ENUM('активный', 'отчислен', 'академический отпуск'),
	PRIMARY KEY (id),
	
	FOREIGN KEY (faculty_id) REFERENCES faculties(id_name) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS students_classes;
CREATE TABLE students_classes (
	student_id BIGINT NOT NULL,
	class_id bigint NOT NULL,
	
	PRIMARY KEY (student_id, class_id),
	FOREIGN KEY (student_id) REFERENCES students(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS science_degrees;
CREATE TABLE science_degrees (
	id BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	science_type varchar(100),
	degree_type ENUM('кандидат', 'доктор'),
	PRIMARY KEY (id),
	INDEX degree_idx(degree_type, science_type)
);

DROP TABLE IF EXISTS professors;
CREATE TABLE professors (
	id BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	user_id BIGINT  NOT NULL,
	degree_id bigint,
	diploma varchar(100) COMMENT 'Номер диплома о высшем образовании',
	diploma_year YEAR COMMENT 'Год получения диплома',
	`status` ENUM('активный', 'лист нетрудоспособности', 'отпуск', 'отпуск по уходу за ребенком'),
	academic_title ENUM('нет', 'доцент', 'профессор', 'академик'),
	created_at DATETIME DEFAULT NOW(),
	edit_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	
	FOREIGN KEY (degree_id) REFERENCES science_degrees(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS professors_departments;
CREATE TABLE professors_departments (
	professor_id BIGINT  NOT NULL,
	department_id bigint NOT NULL,
	place ENUM('ассистент', 'старший преподаватель', 'доцент', 'профессор', 'лаборант', 'препаратор'),
	rate FLOAT NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	edit_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

	PRIMARY KEY (professor_id, department_id),
	FOREIGN KEY (professor_id) REFERENCES professors(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS subjects;
CREATE TABLE subjects (
	id BIGINT NOT NULL AUTO_INCREMENT UNIQUE,
	name varchar(100),
	
	PRIMARY KEY (id),
	INDEX subject_idx(name)
);

DROP TABLE IF EXISTS curiculum;
CREATE TABLE curiculum (
	subject_id BIGINT NOT NULL,
	faculty_id varchar(5) NOT NULL,
	department_id bigint NOT NULL,
	edu_year TINYINT NOT NULL,
	hours int NOT NULL,
	
	PRIMARY KEY (subject_id, faculty_id),
	FOREIGN KEY (subject_id) REFERENCES subjects(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (faculty_id) REFERENCES faculties(id_name) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS subject_prof_group;
CREATE TABLE subject_prof_group(
	subject_id BIGINT NOT NULL,
	professor_id bigint NOT NULL,
	group_id bigint NOT NULL,
	
	PRIMARY KEY (subject_id, professor_id, group_id),
	FOREIGN KEY (subject_id) REFERENCES subjects(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (professor_id) REFERENCES professors(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (group_id) REFERENCES classes(id) ON UPDATE CASCADE ON DELETE CASCADE
);
