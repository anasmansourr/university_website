-- MySQL schema and seed data for the University Management API
CREATE DATABASE IF NOT EXISTS university;
USE university;

CREATE TABLE IF NOT EXISTS students (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  major VARCHAR(255) NOT NULL,
  year VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'active',
  gpa DECIMAL(4,2) DEFAULT NULL,
  advisor VARCHAR(255) NOT NULL DEFAULT 'Not Assigned',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS courses (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE,
  title VARCHAR(255) NOT NULL,
  instructor VARCHAR(255) NOT NULL,
  credits INT NOT NULL DEFAULT 0,
  capacity INT NOT NULL DEFAULT 0,
  schedule_day VARCHAR(50) NOT NULL DEFAULT 'TBD',
  schedule_time VARCHAR(50) NOT NULL DEFAULT 'TBD',
  schedule_location VARCHAR(255) NOT NULL DEFAULT 'TBD',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS announcements (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  detail TEXT NOT NULL,
  announcement_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  role ENUM('admin', 'doctor', 'advisor', 'student') NOT NULL,
  password VARCHAR(255) NOT NULL,
  student_id VARCHAR(50) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_user_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS enrollments (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  student_id VARCHAR(50) NOT NULL,
  course_id VARCHAR(50) NOT NULL,
  status ENUM('enrolled', 'waitlisted', 'dropped') NOT NULL DEFAULT 'enrolled',
  grade_letter VARCHAR(3) DEFAULT NULL,
  grade_points DECIMAL(3,2) DEFAULT NULL,
  grade_released TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_enrollment (student_id, course_id),
  CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- Migration: Add grade_released column if it doesn't exist (for existing databases)
-- Run this if you have an existing database: ALTER TABLE enrollments ADD COLUMN grade_released TINYINT(1) DEFAULT 0;

-- Seed data (idempotent)
INSERT INTO students (id, name, email, major, year, status, gpa, advisor) VALUES
  ('stu-001', 'Amelia Flores', 'amelia.flores@campus.edu', 'Computer Science', 'Senior', 'active', 3.85, 'Dr. Stone'),
  ('stu-002', 'Noah Harper', 'noah.harper@campus.edu', 'Mechanical Engineering', 'Junior', 'active', 3.50, 'Dr. Chen'),
  ('stu-003', 'Sophia Lee', 'sophia.lee@campus.edu', 'Business Administration', 'Sophomore', 'probation', 2.60, 'Prof. Patel'),
  ('stu-004', 'Liam Walker', 'liam.walker@campus.edu', 'Mathematics', 'Senior', 'active', 3.92, 'Dr. Ramos'),
  ('stu-005', 'Ava Robinson', 'ava.robinson@campus.edu', 'Electrical Engineering', 'Sophomore', 'active', 3.25, 'Dr. Malik'),
  ('stu-006', 'Ethan Carter', 'ethan.carter@campus.edu', 'Physics', 'Junior', 'active', 3.10, 'Dr. Silva'),
  ('stu-007', 'Mia Thompson', 'mia.thompson@campus.edu', 'English Literature', 'Senior', 'active', 3.60, 'Prof. Allen'),
  ('stu-008', 'Oliver Perez', 'oliver.perez@campus.edu', 'Information Systems', 'Sophomore', 'active', 2.95, 'Dr. Nguyen'),
  ('stu-009', 'Isabella Rivera', 'isabella.rivera@campus.edu', 'Chemistry', 'Junior', 'active', 3.40, 'Dr. Alvarez')
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  email = VALUES(email),
  major = VALUES(major),
  year = VALUES(year),
  status = VALUES(status),
  gpa = VALUES(gpa),
  advisor = VALUES(advisor);

INSERT INTO courses (id, code, title, instructor, credits, capacity, schedule_day, schedule_time, schedule_location) VALUES
  ('course-001', 'CS401', 'Distributed Systems', 'Dr. Kline', 4, 30, 'Mon/Wed', '10:00 - 11:30', 'Room CS210'),
  ('course-002', 'ME320', 'Fluid Mechanics', 'Dr. DeMarco', 3, 28, 'Tue/Thu', '09:00 - 10:15', 'Lab E3'),
  ('course-003', 'BUS205', 'Managerial Accounting', 'Prof. Wright', 3, 35, 'Mon/Wed', '13:00 - 14:15', 'Room B115'),
  ('course-004', 'MATH450', 'Numerical Analysis', 'Dr. Ahmad', 3, 25, 'Fri', '08:30 - 11:30', 'Room M302'),
  ('course-005', 'EE210', 'Circuits I', 'Dr. Malik', 3, 40, 'Mon/Wed', '14:00 - 15:15', 'Room EE120'),
  ('course-006', 'PHYS330', 'Quantum Mechanics', 'Dr. Silva', 4, 25, 'Tue/Thu', '11:00 - 12:30', 'Room PH201'),
  ('course-007', 'ENG310', 'Modern Poetry', 'Prof. Allen', 3, 30, 'Mon/Wed', '15:30 - 16:45', 'Room H105'),
  ('course-008', 'IS240', 'Database Systems', 'Dr. Nguyen', 3, 35, 'Tue/Thu', '10:30 - 11:45', 'Room IS220'),
  ('course-009', 'CHEM315', 'Organic Chemistry II', 'Dr. Alvarez', 4, 25, 'Mon/Wed', '09:00 - 10:30', 'Room C210')
ON DUPLICATE KEY UPDATE
  code = VALUES(code),
  title = VALUES(title),
  instructor = VALUES(instructor),
  credits = VALUES(credits),
  capacity = VALUES(capacity),
  schedule_day = VALUES(schedule_day),
  schedule_time = VALUES(schedule_time),
  schedule_location = VALUES(schedule_location);

INSERT INTO announcements (id, title, detail, announcement_date) VALUES
  ('ann-001', 'Commencement Rehearsal', 'Graduating seniors must attend rehearsal on April 28 at 3 PM in the main auditorium.', '2024-04-10'),
  ('ann-002', 'Registration Opens', 'Fall 2024 course registration opens on April 15 for seniors and April 18 for juniors.', '2024-04-05'),
  ('ann-003', 'Scholarship Deadline', 'The STEM innovation scholarship deadline is April 25. Submit supporting materials in the portal.', '2024-04-01')
ON DUPLICATE KEY UPDATE
  title = VALUES(title),
  detail = VALUES(detail),
  announcement_date = VALUES(announcement_date);

INSERT INTO users (id, name, email, role, password, student_id) VALUES
  ('admin-001', 'Dr. Grace West', 'admin@campus.edu', 'admin', 'admin123', NULL),
  ('doctor-001', 'Dr. Layla Hassan', 'doctor@campus.edu', 'doctor', 'doctor123', NULL),
  ('staff-001', 'Henry Adams', 'advisor@campus.edu', 'advisor', 'advisor123', NULL),
  ('student-001', 'Omar Khalid', 'student@campus.edu', 'student', 'student123', 'stu-001')
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  email = VALUES(email),
  role = VALUES(role),
  password = VALUES(password),
  student_id = VALUES(student_id);

INSERT INTO enrollments (id, student_id, course_id, status, grade_letter, grade_points) VALUES
  ('enr-001', 'stu-001', 'course-001', 'enrolled', 'A', 4.00),
  ('enr-002', 'stu-001', 'course-004', 'waitlisted', NULL, NULL),
  ('enr-003', 'stu-002', 'course-002', 'enrolled', 'B+', 3.30),
  ('enr-004', 'stu-003', 'course-003', 'enrolled', 'C', 2.00),
  ('enr-005', 'stu-004', 'course-004', 'enrolled', 'A-', 3.70),
  ('enr-006', 'stu-005', 'course-005', 'enrolled', 'B', 3.00),
  ('enr-007', 'stu-005', 'course-008', 'enrolled', 'B+', 3.30),
  ('enr-008', 'stu-006', 'course-006', 'enrolled', 'B-', 2.70),
  ('enr-009', 'stu-006', 'course-002', 'enrolled', 'A', 4.00),
  ('enr-010', 'stu-007', 'course-007', 'enrolled', 'A', 4.00),
  ('enr-011', 'stu-007', 'course-003', 'enrolled', 'B+', 3.30),
  ('enr-012', 'stu-008', 'course-008', 'enrolled', 'C+', 2.30),
  ('enr-013', 'stu-008', 'course-001', 'enrolled', 'B-', 2.70),
  ('enr-014', 'stu-009', 'course-009', 'enrolled', 'A-', 3.70),
  ('enr-015', 'stu-009', 'course-006', 'enrolled', 'B', 3.00)
ON DUPLICATE KEY UPDATE
  status = VALUES(status),
  grade_letter = VALUES(grade_letter),
  grade_points = VALUES(grade_points);
