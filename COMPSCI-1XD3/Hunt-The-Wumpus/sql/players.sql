-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 04, 2025 at 05:23 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `alamy1_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `email` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `wins` int(11) NOT NULL DEFAULT 0,
  `losses` int(11) NOT NULL DEFAULT 0,
  `date_last_played` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`email`, `name`, `wins`, `losses`, `date_last_played`) VALUES
('0yusufalam@gmail.com', 'cityboi jj', 3, 1, '2025-04-03'),
('alamy1@mcmaster.ca', '4', 1, 1, '2025-04-03'),
('batman@gmail.com', 'Batman', 999, 0, '2024-12-31'),
('doge@example.com', 'Elon Musk', 0, 10, '2025-03-12'),
('goat@gmail.com', 'Eli Manning', 2, 0, '2025-03-02'),
('GWL@gmail.com', 'Gottfried Willhelm Leibniz', 5, 1, '1716-11-14'),
('king@gmail.com', 'LeBron Jamezz', 4, 6, '2025-03-25'),
('maxwynn@gmail.com', 'Drake', 1, 1, '2025-03-10'),
('potus@usa.com', 'DJT', 0, 7, '2025-03-18'),
('scotts52@mcmaster.ca', 'Sam Scott', 1000, 0, '2025-03-20'),
('thatGuy@gmail.com', 'HIM', 20, 20, '2025-03-22'),
('who@gmail.com', 'Joe', 9, 1, '2025-02-27');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`email`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
