/*
  # Timetable Management System Schema

  1. New Tables
    - `departments`
      - `id` (uuid, primary key)
      - `name` (text, unique)
      - `created_at` (timestamp)
    
    - `staff`
      - `id` (uuid, primary key)
      - `name` (text)
      - `department_id` (uuid, foreign key)
      - `created_at` (timestamp)
    
    - `subjects`
      - `id` (uuid, primary key)
      - `name` (text)
      - `department_id` (uuid, foreign key)
      - `created_at` (timestamp)
    
    - `timetable_entries`
      - `id` (uuid, primary key)
      - `staff_id` (uuid, foreign key)
      - `subject_id` (uuid, foreign key)
      - `department_id` (uuid, foreign key)
      - `day` (text)
      - `period` (integer)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for public read access
*/

-- Create departments table
CREATE TABLE IF NOT EXISTS departments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create staff table
CREATE TABLE IF NOT EXISTS staff (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  department_id uuid REFERENCES departments(id),
  created_at timestamptz DEFAULT now()
);

-- Create subjects table
CREATE TABLE IF NOT EXISTS subjects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  department_id uuid REFERENCES departments(id),
  created_at timestamptz DEFAULT now()
);

-- Create timetable_entries table
CREATE TABLE IF NOT EXISTS timetable_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  staff_id uuid REFERENCES staff(id),
  subject_id uuid REFERENCES subjects(id),
  department_id uuid REFERENCES departments(id),
  day text NOT NULL,
  period integer NOT NULL CHECK (period >= 1 AND period <= 8),
  created_at timestamptz DEFAULT now(),
  UNIQUE(staff_id, day, period),
  UNIQUE(department_id, day, period)
);

-- Enable Row Level Security
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE timetable_entries ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access
CREATE POLICY "Allow public read access on departments" ON departments
  FOR SELECT TO public USING (true);

CREATE POLICY "Allow public read access on staff" ON staff
  FOR SELECT TO public USING (true);

CREATE POLICY "Allow public read access on subjects" ON subjects
  FOR SELECT TO public USING (true);

CREATE POLICY "Allow public read access on timetable_entries" ON timetable_entries
  FOR SELECT TO public USING (true);