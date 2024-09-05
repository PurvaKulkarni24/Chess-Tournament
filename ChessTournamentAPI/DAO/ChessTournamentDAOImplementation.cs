using Npgsql;
using System.Data;
using static ChessTournamentAPI.Models.ChessTournament;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ChessTournamentAPI.DAO
{
    public class ChessTournamentDAOImplementation : IChessTournamentDAO
    {
        private readonly NpgsqlConnection _connection;

        public ChessTournamentDAOImplementation(NpgsqlConnection connection)
        {
            _connection = connection;
        }

        public async Task AddMatchAsync(Match match)
        {
            string insertQuery = @"INSERT INTO chess.matches (match_id, player1_id, player2_id, match_date, match_level, winner_id)
                                   VALUES (@MatchId, @Player1Id, @Player2Id, @MatchDate, @MatchLevel, @WinnerId)";

            try
            {
                await using (var command = new NpgsqlCommand(insertQuery, _connection))
                {
                    command.Parameters.AddWithValue("@MatchId", match.MatchId);
                    command.Parameters.AddWithValue("@Player1Id", match.Player1Id);
                    command.Parameters.AddWithValue("@Player2Id", match.Player2Id);
                    command.Parameters.AddWithValue("@MatchDate", match.MatchDate);
                    command.Parameters.AddWithValue("@MatchLevel", match.MatchLevel);
                    command.Parameters.AddWithValue("@WinnerId", match.WinnerId.HasValue ? (object)match.WinnerId.Value : DBNull.Value);

                    await _connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }
            finally
            {
                if (_connection.State != ConnectionState.Closed)
                {
                    await _connection.CloseAsync();
                }
            }
        }

        public async Task<Match> GetMatchByIdAsync(int matchId)
        {
            string query = @"SELECT match_id, player1_id, player2_id, match_date, match_level, winner_id 
                             FROM chess.matches WHERE match_id = @MatchId";

            try
            {
                await using (var command = new NpgsqlCommand(query, _connection))
                {
                    command.Parameters.AddWithValue("@MatchId", matchId);

                    await _connection.OpenAsync();
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            return new Match
                            {
                                MatchId = reader.GetInt32(0),
                                Player1Id = reader.GetInt32(1),
                                Player2Id = reader.GetInt32(2),
                                MatchDate = reader.GetDateTime(3),
                                MatchLevel = reader.GetString(4),
                                WinnerId = reader.IsDBNull(5) ? (int?)null : reader.GetInt32(5)
                            };
                        }
                    }
                }
            }
            finally
            {
                if (_connection.State != ConnectionState.Closed)
                {
                    await _connection.CloseAsync();
                }
            }

            return null;
        }

        public async Task<bool> PlayerExistsAsync(int playerId)
        {
            string query = @"SELECT EXISTS (SELECT 1 FROM chess.players WHERE player_id = @PlayerId)";

            try
            {
                await using (var command = new NpgsqlCommand(query, _connection))
                {
                    command.Parameters.AddWithValue("@PlayerId", playerId);

                    await _connection.OpenAsync();
                    var exists = (bool)await command.ExecuteScalarAsync();
                    return exists;
                }
            }
            finally
            {
                if (_connection.State != ConnectionState.Closed)
                {
                    await _connection.CloseAsync();
                }
            }
        }

        public async Task<List<Player>> GetPlayersByCountryAsync(string country)
        {
            string query = @"SELECT player_id, first_name, last_name, country, current_world_ranking, total_matches_played
                             FROM chess.players WHERE country = @Country ORDER BY current_world_ranking";

            var players = new List<Player>();

            try
            {
                await using (var command = new NpgsqlCommand(query, _connection))
                {
                    command.Parameters.AddWithValue("@Country", country);

                    await _connection.OpenAsync();
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            players.Add(new Player
                            {
                                PlayerId = reader.GetInt32(0),
                                FirstName = reader.GetString(1),
                                LastName = reader.GetString(2),
                                Country = reader.GetString(3),
                                CurrentWorldRanking = reader.GetInt32(4),
                                TotalMatchesPlayed = reader.GetInt32(5)
                            });
                        }
                    }
                }
            }
            finally
            {
                if (_connection.State != ConnectionState.Closed)
                {
                    await _connection.CloseAsync();
                }
            }

            return players;
        }

        public async Task<PlayerPerformance> GetPlayerPerformanceAsync(int playerId)
        {
            string query = @"SELECT p.first_name || ' ' || p.last_name AS full_name,
                                   COUNT(m.match_id) AS total_matches_played,
                                   SUM(CASE WHEN m.winner_id = @PlayerId THEN 1 ELSE 0 END) AS total_matches_won
                             FROM chess.players p
                             LEFT JOIN chess.matches m ON p.player_id = m.player1_id OR p.player_id = m.player2_id
                             WHERE p.player_id = @PlayerId
                             GROUP BY p.first_name, p.last_name";

            try
            {
                await using (var command = new NpgsqlCommand(query, _connection))
                {
                    command.Parameters.AddWithValue("@PlayerId", playerId);

                    await _connection.OpenAsync();
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            var totalMatchesPlayed = reader.GetInt32(1);
                            var totalMatchesWon = reader.GetInt32(2);
                            var winPercentage = totalMatchesPlayed > 0 ? (decimal)totalMatchesWon / totalMatchesPlayed * 100 : 0;

                            return new PlayerPerformance
                            {
                                FullName = reader.GetString(0),
                                TotalMatchesPlayed = totalMatchesPlayed,
                                TotalMatchesWon = totalMatchesWon,
                                WinPercentage = winPercentage
                            };
                        }
                    }
                }
            }
            finally
            {
                if (_connection.State != ConnectionState.Closed)
                {
                    await _connection.CloseAsync();
                }
            }

            return null;
        }

        public async Task<List<PlayerAboveAverage>> GetPlayersAboveAverageWinsAsync()
        {
            string query = @"
        WITH WinStats AS (
            SELECT p.player_id,
                   p.first_name || ' ' || p.last_name AS full_name,
                   COUNT(m.match_id) AS total_matches_played,
                   SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) AS total_matches_won
            FROM chess.players p
            LEFT JOIN chess.matches m ON p.player_id = m.player1_id OR p.player_id = m.player2_id
            GROUP BY p.player_id, p.first_name, p.last_name
        ),
        AverageWins AS (
            SELECT AVG(total_matches_won) AS avg_wins FROM WinStats
        )
        SELECT full_name,
               total_matches_won,
               (CASE WHEN total_matches_played > 0 THEN (CAST(total_matches_won AS DECIMAL) / total_matches_played) * 100 ELSE 0 END) AS win_percentage
        FROM WinStats
        WHERE total_matches_won > (SELECT avg_wins FROM AverageWins);
    ";

            var players = new List<PlayerAboveAverage>();

            try
            {
                if (_connection.State != ConnectionState.Open)
                {
                    await _connection.OpenAsync();
                }

                using (var command = new NpgsqlCommand(query, _connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            players.Add(new PlayerAboveAverage
                            {
                                FullName = reader.GetString(0),
                                TotalMatchesWon = reader.GetInt32(1),
                                WinPercentage = reader.GetDecimal(2)
                            });
                        }
                    }
                }
            }
            finally
            {
                if (_connection.State != ConnectionState.Closed)
                {
                    await _connection.CloseAsync();
                }
            }

            return players;
        }
    }
}
