-- Migration to add Saturday timetable entries

-- Insert sample timetable entries for Saturday
INSERT INTO timetable_entries (staff_id, subject_id, department_id, day, period, created_at)
VALUES
  ('<staff_id_1>', '<subject_id_1>', '<department_id_1>', 'Saturday', 1, now()),
  ('<staff_id_2>', '<subject_id_2>', '<department_id_2>', 'Saturday', 2, now()),
  ('<staff_id_3>', '<subject_id_3>', '<department_id_3>', 'Saturday', 3, now()),
  ('<staff_id_4>', '<subject_id_4>', '<department_id_4>', 'Saturday', 4, now()),
  ('<staff_id_5>', '<subject_id_5>', '<department_id_5>', 'Saturday', 5, now()),
  ('<staff_id_6>', '<subject_id_6>', '<department_id_6>', 'Saturday', 6, now()),
  ('<staff_id_7>', '<subject_id_7>', '<department_id_7>', 'Saturday', 7, now()),
  ('<staff_id_8>', '<subject_id_8>', '<department_id_8>', 'Saturday', 8, now());
