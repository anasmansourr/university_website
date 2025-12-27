-- Migration script to add grade_released column to enrollments table
-- Run this if you have an existing database that's missing the grade_released column
-- This will fix the "Failed to fetch enrollments" error
-- 
-- Note: If you get an error saying the column already exists, that's fine - 
-- it means your database already has the column and you can ignore the error.

USE university;

ALTER TABLE enrollments ADD COLUMN grade_released TINYINT(1) DEFAULT 0;

