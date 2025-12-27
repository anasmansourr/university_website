const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:4000';

const request = async (endpoint, options = {}) => {
  const config = {
    headers: { 'Content-Type': 'application/json', ...(options.headers || {}) },
    ...options
  };

  const response = await fetch(`${API_BASE_URL}${endpoint}`, config);
  if (!response.ok) {
    const errorBody = await response.json().catch(() => ({}));
    const message = errorBody.message || 'Request failed';
    throw new Error(message);
  }

  if (response.status === 204) {
    return null;
  }

  return response.json();
};

export const api = {
  login: (payload) => request('/api/auth/login', { method: 'POST', body: JSON.stringify(payload) }),
  getDashboardSummary: () => request('/api/dashboard/summary'),

  getStudents: () => request('/api/students'),
  getStudent: (id) => request(`/api/students/${id}`),
  createStudent: (payload) => request('/api/students', { method: 'POST', body: JSON.stringify(payload) }),
  updateStudent: (id, payload) => request(`/api/students/${id}`, { method: 'PUT', body: JSON.stringify(payload) }),
  deleteStudent: (id) => request(`/api/students/${id}`, { method: 'DELETE' }),

  getCourses: () => request('/api/courses'),
  createCourse: (payload) => request('/api/courses', { method: 'POST', body: JSON.stringify(payload) }),
  deleteCourse: (id) => request(`/api/courses/${id}`, { method: 'DELETE' }),

  getSchedule: () => request('/api/schedule'),
  getEnrollments: () => request('/api/enrollments'),
  createEnrollment: (payload) => request('/api/enrollments', { method: 'POST', body: JSON.stringify(payload) }),
  updateEnrollment: (id, payload) => request(`/api/enrollments/${id}`, { method: 'PUT', body: JSON.stringify(payload) }),

  getDoctors: () => request('/api/staff/doctors'),
  createDoctor: (payload) => request('/api/staff/doctors', { method: 'POST', body: JSON.stringify(payload) })
};

export default api;
