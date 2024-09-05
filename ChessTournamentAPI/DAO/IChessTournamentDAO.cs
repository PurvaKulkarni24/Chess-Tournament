using static ChessTournamentAPI.Models.ChessTournament;

namespace ChessTournamentAPI.DAO
{
    public interface IChessTournamentDAO
    {
        Task AddMatchAsync(Match match);
        Task<Match> GetMatchByIdAsync(int matchId);
        Task<bool> PlayerExistsAsync(int playerId);
        Task<List<Player>> GetPlayersByCountryAsync(string country);
        Task<PlayerPerformance> GetPlayerPerformanceAsync(int playerId);
        Task<List<PlayerAboveAverage>> GetPlayersAboveAverageWinsAsync();
    }
}
