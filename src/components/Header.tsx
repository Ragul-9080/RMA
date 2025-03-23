import React from 'react';
import logo from '../../taklogo (1).png'; // Importing the logo

const Header: React.FC = () => {
  return (
    <header className="bg-indigo-500 text-white p-4 text-center">

      <h1 className="text-3xl font-bold inline-block uppercase text-white">TAKSHASHILA UNIVERSITY</h1>
      <div className="mt-2">
        <h2 className="text-lg text-white">School of Computer Science</h2>
      </div>
    </header>
  );
};

export default Header;
