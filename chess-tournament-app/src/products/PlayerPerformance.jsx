import React, { useState, useEffect } from 'react';
import { getPlayerPerformance } from '../services/productApiService';
import 'bootstrap/dist/css/bootstrap.min.css';

const PlayerPerformance = () => {
    const [performance, setPerformance] = useState([]);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchPerformance = async () => {
            try {
                const res = await getPlayerPerformance();
                if (Array.isArray(res)) {
                    setPerformance(res);
                } else {
                    throw new Error('Unexpected data format');
                }
            } catch (err) {
                setError(err.message);
            }
        };

        fetchPerformance();
    }, []);

    return (
        <div className="container mt-5">
            <h1>Player Performance</h1>
            {error && <div className="alert alert-danger">{error}</div>}
            <div className="mt-4">
                <h2>Performance List</h2>
                {performance.length > 0 ? (
                    <ul>
                        {performance.map(player => (
                            <li key={player.id}>
                                {player.fullName} - Matches Played: {player.matchesPlayed}, Matches Won: {player.matchesWon}, Win Percentage: {player.winPercentage}%
                            </li>
                        ))}
                    </ul>
                ) : (
                    <p>No performance data available.</p>
                )}
            </div>
        </div>
    );
};

export default PlayerPerformance;
