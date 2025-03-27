import React from 'react';
import logo from '../../logo-white.png'; // Importing the logo

const Header: React.FC = () => {
  return (
    <header className="bg-orange-600 text-white p-6 text-center shadow-lg transform transition-transform hover:scale-105 flex flex-col items-center">
      <img src={logo} alt="Takshashila University Logo" className="h-16 mb-2" />
      <h3 className="text-lg">School of Computer Science</h3>
    </header>
  );
};

export default Header;
