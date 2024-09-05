using ChessTournamentAPI.DAO;
using static ChessTournamentAPI.Models.ChessTournament;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace ChessTournamentAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ChessTournamentController : ControllerBase
    {
        private readonly IChessTournamentDAO _dao;

        public ChessTournamentController(IChessTournamentDAO dao)
        {
            _dao = dao;
        }

        [HttpPost("add-match")]
        public async Task<IActionResult> AddMatch([FromBody] Match match)
        {
            if (match == null)
            {
                return BadRequest("Match data is required.");
            }

            var player1Exists = await _dao.PlayerExistsAsync(match.Player1Id);
            var player2Exists = await _dao.PlayerExistsAsync(match.Player2Id);

            if (!player1Exists || !player2Exists)
            {
                return BadRequest("Both players must exist in the Players table.");
            }

            await _dao.AddMatchAsync(match);
            return CreatedAtAction(nameof(GetMatchById), new { matchId = match.MatchId }, match);
        }

        [HttpGet("{matchId}")]
        public async Task<IActionResult> GetMatchById(int matchId)
        {
            var match = await _dao.GetMatchByIdAsync(matchId);
            if (match == null)
            {
                return NotFound("Match not found.");
            }
            return Ok(match);
        }

        [HttpGet("by-country")]
        public async Task<IActionResult> GetPlayersByCountry([FromQuery] string country)
        {
            if (string.IsNullOrWhiteSpace(country))
            {
                return BadRequest("Country parameter is required.");
            }

            var players = await _dao.GetPlayersByCountryAsync(country);
            return Ok(players);
        }

        [HttpGet("performance")]
        public async Task<IActionResult> GetPlayerPerformance([FromQuery] int playerId)
        {
            if (playerId <= 0)
            {
                return BadRequest("Invalid player ID.");
            }

            var performance = await _dao.GetPlayerPerformanceAsync(playerId);
            if (performance == null)
            {
                return NotFound("Player not found.");
            }
            return Ok(performance);
        }

        [HttpGet("above-average-wins")]
        public async Task<IActionResult> GetPlayersAboveAverageWins()
        {
            var players = await _dao.GetPlayersAboveAverageWinsAsync();
            return Ok(players);
        }
    }
}
