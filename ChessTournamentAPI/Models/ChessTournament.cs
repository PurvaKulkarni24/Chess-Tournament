namespace ChessTournamentAPI.Models
{
    public class ChessTournament
    {
        public class Player
        {
            public int PlayerId { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string Country { get; set; }
            public int CurrentWorldRanking { get; set; }
            public int TotalMatchesPlayed { get; set; }
        }
        public class Match
        {
            public int MatchId { get; set; }
            public int Player1Id { get; set; }
            public int Player2Id { get; set; }
            public DateTime MatchDate { get; set; }
            public string MatchLevel { get; set; }
            public int? WinnerId { get; set; }
        }
        public class Sponsor
        {
            public int SponsorId { get; set; }
            public string SponsorName { get; set; }
            public string Industry { get; set; }
            public string ContactEmail { get; set; }
            public string ContactPhone { get; set; }
        }
        public class PlayerSponsor
        {
            public int PlayerId { get; set; }
            public int SponsorId { get; set; }
            public decimal SponsorshipAmount { get; set; }
            public DateTime ContractStartDate { get; set; }
            public DateTime ContractEndDate { get; set; }
        }
        public class PlayerAboveAverage
        {
            public string FullName { get; set; }
            public int TotalMatchesWon { get; set; }
            public decimal WinPercentage { get; set; }
        }
        public class PlayerPerformance
        {
            public string FullName { get; set; }
            public int TotalMatchesPlayed { get; set; }
            public int TotalMatchesWon { get; set; }
            public decimal WinPercentage { get; set; }
        }

    }
}
