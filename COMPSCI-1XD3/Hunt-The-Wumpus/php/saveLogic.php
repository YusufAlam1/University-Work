<!--
 Author: Yusuf Alam
 MACID: alamy1
 Student Number: 400568561
 Date: March 31th, 2025
 Description: taking the players info (name, email & result) from result.php
                validates the data and then will either make a new player or update user's Stats
                displays the leaderboard of top 10 players
                user can play again
-->

<?php
require_once 'php/connect.php'; // taking from connect php so i dont have to repeat the same database importing code

$email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
$name = filter_input(INPUT_POST, 'name', FILTER_SANITIZE_STRING); // I am aware this is deprecated, however it will still be functioning for quite a bit
$result = filter_input(INPUT_POST, 'result', FILTER_SANITIZE_STRING);

// all though email is already verified, a little double check for good security practice & preventing some trickery
if ($email === false || $name === false || empty($name) || ($result !== 'win' && $result !== 'loss')) {
    echo "<div class='message'>Invalid form submission. Please try again.</div>";
    return;
}
if (!strpos(substr($email, strpos($email, '@') + 1), '.')) {
    echo "<div class='message'>Invalid email format. Please try again.</div>";
    return;
}

$currentDate = date('Y-m-d');

$stmt = $db->prepare("SELECT * FROM players WHERE email = :email");
$stmt->bindParam(':email', $email);
$stmt->execute();

$userExists = $stmt->rowCount() > 0;

// when the user name is recognized in the database
if ($userExists) {
    $query = $result === 'win' ?
        "UPDATE players SET wins = wins + 1, name = :name, date_last_played = :date WHERE email = :email" :
        "UPDATE players SET losses = losses + 1, name = :name, date_last_played = :date WHERE email = :email";

    $stmt = $db->prepare($query);
    $stmt->bindParam(':name', $name);
    $stmt->bindParam(':date', $currentDate);
    $stmt->bindParam(':email', $email);
    $stmt->execute();
} else {
    $wins = $result === 'win' ? 1 : 0;
    $losses = $result === 'win' ? 0 : 1;

    $stmt = $db->prepare("INSERT INTO players (email, name, wins, losses, date_last_played) VALUES (:email, :name, :wins, :losses, :date)");
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':name', $name);
    $stmt->bindParam(':wins', $wins);
    $stmt->bindParam(':losses', $losses);
    $stmt->bindParam(':date', $currentDate);
    $stmt->execute();
}

$stmt = $db->prepare("SELECT wins, losses FROM players WHERE email = :email");
$stmt->bindParam(':email', $email);
$stmt->execute();
$userStats = $stmt->fetch(PDO::FETCH_ASSOC);

echo "<div class='message'>Your game has been recorded!<br>Wins: {$userStats['wins']} | Losses: {$userStats['losses']}</div>";

$stmt = $db->prepare("SELECT name, wins, losses, date_last_played FROM players ORDER BY wins DESC LIMIT 10"); // top 10 from highest to lowest
$stmt->execute();
$topPlayers = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Using the special table format loops through the players available (top 10) and displays them
echo "<h2>Top 10 Players</h2><table class='leaderboard'><tr><th>Name</th><th>Wins</th><th>Losses</th><th>Last Played</th></tr>";
foreach ($topPlayers as $player) {
    echo "<tr><td>" . htmlspecialchars($player['name']) . "</td><td>{$player['wins']}</td><td>{$player['losses']}</td><td>{$player['date_last_played']}</td></tr>";
}
echo "</table>";
?>