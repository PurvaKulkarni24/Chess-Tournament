import React from 'react';
import {BrowserRouter, Route, Routes} from "react-router-dom";
import Home  from '../components/Home';
import NavBar from '../components/NavBar';
import AddMatch from '../products/AddMatch';
import PlayersByCountry from  '../products/PlayerByCountry';
import PlayerPerformance from '../products/PlayerPerformance';
import PlayersAboveAverageWins from '../products/PlayersAboveAverageWins';

const RouterConfiguration = () => {
  return (
    <>
      <NavBar />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/add-match" element={<AddMatch />} />
          <Route path="/by-country" element={<PlayersByCountry />} />
          <Route path="/performance" element={<PlayerPerformance />} />
          <Route path="/above-average-wins" element={<PlayersAboveAverageWins />} />
        </Routes>
      </BrowserRouter>
    </>
  );
};

export default RouterConfiguration;
