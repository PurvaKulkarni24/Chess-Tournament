-- Setting the path to the schema 'chess'
SET SEARCH_PATH TO chess;
SHOW SEARCH_PATH;

-- Creating table 'players' in the database 'Chess Tournament'
CREATE TABLE chess.players(
	player_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	current_world_ranking INT UNIQUE NOT NULL,
	total_matches_played INT DEFAULT 0 NOT NULL
);

-- Checking the structure of the table 'players'
SELECT * FROM chess.players;

-- Creating table 'matches' in the database 'Chess Tournament'
CREATE TABLE chess.matches (
	match_id SERIAL PRIMARY KEY,
	player1_id INT NOT NULL REFERENCES chess.players(player_id),
	player2_id INT NOT NULL REFERENCES chess.players(player_id),
	match_date DATE NOT NULL,
	match_level VARCHAR(20) CHECK(match_level IN ('International', 'National')) NOT NULL,
	winner_id INT REFERENCES chess.players(player_id) 
);

-- Checking the structure of the table 'players'
SELECT * FROM chess.matches;

-- Creating table 'sponsors' in the database 'Chess Tournament'
CREATE TABLE chess.sponsors (
	sponsor_id SERIAL PRIMARY KEY,
	sponsor_name VARCHAR(100) UNIQUE NOT NULL,
	industry VARCHAR(50) NOT NULL,
	contact_email VARCHAR(100) NOT NULL,
	contact_phone VARCHAR(20) NOT NULL
);

-- Checking the structure of the table 'sponsors'
SELECT * FROM chess.sponsors;

-- Creating table 'player_sponsors' in the database 'Chess Tournament'
CREATE TABLE chess.player_sponsors (
	player_id INT NOT NULL REFERENCES chess.players(player_id),
	sponsor_id INT NOT NULL REFERENCES chess.sponsors(sponsor_id),
	sponsorship_amount NUMERIC(10,2) NOT NULL,
	contract_start_date DATE NOT NULL,
	contract_end_date DATE NOT NULL,
	PRIMARY KEY (player_id, sponsor_id) -- Composite Primary Key
);

-- Checking the structure of the table 'player_sponsors'
SELECT * FROM chess.player_sponsors;

-- Inserting rows into 'players' table
INSERT INTO chess.players (first_name, last_name, country, current_world_ranking, total_matches_played)
VALUES 
('Magnus', 'Carlsen', 'Norway', 1, 100),
('Fabiano', 'Caruana', 'USA', 2, 95),
('Ding', 'Liren', 'China', 3, 90),
('Ian', 'Nepomniachtchi', 'Russia', 4, 85),
('Wesley', 'So', 'USA', 5, 80),
('Anish', 'Giri', 'Netherlands', 6, 78),
('Hikaru', 'Nakamura', 'USA', 7, 75),
('Viswanathan', 'Anand', 'India', 8, 120),
('Teimour', 'Radjabov', 'Azerbaijan', 9, 70),
('Levon', 'Aronian', 'Armenia', 10, 72);

-- Checking the values of the table 'players'
SELECT * FROM chess.players;

-- Inserting rows into 'sponsors' table
INSERT INTO chess.sponsors (sponsor_name, industry, contact_email, contact_phone)
VALUES 
('TechChess', 'Technology', 'contact@techchess.com', '123-456-7890'),
('MoveMaster', 'Gaming', 'info@movemaster.com', '234-567-8901'),
('ChessKing', 'Sports', 'support@chessking.com', '345-678-9012'),
('SmartMoves', 'AI', 'hello@smartmoves.ai', '456-789-0123'),
('GrandmasterFinance', 'Finance', 'contact@grandmasterfinance.com', '567-890-1234');
-- Checking the values of the table 'sponsors'
SELECT * FROM chess.sponsors;

