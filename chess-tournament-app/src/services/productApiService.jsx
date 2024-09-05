import axios from "axios";

const BASE_URL = 'http://localhost:5149/api/ChessTournament';

async function addMatch(match) {
  let data = null;

  try {
    const response = await axios.post('http://localhost:5149/api/ChessTournament/add-match', match);
    if (response.status === 201) {
      data = response.data;
      console.log('Match added successfully:', data);
    } else {
      console.error('Failed to add match:', response.statusText);
    }
  } catch (error) {
    console.error('Error adding match:', error);
    return JSON.stringify(error);
  }

  return data;
}

async function getPlayersByCountry(country) {
  try {
      const response = await axios.get('http://localhost:5149/api/ChessTournament/by-country', {
          params: { country }
      });
      console.log('API Response:', response.data); 
      return response.data;
  } catch (error) {
      console.error('Error retrieving players by country:', error);
      return []; 
  }
}

async function getPlayerPerformance() {
  try {
      const response = await axios.get('http://localhost:5149/api/ChessTournament/performance');
      console.log('API Response:', response.data);
      return response.data;
  } catch (error) {
      console.error('Error retrieving player performance:', error);
      return []; 
  }
}async function getPlayersAboveAverageWins() {
    let data = null;
  
    try {
      const response = await axios.get('http://localhost:5149/api/ChessTournament/above-average-wins');
      if (response.status === 200) {
        data = response.data;
        console.log('Players above average wins:', data);
      } else {
        console.error('Failed to retrieve players above average wins:', response.statusText);
      }
    } catch (error) {
      console.error('Error retrieving players above average wins:', error);
      return JSON.stringify(error);
    }
  
    return data;
  }

export { addMatch, getPlayersByCountry, getPlayerPerformance, getPlayersAboveAverageWins};
