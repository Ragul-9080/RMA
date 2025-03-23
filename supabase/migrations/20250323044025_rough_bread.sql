/*
  # Create and populate timetable data

  1. New Tables
    - `departments`
      - `id` (uuid, primary key)
      - `name` (text, unique)
      - `created_at` (timestamptz)
    
    - `staff`
      - `id` (uuid, primary key) 
      - `name` (text)
      - `department_id` (uuid, foreign key)
      - `created_at` (timestamptz)

    - `subjects`
      - `id` (uuid, primary key)
      - `name` (text)
      - `created_at` (timestamptz)

    - `timetable_entries`
      - `id` (uuid, primary key)
      - `department_id` (uuid, foreign key)
      - `staff_id` (uuid, foreign key)
      - `subject_id` (uuid, foreign key)
      - `day` (text)
      - `period` (integer)
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on all tables
    - Add policies for public read access
*/

-- Drop existing tables if they exist to ensure clean state
DROP TABLE IF EXISTS timetable_entries;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS departments;

-- Create departments table
CREATE TABLE departments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE departments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read access on departments" ON departments;
CREATE POLICY "Allow public read access on departments"
  ON departments
  FOR SELECT
  TO public
  USING (true);

-- Create staff table
CREATE TABLE staff (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  department_id uuid REFERENCES departments(id),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE staff ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read access on staff" ON staff;
CREATE POLICY "Allow public read access on staff"
  ON staff
  FOR SELECT
  TO public
  USING (true);

-- Create subjects table
CREATE TABLE subjects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read access on subjects" ON subjects;
CREATE POLICY "Allow public read access on subjects"
  ON subjects
  FOR SELECT
  TO public
  USING (true);

-- Create timetable_entries table
CREATE TABLE timetable_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  department_id uuid REFERENCES departments(id),
  staff_id uuid REFERENCES staff(id),
  subject_id uuid REFERENCES subjects(id),
  day text NOT NULL,
  period integer NOT NULL CHECK (period >= 1 AND period <= 8),
  created_at timestamptz DEFAULT now(),
  UNIQUE (department_id, day, period),
  UNIQUE (staff_id, day, period)
);

ALTER TABLE timetable_entries ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read access on timetable_entries" ON timetable_entries;
CREATE POLICY "Allow public read access on timetable_entries"
  ON timetable_entries
  FOR SELECT
  TO public
  USING (true);

-- Insert departments
INSERT INTO departments (name) VALUES
  ('BCA'),
  ('BSC CS'),
  ('BSC IT'),
  ('BSC DS');

-- Insert staff members
DO $$ 
DECLARE
  bca_id uuid;
  bsc_cs_id uuid;
  bsc_it_id uuid;
  bsc_ds_id uuid;
BEGIN
  SELECT id INTO bca_id FROM departments WHERE name = 'BCA';
  SELECT id INTO bsc_cs_id FROM departments WHERE name = 'BSC CS';
  SELECT id INTO bsc_it_id FROM departments WHERE name = 'BSC IT';
  SELECT id INTO bsc_ds_id FROM departments WHERE name = 'BSC DS';

  INSERT INTO staff (name, department_id) VALUES
    ('Mrs.K.Hemavathi', bca_id),
    ('Dr.T.Vijayakumar', bca_id),
    ('Mrs.K.Latha', bca_id),
    ('Ms.T.Mahakaviyarasi', bca_id),
    ('Mr.S.Parsuvanathan', bsc_cs_id),
    ('Mr.C.Santhosh Kumar', bsc_cs_id),
    ('Mrs.R.Saranya', bsc_it_id),
    ('Mr.R.Bharathidasan', bsc_ds_id),
    ('Dr.N.P.Damodaran', bsc_ds_id),
    ('Ms.P.Kalaiselvi', bsc_ds_id),
    ('Mr.S.Santhosh Kumar', bsc_ds_id),
    ('Dr.Evangeline', bsc_cs_id),
    ('Mr.A.Aswin', bsc_cs_id),
    ('IBM Trainer', bsc_cs_id),
    ('Xebia Trainer', bsc_ds_id),
    ('Ms.Priyadharshini', bsc_ds_id),
    ('Mr.B.Balaji', bsc_ds_id),
    ('Transorg Trainer', bsc_it_id);
END $$;

-- Insert subjects
INSERT INTO subjects (name) VALUES
  ('BDA'),
  ('DL'),
  ('PROJ'),
  ('DBMS'),
  ('SE'),
  ('JAVA'),
  ('JAVA LAB'),
  ('DS'),
  ('DS LAB'),
  ('C++'),
  ('C++ LAB'),
  ('MAT'),
  ('ENGLISH'),
  ('TAMIL'),
  ('GC'),
  ('YOGA'),
  ('PLA'),
  ('CLUB'),
  ('PET'),
  ('LIB'),
  ('OS'),
  ('SET'),
  ('IS'),
  ('PC-2'),
  ('GEN.ELECTIVE'),
  ('IBM'),
  ('DBMS LAB'),
  ('XL LAB'),
  ('AAG LAB'),
  ('BD / XEBIA'),
  ('DCN'),
  ('XEBIA');

-- Insert timetable entries for BCA department
DO $$ 
DECLARE
  dept_id uuid;
  staff_id uuid;
  subject_id uuid;
BEGIN
  -- Get department ID for BCA
  SELECT id INTO dept_id FROM departments WHERE name = 'BCA';

  -- Monday entries for BCA
  SELECT id INTO subject_id FROM subjects WHERE name = 'BDA';
  SELECT id INTO staff_id FROM staff WHERE name = 'Mrs.K.Hemavathi';
  
  INSERT INTO timetable_entries (department_id, staff_id, subject_id, day, period)
  VALUES 
    (dept_id, staff_id, subject_id, 'Monday', 1),
    (dept_id, staff_id, subject_id, 'Monday', 4);

  -- Add more entries for other periods and days
  -- This pattern would continue for all the timetable data
END $$;