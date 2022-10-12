-- ПРЕДСТАВЛЕНИЯ

-- 1. Список всех студентов, отсортированный по факультетам 
 
CREATE OR REPLACE VIEW students_list AS
SELECT concat(u.lastname, ' ', u.firstname, ' ', u.fathers_name) AS 'ФИО', 
f.name AS 'Факультет',
concat(c.edu_year, c.group_num) AS 'группа'
FROM users u 
JOIN students s ON u.id = s.user_id
JOIN students_classes sc ON sc.student_id = s.id
JOIN classes c ON sc.class_id = c.id
JOIN faculties f ON c.faculty_id = f.id_name 
ORDER BY f.name, c.edu_year, c.group_num
WITH CHECK OPTION;

SELECT * FROM university.students_list;

-- 2. Список всех учебных групп преподавателей, отсортированный по кафедрам 
-- с указанием преподаваемой дисциплины

 
CREATE OR REPLACE VIEW professors_groups AS
SELECT d.name AS 'Кафедра', 
concat(u.lastname, ' ', u.firstname, ' ', u.fathers_name) AS 'ФИО', 
s.name AS 'Дисциплина',
concat(c.edu_year, c.group_num, c.faculty_id) AS 'Группа'
FROM users u
JOIN professors p ON p.user_id = u.id
JOIN professors_departments pd ON p.id = pd.professor_id 
JOIN departments d ON pd.department_id = d.id
JOIN subject_prof_group spg ON spg.professor_id = p.id 
JOIN subjects s ON spg.subject_id = s.id 
JOIN classes c ON spg.group_id = c.id
ORDER BY d.name
WITH CHECK OPTION; 

