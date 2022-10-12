-- Примеры запросов
USE university;

/*
 * 1
 * Вывести ФИО старших преподавателей кафедры хирургии
*/

-- через вложенные запросы
SELECT concat(u.lastname, ' ', u.firstname, ' ', u.fathers_name) AS 'ФИО'
FROM users u
WHERE id = (
SELECT user_id FROM professors p 
	WHERE id = 
		(SELECT professor_id FROM professors_departments pd 
			WHERE department_id = 
				(SELECT id FROM departments d 
				WHERE name = 'Хирургии') AND place = 'старший преподаватель'
));


-- с помощью JOIN
SELECT concat(u.lastname, ' ', u.firstname, ' ', u.fathers_name) AS 'ФИО'
FROM users u
JOIN professors p ON p.user_id = u.id
JOIN professors_departments pd ON p.id = pd.professor_id 
JOIN departments d ON d.id = pd.department_id 
WHERE d.name = 'Хирургии' AND pd.place = 'старший преподаватель';


/*
 * 2
 * На каком курсе и факультете учится Elian	Maynard	Graham
*/

SELECT c.edu_year AS 'Курс', f.name AS 'Факультет' FROM classes c
JOIN faculties f ON f.id_name = c.faculty_id 
JOIN students_classes sc ON c.id = sc.class_id 
JOIN students s ON s.id = sc.student_id 
JOIN users u ON u.id = s.user_id 
WHERE firstname = 'Elian' AND fathers_name = 'Maynard' AND lastname = 'Graham';



/*
 * 3 
 * Список студентов всех групп преподавателя Leola Chester Fay отсортированный по группам
*/

SELECT concat(u.lastname, ' ', u.firstname, ' ', u.fathers_name) AS 'ФИО',  
concat(c.edu_year, c.group_num, c.faculty_id) AS 'группа'
FROM users u 
JOIN students s ON u.id = s.user_id
JOIN students_classes sc ON sc.student_id = s.id
JOIN subject_prof_group spg ON sc.class_id = spg.group_id
JOIN classes c ON sc.class_id = c.id
JOIN professors p ON spg.professor_id = p.id 
JOIN users u2 ON p.user_id = u2.id 
WHERE u2.firstname = 'Leola' AND u2.fathers_name = 'Chester' AND u2.lastname = 'Fay'
ORDER BY concat(c.edu_year, c.group_num, c.faculty_id) desc;


/*
 * 4 
 * Сколько сотрудников университета имеют степень кандидата медицинских наук и кандидата педагогических наук?
*/
SELECT sd.science_type, count(p.id) AS 'количество' 
FROM professors p 
JOIN science_degrees sd ON p.degree_id = sd.id 
WHERE (sd.science_type LIKE  'мед%' OR sd.science_type LIKE 'пед%')  AND sd.degree_type LIKE 'кан%'
GROUP BY sd.science_type;

/*sc.student_id, c.id, c.edu_year,  f.name 
 * 5
 * Сколько студентов обучается на 1 курсе лечебного факультета?
*/
SELECT count(sc.student_id) AS 'количество'
FROM classes c 
JOIN faculties f ON c.faculty_id = f.id_name
JOIN students_classes sc ON sc.class_id = c.id
WHERE f.name = 'Лечебный' AND c.edu_year = 1;

/*
 * 6
 * Сколько студентов обучается на старших курсах (4,5,6) по факультетам?
 */
SELECT c.edu_year, 
c.faculty_id, 
count(sc.student_id) 
FROM students_classes sc 
JOIN classes c ON c.id = sc.class_id
WHERE c.edu_year > 3
GROUP BY   c.faculty_id;
