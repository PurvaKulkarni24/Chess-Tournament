import React, { useState } from 'react';
import { getPlayersByCountry } from '../services/productApiService';

const PlayersByCountry = () => {
    const [country, setCountry] = useState('');
    const [players, setPlayers] = useState([]);
    const [errors, setErrors] = useState({});
    const [error, setError] = useState(null);

    const validateForm = () => {
        const newErrors = {};
        if (!country) newErrors.country = 'Country is required';
        return newErrors;
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        const newErrors = validateForm();
        if (Object.keys(newErrors).length > 0) {
            setErrors(newErrors);
            return;
        }

        try {
            const res = await getPlayersByCountry(country);
            if (Array.isArray(res)) {
                setPlayers(res);
                setError(null); 
            } else {
                throw new Error('Unexpected data format');
            }
        } catch (err) {
            setError(err.message);
            setPlayers([]); 
        }
    };

    return (
        <div className="container mt-5">
            <h1>Players by Country</h1>
            <form onSubmit={handleSubmit}>
                <div className="form-group">
                    <label htmlFor="country">Country</label>
                    <input
                        type="text"
                        className="form-control"
                        id="country"
                        value={country}
                        onChange={(e) => setCountry(e.target.value)}
                    />
                    {errors.country && <div className="text-danger">{errors.country}</div>}
                </div>
                <button type="submit" className="btn btn-primary">Get Players</button>
            </form>
            <div className="mt-4">
                <h2>Players List</h2>
                {error && <div className="alert alert-danger">{error}</div>}
                {players.length > 0 ? (
                    <ul>
                        {players.map(player => (
                            <li key={player.id}>{player.fullName}</li>
                        ))}
                    </ul>
                ) : (
                    <p>No players found for this country.</p>
                )}
            </div>
        </div>
    );
};

export default PlayersByCountry;
