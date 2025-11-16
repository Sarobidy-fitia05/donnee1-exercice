CREATE DATABASE exerciceDonne


CREATE TABLE team (
    id SERIAL  PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);


CREATE TABLE employee (
    id SERIAL  PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    salary INT NOT NULL
);


CREATE TABLE belong (
    Employee_id INT NOT NULL,
    Team_id INT NOT NULL,
    PRIMARY KEY (Employee_id, Team_id),
    FOREIGN KEY (Employee_id) REFERENCES Employee(id),
    FOREIGN KEY (Team_id) REFERENCES Team(id)
);



CREATE TABLE leave (
    id SERIAL  PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);



CREATE TABLE take (
    Employee_id INT NOT NULL,
    Leave_id INT NOT NULL,
    PRIMARY KEY (Employee_id, Leave_id),
    FOREIGN KEY (Employee_id) REFERENCES Employee(id),
    FOREIGN KEY (Leave_id) REFERENCES Leave(id)
);



------------------Reponses ------------------------------
-- 1. Affichage de l'id, first_name, last_name des employés qui n'ont pas d’équipe.
SELECT employee.id, employee.first_name, employee.last_name
FROM employee
LEFT JOIN belong ON employee.id = belong.employee_id
WHERE belong.team_id IS NULL;


-- 2. Affichage de l’id, first_name, last_name des employés qui n’ont jamais pris de congé de leur vie.
SELECT employee.id, employee.first_name, employee.last_name
FROM employee
LEFT JOIN take ON employee.id = take.employee_id
WHERE take.leave_id IS NULL;

-- 3. Affichage des congés de tel sorte qu'on voie l'id du congé, le début du congé, la fin du congé, le nom & prénom de l'employé qui prend congé et le nom de son équipe.
SELECT 
  leave_table.id,
  leave_table.start_date,
  leave_table.end_date,
  employee.first_name,
  employee.last_name,
  team.name
FROM leave_table
JOIN take ON leave_table.id = take.leave_id
JOIN employee ON take.employee_id = employee.id
LEFT JOIN belong ON employee.id = belong.employee_id
LEFT JOIN team ON belong.team_id = team.id;

-- 4. Affichage par nombre d’employés par contract_type
SELECT contract_type, COUNT(*) AS nb_employees
FROM employee
GROUP BY contract_type;

-- 5. Affichage du nombre d'employés en congé aujourd'hui.
SELECT COUNT(DISTINCT take.employee_id) AS nb_employees_on_leave
FROM take
JOIN leave_table ON take.leave_id = leave_table.id
WHERE CURRENT_DATE BETWEEN leave_table.start_date AND leave_table.end_date;

-- 6. Affichage de l’id, le nom, le prénom de tous les employés + le nom de leur équipe qui sont en congé aujourd’hui

SELECT 
    employee.id,
    employee.first_name,
    employee.last_name,
    team.name AS team_name
FROM employee
JOIN take ON employee.id = take.employee_id
JOIN leave_table ON take.leave_id = leave_table.id
LEFT JOIN belong ON employee.id = belong.employee_id
LEFT JOIN team ON belong.team_id = team.id
WHERE CURRENT_DATE BETWEEN leave_table.start_date AND leave_table.end_date;