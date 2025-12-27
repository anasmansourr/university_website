import { Navigate, Route, Routes } from 'react-router-dom';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import Students from './pages/Students';
import Courses from './pages/Courses';
import Login from './pages/Login';
import StudentPortal from './pages/StudentPortal';
import Staff from './pages/Staff';
import { useAuth } from './context/AuthContext';
import ProtectedRoute from './components/ProtectedRoute';
import './App.css';

const App = () => {
  const { user, isStudent } = useAuth();

  if (!user) {
    return (
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    );
  }

  return (
    <Layout>
      <Routes>
        {isStudent ? (
          <>
            <Route
              path="/portal"
              element={
                <ProtectedRoute roles={['student']}>
                  <StudentPortal />
                </ProtectedRoute>
              }
            />
            <Route path="*" element={<Navigate to="/portal" replace />} />
          </>
        ) : (
          <>
            <Route
              path="/dashboard"
              element={
                <ProtectedRoute roles={['admin', 'doctor', 'advisor']}>
                  <Dashboard />
                </ProtectedRoute>
              }
            />
            <Route
              path="/students"
              element={
                <ProtectedRoute roles={['admin', 'doctor', 'advisor']}>
                  <Students />
                </ProtectedRoute>
              }
            />
            <Route
              path="/courses"
              element={
                <ProtectedRoute roles={['admin', 'doctor', 'advisor']}>
                  <Courses />
                </ProtectedRoute>
              }
            />
            <Route
              path="/staff"
              element={
                <ProtectedRoute roles={['admin']}>
                  <Staff />
                </ProtectedRoute>
              }
            />
            <Route path="*" element={<Navigate to="/dashboard" replace />} />
          </>
        )}
      </Routes>
    </Layout>
  );
};

export default App;
