import React from "react";
import { Link } from "react-router-dom";

const NavBar = () => {
  return (
    <nav className="navbar navbar-expand-lg navbar-light bg-light">
      <button
        className="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarNavAltMarkup"
        aria-controls="navbarNavAltMarkup"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span className="navbar-toggler-icon"></span>
      </button>
      <div className="collapse navbar-collapse" id="navbarNavAltMarkup">
        <div className="navbar-nav">
          <a className="nav-item nav-link active" href="/">
            Home
          </a>
          <a className="nav-item nav-link active" href="/add-match">
            Add Match
          </a>
          <a className="nav-item nav-link" href="/by-country">
            Player By Country
          </a>
          <a className="nav-item nav-link" href="/performance">
            Player Performance          
          </a>
          <a className="nav-item nav-link" href="/above-average-wins">
            Players Above Average Wins          
          </a>
        </div>
      </div>
    </nav>
  );
};

export default NavBar;