-- Inserting rows into 'matches' table
INSERT INTO chess.matches (player1_id, player2_id, match_date, match_level, winner_id)
VALUES 
(1, 2, '2024-08-01', 'International', 1),
(3, 4, '2024-08-02', 'International', 3),
(5, 6, '2024-08-03', 'National', 5),
(7, 8, '2024-08-04', 'International', 8),
(9, 10, '2024-08-05', 'National', 10),
(1, 3, '2024-08-06', 'International', 1),
(2, 4, '2024-08-07', 'National', 2),
(5, 7, '2024-08-08', 'International', 7),
(6, 8, '2024-08-09', 'National', 8),
(9, 1, '2024-08-10', 'International', 1);

-- Checking the values of the table 'matches'
SELECT * FROM chess.matches;

-- Inserting rows into 'player_sponsors' table
INSERT INTO chess.player_sponsors (player_id, sponsor_id, sponsorship_amount, contract_start_date, contract_end_date)
VALUES 
(1, 1, 500000.00, '2023-01-01', '2025-12-31'),
(2, 2, 300000.00, '2023-06-01', '2024-06-01'),
(3, 3, 400000.00, '2024-01-01', '2025-01-01'),
(4, 4, 350000.00, '2023-03-01', '2024-03-01'),
(5, 5, 450000.00, '2023-05-01', '2024-05-01'),
(6, 1, 250000.00, '2024-02-01', '2025-02-01'),
(7, 2, 200000.00, '2023-08-01', '2024-08-01'),
(8, 3, 600000.00, '2023-07-01', '2025-07-01'),
(9, 4, 150000.00, '2023-09-01', '2024-09-01'),
(10, 5, 300000.00, '2024-04-01', '2025-04-01');

-- Checking the values of the table 'player_sponsors'
SELECT * FROM chess.player_sponsors;

-- Phase 2 Q1)  List the match details including the player names (both player1 and player2), match date, and match level for all International matches.
SELECT p1.first_name  || ' ' || p1.last_name AS player1_name, p2.first_name  || ' ' || p2.last_name AS player2_name, m.match_date, m.match_level FROM chess.matches m INNER JOIN chess.players p1 ON p1.player_id = m.player1_id INNER JOIN chess.players p2 ON p2.player_id = m.player2_id WHERE m.match_level = 'International';

-- Phase 2 Q2)  Extend the contract end date of all sponsors associated with players from the USA by one year.
SELECT ps.contract_end_date, p.country FROM chess.player_sponsors ps INNER JOIN chess.players p ON 
ps.player_id = p.player_id WHERE p.country = 'USA';
UPDATE chess.player_sponsors SET contract_end_date = DATE_ADD(contract_end_date, INTERVAL '1 YEAR') WHERE player_id IN(SELECT player_id FROM chess.players WHERE country = 'USA');
	
-- Phase 2 Q3)  List all matches played in August 2024, sorted by the match date in ascending order.
SELECT * FROM chess.matches WHERE match_date BETWEEN '2024-08-01' AND '2024-08-31' ORDER BY match_date;

-- Phase 2 Q4)  Calculate the average sponsorship amount provided by sponsors and display it along with the total number of sponsors. Dispaly with the title Average_Sponsorship  and Total_Sponsors.
SELECT AVG(sponsorship_amount) AS Average_Sponsorship, COUNT(DISTINCT sponsor_id) AS Total_Sponsors
FROM  chess.player_sponsors;

-- Phase 2 Q5)  Show the sponsor names and the total sponsorship amounts they have provided across all players. Sort the result by the total amount in descending order.
SELECT s.sponsor_name, SUM(ps.sponsorship_amount) AS total_sponsorship_amount 
FROM chess.player_sponsors ps JOIN chess.sponsors s ON ps.sponsor_id = s.sponsor_id 
GROUP BY s.sponsor_name ORDER BY total_sponsorship_amount DESC;

