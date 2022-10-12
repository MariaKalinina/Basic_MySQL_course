

--  Процедура, выдающая заведующему список сотрудников, 
-- у которых их академическое звание не соответствует научной степени 
-- (д.м.н./д.п.н. и НЕ профессор, к.м.н./к.п.н и не доцент) )
-- (для рекомендации сбора документов на это звание, или смены должности)

DROP PROCEDURE IF EXISTS non_compliance;
CREATE PROCEDURE non_compliance(IN hod_id INT)
BEGIN
	SELECT DISTINCT d.id, p.id, concat(u.lastname, ' ', u.fathers_name, ' ', u.firstname) AS 'ФИО',
	pd.place AS 'Должность',
	concat(sd.degree_type, ' ', sd.science_type) AS 'Ученая степень', 
	p.academic_title AS 'Звание' 
	FROM users u -- берем данные о ФИО из юзеров
	JOIN professors p ON p.user_id = u.id -- таблицу юзеров соединяем с таблицей преподавателей по user_id
	JOIN science_degrees sd ON sd.id = p.degree_id -- соединяем с таблицей в которой хранятся данные о научных степенях
	JOIN professors_departments pd ON pd.professor_id = p.id -- соединяем с таблицей принадлежности преподавателя кафедре
	JOIN departments d ON pd.department_id = d.id -- соединяем с таблицей кафедр, чтоб оттуда выбрать нужный hod_id
	WHERE d.hod_id = hod_id -- сортируем по id  заведующего кафедрой
		AND ((sd.degree_type = 'доктор' AND p.academic_title NOT LIKE 'профессор') -- выбираем докторов найк и не профессоров
		OR (sd.degree_type = 'кандидат' AND p.academic_title NOT LIKE 'доцент')); -- выбираем кандидатов наук и не доцентов
END


CALL non_compliance(6);
