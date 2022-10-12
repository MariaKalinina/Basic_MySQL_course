-- Функция подсчета часовой нагрузки на каждого преподавателя по id преподавателя


DROP FUNCTION IF EXISTS professor_hours;
delimiter //
CREATE FUNCTION professor_hours(prof_id int)
RETURNS int READS SQL DATA 
	BEGIN
		DECLARE lech int; -- часы на лечебный факультет
		DECLARE ped int; -- часы на педиатрический факультет
		DECLARE st int; -- часы на стоматологический факультет
	
	
		SET lech = (
		SELECT (count(c2.faculty_id) * c.hours) 
			FROM subject_prof_group spg 
			JOIN classes c2 ON spg.group_id = c2.id -- выбираем группы, которые ведет преподаватель
			JOIN curiculum c ON c.subject_id = spg.subject_id AND c.faculty_id = c2.faculty_id  -- выбираем соответсвующий план по часам
			WHERE spg.professor_id = prof_id AND c2.faculty_id = 'леч'); -- сортируем по преподавателю и факультету
	

		SET ped = (
		SELECT (count(c2.faculty_id) * c.hours) AS hours
			FROM subject_prof_group spg 
			JOIN classes c2 ON spg.group_id = c2.id
			JOIN curiculum c ON c.subject_id = spg.subject_id AND c.faculty_id = c2.faculty_id 
			WHERE spg.professor_id = prof_id AND c2.faculty_id = 'пед');
		
		SET st = (
		SELECT (count(c2.faculty_id) * c.hours) AS hours
			FROM subject_prof_group spg 
			JOIN classes c2 ON spg.group_id = c2.id
			JOIN curiculum c ON c.subject_id = spg.subject_id AND c.faculty_id = c2.faculty_id 
			WHERE spg.professor_id = prof_id AND c2.faculty_id = 'ст');
		
		RETURN lech + ped + st; -- суммируем все значения по факультетам для получения общей нагрузки
END//
	
delimiter ;
	

SELECT professor_hours(25) AS 'ВСЕГО ЧАСОВ';