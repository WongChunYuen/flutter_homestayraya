-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 30, 2023 at 10:48 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `homestayraya_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `homestays_tb`
--

CREATE TABLE `homestays_tb` (
  `homestay_id` int(5) NOT NULL,
  `user_id` int(6) NOT NULL,
  `homestay_imagesNum` int(3) NOT NULL,
  `homestay_name` varchar(100) NOT NULL,
  `homestay_desc` varchar(500) NOT NULL,
  `homestay_price` float NOT NULL,
  `homestay_address` varchar(200) NOT NULL,
  `homestay_state` varchar(20) NOT NULL,
  `homestay_local` varchar(50) NOT NULL,
  `homestay_lat` varchar(15) NOT NULL,
  `homestay_lng` varchar(15) NOT NULL,
  `homestay_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `homestays_tb`
--

INSERT INTO `homestays_tb` (`homestay_id`, `user_id`, `homestay_imagesNum`, `homestay_name`, `homestay_desc`, `homestay_price`, `homestay_address`, `homestay_state`, `homestay_local`, `homestay_lat`, `homestay_lng`, `homestay_date`) VALUES
(1, 1, 3, 'Kedah Homestay', 'A small homestay in Kedah, Changlun', 300, 'Changlun address', 'Kedah', 'Changlun', '6.4413817', '100.4389233', '2023-01-30 16:39:09.857377'),
(2, 1, 3, 'Sweet Kedah Home', 'Home sweet home', 350, 'Kedah address', 'Kedah', 'Changlun', '6.4413817', '100.4389233', '2023-01-30 16:44:15.472207'),
(3, 1, 4, 'Penang Home', 'Near Penang Hill', 450, 'Penang address', 'Penang', 'Batu Maung', '5.28448', '100.2831817', '2023-01-30 16:48:59.709727'),
(4, 1, 3, 'My House', 'Penang honstay house', 300, 'address', 'Penang', 'Batu Maung', '5.28448', '100.2831817', '2023-01-30 16:51:32.630730'),
(6, 2, 3, 'Pet Homestay', 'A homestay where you can play with pet', 600, 'puchong', 'Selangor', 'Puchong', '3.0215333', '101.6204667', '2023-01-30 16:58:02.625510'),
(7, 2, 3, 'Best Homestay', 'Best homestay in Seremban', 400, 'seremban', 'Negeri Sembilan', 'Seremban', '2.69184', '101.9045267', '2023-01-30 17:00:48.163330'),
(8, 2, 3, 'MyHome', 'Myhomestay home', 300, 'seremban address', 'Negeri Sembilan', 'Seremban', '2.69184', '101.9045267', '2023-01-30 17:05:03.063449');

-- --------------------------------------------------------

--
-- Table structure for table `users_tb`
--

CREATE TABLE `users_tb` (
  `user_id` int(5) NOT NULL,
  `user_image` varchar(10) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_phone` varchar(15) NOT NULL,
  `user_address` varchar(500) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `user_verification` varchar(10) NOT NULL,
  `otp` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users_tb`
--

INSERT INTO `users_tb` (`user_id`, `user_image`, `user_email`, `user_name`, `user_password`, `user_phone`, `user_address`, `user_datereg`, `user_verification`, `otp`) VALUES
(1, 'yes', 'yuenwong@gmail.com', 'yuenwong', '4a76da457b3afd23324ec4386609dfa42b637647', '01155283602', 'na', '2022-12-14 12:05:53.371672', 'yes', 443220),
(2, 'yes', 'botol1@gmail.com', 'Botol12', 'aa72659fbaf9b08d7a0f800fbc20ef51d4a3b72f', '01198765432', 'na', '2023-01-29 20:42:42.584996', 'yes', 543535),
(3, 'no', 'testing01@gmail.com', 'Testing', '99c884b90f6d2c6086075661a84f11798d0bddf6', '01298765432', 'na', '2023-01-30 13:11:23.605401', 'no', 925145),
(4, 'yes', 'account1@gmail.com', 'verifyAcc', '65bed9e4c503d2141ad2181975566226417c37ce', '01155656565', 'na', '2023-01-30 17:45:30.211738', 'yes', 508509);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `homestays_tb`
--
ALTER TABLE `homestays_tb`
  ADD PRIMARY KEY (`homestay_id`);

--
-- Indexes for table `users_tb`
--
ALTER TABLE `users_tb`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `homestays_tb`
--
ALTER TABLE `homestays_tb`
  MODIFY `homestay_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users_tb`
--
ALTER TABLE `users_tb`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
