<!--
 Author: Yusuf Alam
 MACID: alamy1
 Student Number: 400568561
 Date: March 29th, 2025
 Description: The page that will display the leaderboard table
-->

<!DOCTYPE html>
<html>

<head>
    <title>Hunt the Wumpus - Save Score</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/wumpus.css">
    <link rel="stylesheet" href="css/save.css">
</head>

<body>
    <div id="container">
        <h1>Hunt the Wumpus!</h1>
        <?php include 'php/saveLogic.php'; ?>
        <a href="index.php" class="play-again">Play Again</a>
    </div>
</body>

</html>