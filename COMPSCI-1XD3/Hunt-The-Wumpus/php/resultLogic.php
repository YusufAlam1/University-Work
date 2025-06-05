<!--
 Author: Yusuf Alam
 MACID: alamy1
 Student Number: 400568561
 Date: March 31th, 2025
 Description: Displaying to the user whetether they caught wumpus or not 
                (mainly an html file the logic is in resultLogic.php for practice of separation of concerns)
-->

<?php
require_once 'php/connect.php';

$row = filter_input(INPUT_GET, 'row', FILTER_VALIDATE_INT);
$col = filter_input(INPUT_GET, 'column', FILTER_VALIDATE_INT);

// If someone were to type in the parameters in the url making the code robust
if ($row === false || $col === false || $row < 1 || $row > 7 || $col < 1 || $col > 7) {
    echo "<p>Invalid location. Please try again.</p><p><a href='index.php'>Back to Game</a></p>";
    exit;
}

$stmt = $db->prepare("SELECT * FROM wumpuses WHERE `row` = :row AND col = :col");
$stmt->execute(['row' => $row, 'col' => $col]);
$foundWumpus = $stmt->rowCount() > 0;

if ($foundWumpus) {
    // echo realpath("../images/wumpusless.png"); some debugging had some issues with the image

    echo "<div class='result-message'><h2>You found a Wumpus!</h2><img src='images/wumpus.png' width='300'></div>";
} else {
    echo "<div class='result-message'><h2>You did NOT find a Wumpus :(</h2><img src='images/wumpusless.png' width='300'></div>";
}
?>