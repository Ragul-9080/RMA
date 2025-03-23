-- Migration to remove unique constraints from timetable_entries table

ALTER TABLE timetable_entries
  DROP CONSTRAINT IF EXISTS unique_staff_day_period,
  DROP CONSTRAINT IF EXISTS unique_department_day_period;
