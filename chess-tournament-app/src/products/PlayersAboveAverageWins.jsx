import React, { useState, useEffect } from 'react';
import { getPlayersAboveAverageWins } from '../services/productApiService';
import 'bootstrap/dist/css/bootstrap.min.css';

const PlayersAboveAverageWins = () => {
  const [players, setPlayers] = useState([]);

  useEffect(() => {
    const fetchPlayers = async () => {
      const res = await getPlayersAboveAverageWins();
      if (res) {
        setPlayers(res);
      } else {
        alert('Failed to retrieve players above average wins');
      }
    };

    fetchPlayers();
  }, []);

  return (
    <div className="container mt-5">
      <h1>Players Above Average Wins</h1>
      <div className="mt-4">
        <h2>Players List</h2>
        <ul>
          {players.map(player => (
            <li key={player.id}>
              {player.fullName} - Matches Won: {player.matchesWon}, Win Percentage: {player.winPercentage}%
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default PlayersAboveAverageWins;
