import React, { useState } from 'react';
import { addMatch } from '../services/productApiService';
import 'bootstrap/dist/css/bootstrap.min.css';

const AddMatch = () => {
  const [player1Id, setPlayer1Id] = useState('');
  const [player2Id, setPlayer2Id] = useState('');
  const [matchDate, setMatchDate] = useState('');
  const [matchLevel, setMatchLevel] = useState('');
  const [winnerId, setWinnerId] = useState('');
  const [errors, setErrors] = useState({});

  const validateForm = () => {
    const newErrors = {};
    if (!player1Id) newErrors.player1Id = 'Player 1 ID is required';
    if (!player2Id) newErrors.player2Id = 'Player 2 ID is required';
    if (!matchDate) newErrors.matchDate = 'Match Date is required';
    if (!matchLevel) newErrors.matchLevel = 'Match Level is required';
    if (!winnerId) newErrors.winnerId = 'Winner ID is required';
    return newErrors;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const newErrors = validateForm();
    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    const matchData = {
      player1Id,
      player2Id,
      matchDate,
      matchLevel,
      winnerId,
    };

    const res = await addMatch(matchData);
    if (res) {
      setPlayer1Id('');
      setPlayer2Id('');
      setMatchDate('');
      setMatchLevel('');
      setWinnerId('');
      alert('Match Added Successfully');
    } else {
      alert('Failed to add match');
    }
  };

  return (
    <div className="container mt-5">
      <h1>Add Match</h1>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="player1Id">Player 1 ID</label>
          <input
            type="number"
            className="form-control"
            id="player1Id"
            value={player1Id}
            onChange={(e) => setPlayer1Id(e.target.value)}
          />
          {errors.player1Id && <div className="text-danger">{errors.player1Id}</div>}
        </div>
        <div className="form-group">
          <label htmlFor="player2Id">Player 2 ID</label>
          <input
            type="number"
            className="form-control"
            id="player2Id"
            value={player2Id}
            onChange={(e) => setPlayer2Id(e.target.value)}
          />
          {errors.player2Id && <div className="text-danger">{errors.player2Id}</div>}
        </div>
        <div className="form-group">
          <label htmlFor="matchDate">Match Date</label>
          <input
            type="date"
            className="form-control"
            id="matchDate"
            value={matchDate}
            onChange={(e) => setMatchDate(e.target.value)}
          />
          {errors.matchDate && <div className="text-danger">{errors.matchDate}</div>}
        </div>
        <div className="form-group">
          <label htmlFor="matchLevel">Match Level</label>
          <input
            type="text"
            className="form-control"
            id="matchLevel"
            value={matchLevel}
            onChange={(e) => setMatchLevel(e.target.value)}
          />
          {errors.matchLevel && <div className="text-danger">{errors.matchLevel}</div>}
        </div>
        <div className="form-group">
          <label htmlFor="winnerId">Winner ID</label>
          <input
            type="number"
            className="form-control"
            id="winnerId"
            value={winnerId}
            onChange={(e) => setWinnerId(e.target.value)}
          />
          {errors.winnerId && <div className="text-danger">{errors.winnerId}</div>}
        </div>
        <button type="submit" className="btn btn-primary">Add Match</button>
      </form>
    </div>
  );
};

export default AddMatch;