-- Phase 3 Q1)  Retrieve the names of players along with their total number of matches won, calculated as a percentage of their total matches played.Display the full_name along with  Win_Percentage rounded to 4 decimals
SELECT p.first_name || ' ' || p.last_name AS player_name, ROUND((COALESCE(COUNT(m.match_id), 0) * 100.0) / p.total_matches_played, 4) AS win_percentage FROM chess.players p LEFT JOIN chess.matches m ON p.player_id = m.winner_id GROUP BY p.player_id, p.first_name, p.last_name, p.total_matches_played;

-- Phase 3 Q2)  Retrieve the match details for matches where the winner's current world ranking is among the top 5 players. Display the match date, winner's name, and the match level.
SELECT m.match_date, p.first_name || ' ' || p.last_name AS winner_name, m.match_level FROM 
chess.matches m INNER JOIN chess.players p ON m.winner_id = p.player_id
WHERE m.winner_id IN (SELECT player_id FROM chess.players ORDER BY current_world_ranking LIMIT 5);

-- Phase 3 Q3) Find the sponsors who are sponsoring the top 3 players based on their current world ranking. Display the sponsor name and the player's full name an their world ranking .
SELECT s.sponsor_name, p.first_name || ' ' || p.last_name AS player_name, p.current_world_ranking
FROM (SELECT player_id, first_name, last_name, current_world_ranking FROM chess.players ORDER BY current_world_ranking LIMIT 3) p INNER JOIN chess.player_sponsors ps ON p.player_id = ps.player_id 
INNER JOIN chess.sponsors s ON ps.sponsor_id = s.sponsor_id;

-- Phase 3 Q4) Create a query that retrieves the full names of all players along with a label indicating their performance in the tournament based on their match win percentage. The label should be:
-- "Excellent" if the player has won more than 75% of their matches.
-- "Good" if the player has won between 50% and 75% of their matches.
-- "Average" if the player has won between 25% and 50% of their matches.
-- "Needs Improvement" if the player has won less than 25% of their matches.
-- The query should also include the player's total number of matches played and total number of matches won. The calculation for the win percentage should be done using a subquery.
WITH PlayerWins AS (SELECT p.player_id, p.first_name, p.last_name, p.total_matches_played, COUNT(m.match_id) AS total_wins FROM chess.players p
LEFT JOIN chess.matches m ON p.player_id = m.winner_id GROUP BY p.player_id, p.first_name, p.last_name, p.total_matches_played
)
SELECT first_name || ' ' || last_name AS player_name, total_wins, total_matches_played, ROUND((total_wins * 100.0) / total_matches_played, 2) AS win_percentage,
CASE
WHEN (total_wins * 100.0) / total_matches_played > 75 THEN 'Excellent'
WHEN (total_wins * 100.0) / total_matches_played BETWEEN 50 AND 75 THEN 'Good'
WHEN (total_wins * 100.0) / total_matches_played BETWEEN 25 AND 50 THEN 'Average'
ELSE 'Needs Improvement'
END AS performance_label
FROM PlayerWins;

-- Phase 3 Q5) Retrieve the names of players who have never won a match (i.e., they have participated in matches but are not listed as a winner in any match). Display their full name and current world ranking.
SELECT p.first_name || ' ' || p.last_name AS player_name, p.current_world_ranking FROM chess.players p
WHERE p.player_id NOT IN (SELECT DISTINCT winner_id FROM chess.matches) AND p.total_matches_played > 0; 

-- Phase 4 Q1)  Create a view named PlayerRankings that lists all players with their full name (first name and last name combined), country, and current world ranking, sorted by their world ranking in ascending order.
CREATE VIEW view_playerRankings AS SELECT first_name || ' ' || last_name AS full_name, country, current_world_ranking
FROM chess.players ORDER BY current_world_ranking;

SELECT * FROM view_playerRankings;

