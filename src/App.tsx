import React, { useState, useEffect } from 'react';
import Header from './components/Header'; // Importing the Header component
import { Calendar, Clock, Users, BookOpen, Search } from 'lucide-react';
import { supabase } from './lib/supabase';
import clsx from 'clsx';

type SearchType = 'staff' | 'student';
type Department = { id: string; name: string };
type Staff = { id: string; name: string; department_id: string };
type Subject = { id: string; name: string; department_id: string };

function App() {
  const [searchType, setSearchType] = useState<SearchType>('staff');
  const [selectedDay, setSelectedDay] = useState<string>('Monday');
  const [selectedPeriod, setSelectedPeriod] = useState<number>(0);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [staffList, setStaffList] = useState<Staff[]>([]);
  const [selectedStaff, setSelectedStaff] = useState<string>('');
  const [selectedDepartment, setSelectedDepartment] = useState<string>('');
  const [searchResult, setSearchResult] = useState<any>(null);
  const [loading, setLoading] = useState(false);

  const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday','Saturday'];
  const periods = Array.from({ length: 8 }, (_, i) => i + 1);

  useEffect(() => {
    fetchDepartments();
    fetchStaff();
  }, []);

  const fetchDepartments = async () => {
    const { data } = await supabase.from('departments').select('*');
    if (data) setDepartments(data);
  };

  const fetchStaff = async () => {
    const { data } = await supabase.from('staff').select('*');
    if (data) setStaffList(data);
  };

  const handleSearch = async () => {
    setLoading(true);
    try {
      if (searchType === 'staff') {
        if (!selectedStaff) {
          setSearchResult({ message: 'Please select a staff member' });
          return;
        }

        // Create a base query that will be used for both specific period and all-day searches
        let query = supabase
          .from('timetable_entries')
          .select(`
            *,
            staff:staff_id(name),
            subject:subject_id(name),
            department:department_id(name)
          `)
          .eq('staff_id', selectedStaff)
          .eq('day', selectedDay);
        
        // If a specific period is selected (period > 0), add that filter
        if (selectedPeriod > 0) {
          query = query.eq('period', selectedPeriod);
        }
        
        const { data } = await query;
        
        if (!data || data.length === 0) {
          setSearchResult({ message: selectedPeriod > 0 ? 'Free Period' : 'No Schedule for this day' });
        } else {
          // Sort by period if we're showing multiple periods
          const sortedData = selectedPeriod > 0 ? data : [...data].sort((a, b) => a.period - b.period);
          setSearchResult(sortedData);
        }
      } else {
        if (!selectedDepartment) {
          setSearchResult({ message: 'Please select a department' });
          return;
        }

        // Create a base query for department search
        let query = supabase
          .from('timetable_entries')
          .select(`
            *,
            staff:staff_id(name),
            subject:subject_id(name),
            department:department_id(name)
          `)
          .eq('department_id', selectedDepartment)
          .eq('day', selectedDay);
        
        // If a specific period is selected (period > 0), add that filter
        if (selectedPeriod > 0) {
          query = query.eq('period', selectedPeriod);
        }
        
        const { data } = await query;
        
        if (!data || data.length === 0) {
          setSearchResult({ message: selectedPeriod > 0 ? 'No Class Assigned' : 'No Classes for this day' });
        } else {
          // Sort by period if we're showing multiple periods
          const sortedData = selectedPeriod > 0 ? data : [...data].sort((a, b) => a.period - b.period);
          setSearchResult(sortedData);
        }
      }
    } catch (error) {
      console.error('Error searching:', error);
      setSearchResult({ message: 'Error occurred while searching' });
    }
    setLoading(false);
  };

  return (
    <div className="min-h-screen bg-white">
      <Header /> {/* Adding the Header component */}
      <div className="max-w-4xl mx-auto p-6">
        <div className="bg-orange-100 rounded-xl shadow-lg p-6 transform transition-transform hover:scale-105">
          <div className="flex items-center space-x-2 mb-8">
            <Calendar className="w-8 h-8 text-orange-600" />
            <h1 className="text-2xl font-bold text-orange-800">Timetable Management System</h1>
          </div>

          <div className="grid grid-cols-1 gap-6">
            <div className="flex space-x-4">
              <button
                onClick={() => setSearchType('staff')}
                className={clsx(
                  'flex items-center px-4 py-2 rounded-lg font-medium shadow-md transform transition-transform hover:scale-105',
                  searchType === 'staff'
                    ? 'bg-orange-600 text-white'
                    : 'bg-white text-orange-700 hover:bg-orange-200'
                )}
              >
                <Users className="w-5 h-5 mr-2" />
                Staff Search
              </button>
              <button
                onClick={() => setSearchType('student')}
                className={clsx(
                  'flex items-center px-4 py-2 rounded-lg font-medium shadow-md transform transition-transform hover:scale-105',
                  searchType === 'student'
                    ? 'bg-orange-600 text-white'
                    : 'bg-white text-orange-700 hover:bg-orange-200'
                )}
              >
                <BookOpen className="w-5 h-5 mr-2" />
                Student Search
              </button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {searchType === 'staff' ? (
                <select
                  value={selectedStaff}
                  onChange={(e) => setSelectedStaff(e.target.value)}
                  className="block w-full md:w-3/4 rounded-lg border-orange-300 shadow-sm focus:border-orange-500 focus:ring-orange-500 text-lg py-2"
                >
                  <option value="">Select Staff</option>
                  {staffList.map((staff) => (
                    <option key={staff.id} value={staff.id}>
                      {staff.name}
                    </option>
                  ))}
                </select>
              ) : (
                <select
                  value={selectedDepartment}
                  onChange={(e) => setSelectedDepartment(e.target.value)}
                  className="block w-full md:w-3/4 rounded-lg border-orange-300 shadow-sm focus:border-orange-500 focus:ring-orange-500 text-lg py-2"
                >
                  <option value="">Select Department</option>
                  {departments.map((dept) => (
                    <option key={dept.id} value={dept.id}>
                      {dept.name}
                    </option>
                  ))}
                </select>
              )}

              <select
                value={selectedDay}
                onChange={(e) => setSelectedDay(e.target.value)}
                className="block w-full md:w-3/4 rounded-lg border-orange-300 shadow-sm focus:border-orange-500 focus:ring-orange-500 text-lg py-2"
              >
                {days.map((day) => (
                  <option key={day} value={day}>
                    {day}
                  </option>
                ))}
              </select>

              <select
                value={selectedPeriod}
                onChange={(e) => setSelectedPeriod(Number(e.target.value))}
                className="block w-full rounded-lg border-orange-300 shadow-sm focus:border-orange-500 focus:ring-orange-500 text-lg py-2"
              >
                <option value="0">All Periods</option>
                {periods.map((period) => (
                  <option key={period} value={period}>
                    Period {period}
                  </option>
                ))}
              </select>

              <button
                onClick={handleSearch}
                disabled={loading}
                className="flex items-center justify-center px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500 transform transition-transform hover:scale-105"
              >
                <Search className="w-5 h-5 mr-2" />
                {loading ? 'Searching...' : 'Search'}
              </button>
            </div>

            {searchResult && (
              <div className="mt-6 p-4 bg-orange-50 rounded-lg shadow-md">
                <h3 className="text-lg font-medium text-orange-900 mb-2">Search Result</h3>
                {searchResult.message ? (
                  <p className="text-orange-600">{searchResult.message}</p>
                ) : (
                  <div className="space-y-4">
                    {searchResult.map((entry: any, index: number) => (
                      <div key={index} className="p-3 bg-white rounded-lg shadow-sm">
                        <div className="flex justify-between items-center mb-2">
                          <h4 className="font-bold text-orange-800">Period {entry.period}</h4>
                          <span className="bg-orange-200 text-orange-800 px-2 py-1 rounded-md text-sm">{entry.day}</span>
                        </div>
                        <p className="text-orange-600">
                          <span className="font-medium">Staff:</span> {entry.staff?.name}
                        </p>
                        <p className="text-orange-600">
                          <span className="font-medium">Subject:</span> {entry.subject?.name}
                        </p>
                        <p className="text-orange-600">
                          <span className="font-medium">Department:</span> {entry.department?.name}
                        </p>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
export default App;

