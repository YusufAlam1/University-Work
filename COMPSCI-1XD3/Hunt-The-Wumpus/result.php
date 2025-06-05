<!--
 Author: Yusuf Alam
 MACID: alamy1
 Student Number: 400568561
 Date: March 29th, 2025
 Description: Displaying to the user whetether they caught wumpus or not 
                (mainly an html file the logic is in resultLogic.php for practice of separation of concerns)
-->

<!-- ran into quite a few issues when connecting to the remote side had to debug by showing the errors  
 <php
ini_set('display_errors', 1);
error_reporting(E_ALL);
 >
-->

<!DOCTYPE html>
<html>

<head>
    <title>Hunt the Wumpus - Result</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/wumpus.css">
    <link rel="stylesheet" href="css/result.css">
</head>

<body>
    <div id="container">
        <h1>Hunt the Wumpus!</h1>

        <?php include 'php/resultLogic.php'; ?>

        <form id="playerForm" action="save.php" method="post">
            <h3>Submit Your Score</h3>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>
            <input type="hidden" name="result" value="<?php echo $foundWumpus ? 'win' : 'loss'; ?>">

            <div id="error-message"></div>

            <input type="submit" value="Submit Score">
        </form>

    </div>
    <script src="js/validateEmail.js"></script>
</body>

</html>