-- Phase 4 Q2) Create a view named MatchResults that shows the details of each match, including the match date, the names of the players (both player1 and player2), and the name of the winner. If the match is yet to be completed, the winner should be displayed as 'TBD'.
CREATE VIEW view_matchResults AS SELECT m.match_date, p1.first_name || ' ' || p1.last_name AS player1_name, p2.first_name || ' ' || p2.last_name AS player2_name, COALESCE(w.first_name || ' ' || w.last_name, 'TBD') AS winner
FROM chess.matches m INNER JOIN chess.players p1 ON m.player1_id = p1.player_id INNER JOIN chess.players p2 ON m.player2_id = p2.player_id LEFT JOIN chess.players w ON m.winner_id = w.player_id;

SELECT * FROM view_matchResults;

-- Phase 4 Q3) Create a view named SponsorSummary that shows each sponsor's name, the total number of players they sponsor, and the total amount of sponsorship provided by them.
CREATE VIEW view_sponsorSummary AS SELECT s.sponsor_name, COUNT(ps.player_id) AS total_players_sponsored, SUM(ps.sponsorship_amount) AS total_sponsorship_amount FROM chess.sponsors s INNER JOIN chess.player_sponsors ps ON s.sponsor_id = ps.sponsor_id GROUP BY s.sponsor_name;

SELECT * FROM view_sponsorSummary;

-- Phase 4 Q4) Create a view named ActiveSponsorships that lists the active sponsorships (where the contract end date is in the future). The view should include the player’s full name, sponsor name, and sponsorship amount. Ensure the view allows updates to the sponsorship amount.
CREATE VIEW view_activeSponsorships AS SELECT p.first_name || ' ' || p.last_name AS player_name, s.sponsor_name, ps.sponsorship_amount FROM chess.player_sponsors ps INNER JOIN chess.players p ON ps.player_id = p.player_id INNER JOIN chess.sponsors s ON ps.sponsor_id = s.sponsor_id WHERE ps.contract_end_date > CURRENT_DATE;

SELECT * FROM view_activeSponsorships;

-- Phase 4 Q5)  Create a view named PlayerPerformanceSummary that provides a detailed summary of each player's performance in the chess tournament. The view should include the following columns:
-- Player Name: Full name of the player (concatenation of first_name and last_name).
-- Total Matches Played: The total number of matches the player has participated in.
-- Total Wins: The total number of matches the player has won.
-- Win Percentage: The percentage of matches won by the player.
-- Best Match Level: The highest level (either "International" or "National") where the player has won the most matches. If the player has an equal number of wins at both levels, the view should return "Balanced".
-- Ensure that the view accounts for players who have not won any matches by returning NULL for the Total Wins and Win Percentage columns, and appropriately handles the Best Match Level logic.

CREATE VIEW view_playerPerformanceSummary AS SELECT p.first_name || ' ' || p.last_name AS player_name, COUNT(*) AS total_matches_played, SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) AS total_wins,
CASE 
WHEN COUNT(*) = 0 THEN NULL
ELSE (SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) * 100.0 / COUNT(*))
END AS win_percentage,
CASE
WHEN MAX(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END) > 
MAX(CASE WHEN m.match_level = 'National' AND m.winner_id = p.player_id THEN 1 ELSE 0 END) THEN 'International'
WHEN MAX(CASE WHEN m.match_level = 'National' AND m.winner_id = p.player_id THEN 1 ELSE 0 END) > 
MAX(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END) THEN 'National'
WHEN MAX(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END) = MAX(CASE WHEN m.match_level = 'National' AND m.winner_id = p.player_id THEN 1 ELSE 0 END) AND MAX(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END) > 0 THEN 'Balanced'
ELSE NULL
END AS best_match_level
FROM chess.players p LEFT JOIN  chess.matches m ON p.player_id = m.player1_id OR p.player_id = m.player2_id
GROUP BY p.player_id, p.first_name, p.last_name;

SELECT * FROM view_playerPerformanceSummary;