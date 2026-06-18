-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2026 at 04:56 PM
-- Server version: 11.8.6-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u696050269_bullmanat`
--

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

CREATE TABLE `company` (
  `company_id` int(10) NOT NULL,
  `company_name` varchar(100) NOT NULL,
  `destinations` varchar(200) NOT NULL,
  `phone` int(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `registration_number` int(100) NOT NULL,
  `status` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`company_id`, `company_name`, `destinations`, `phone`, `email`, `registration_number`, `status`) VALUES
(2, 'Al Noor Transport', 'Damascus - Aleppo', 999999999, 'info@alnoor.com', 123456, 0),
(3, 'Pullmanat Transport', 'Damascus, Homs, Aleppo', 933445566, 'info@pullmanat.com', 0, 0),
(4, '12Globasdfghl Logistics Express', 'New Yogrk, London, Tokyo, Paris', 2147483647, 'info@globallogistics.com', 0, 0),
(5, '12Globasdfghl Logistics Express', 'New Yogrk, London, Tokyo, Paris', 2147483647, 'info@globallogistics.com', 0, 0),
(6, ' ress', ', Paris', 567, 'cs.com', 0, 0),
(7, ' ress', ', Paris', 567, 'cs.com', 0, 0),
(8, ' ress', ', Paris', 567, 'cs.com', 0, 0),
(9, ' ress', ', Paris', 567, 'cs.com', 0, 0),
(10, 'شركة الأمير', 'حلب، دمشق', 985207410, 'noorhhsas@gmail.com', 101010, 1);

-- --------------------------------------------------------

--
-- Table structure for table `departure_points`
--

CREATE TABLE `departure_points` (
  `station_id` int(11) NOT NULL,
  `city_name` varchar(255) NOT NULL,
  `station_name` varchar(255) NOT NULL,
  `station_location` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departure_points`
--

INSERT INTO `departure_points` (`station_id`, `city_name`, `station_name`, `station_location`) VALUES
(1, 'ddddsf', 'Homs rr ertywsdfsdfsdfs', '23456wuiskd Center'),
(2, 'dd', 'Homs rr Station', 'Ci2ty Center'),
(3, 'fffffffff', '555555', 'wer');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(10) NOT NULL,
  `employee_name` varchar(200) NOT NULL,
  `email` varchar(50) NOT NULL,
  `job` varchar(50) NOT NULL,
  `company` varchar(100) NOT NULL,
  `password` varchar(200) NOT NULL,
  `employee_status` varchar(20) NOT NULL DEFAULT 'active',
  `company_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `employee_name`, `email`, `job`, `company`, `password`, `employee_status`, `company_id`) VALUES
(7, 'Ahmed Ali', 'ahmed@gmail.com', 'Driver', 'Bulmanat', '$2y$10$BYSXgTA4NCPkG.ZhLTfDyOmTQksm0wARd.0hNVshxbbxHlnUiKJnG', 'inactive', NULL),
(8, 'Ahmed Ali', 'ahmed@gmail.com', 'Driver', 'Bulmanat', '$2y$10$Arh0LHoUGIqJW6TveUfvauo5s2QmxiInv32u7yrV23vJTBa8YLw2K', 'active', NULL),
(9, 'Ali Ahmed', 'ali@example.com', 'driver', 'Pullmanat', '$2y$10$sDwaYlux7ZFHORFf2erw2OWqDAzsZaPlhI2nbC5Ji8Me6uJxGL9Zq', 'active', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `res_id` int(11) NOT NULL,
  `payment_method` varchar(255) NOT NULL,
  `amount_paid` double NOT NULL,
  `payment_date` date NOT NULL,
  `payment_status` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `res_id`, `payment_method`, `amount_paid`, `payment_date`, `payment_status`) VALUES
(4, 15, 'fff', 4444, '2026-04-29', 'paid'),
(5, 15, 'fff', 4444, '2026-04-29', 'paid'),
(6, 15, 'fff', 4444, '2026-04-29', 'paid'),
(7, 15, 'fff', 4444, '2026-04-29', 'paid'),
(8, 15, 'fff', 4444, '2026-04-29', 'paid'),
(9, 1, 'كاش', 50000, '2026-06-09', 'paid');

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `res_id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL,
  `trip_id` int(10) NOT NULL,
  `res_time` time(6) NOT NULL,
  `res_status` varchar(200) NOT NULL,
  `seat` int(11) DEFAULT NULL,
  `national_id` int(11) NOT NULL,
  `nods` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`res_id`, `user_id`, `trip_id`, `res_time`, `res_status`, `seat`, `national_id`, `nods`) VALUES
(1, 33, 14, '10:00:20.000000', 'ddddddddddddddddd', 551, 444555, 'zfsdr'),
(15, 40, 7, '12:00:00.000000', '', NULL, 0, ''),
(18, 44, 7, '20:15:33.000000', 'canceled', 1, 12312312, '1e321312'),
(19, 44, 7, '20:15:33.000000', 'canceled', 2, 1231231231, '1e321312'),
(20, 44, 7, '23:30:26.000000', 'canceled', 1, 4435435, '543534534fgdgdfgfdg'),
(21, 44, 7, '23:31:02.000000', 'active', 1, 4435435, '543534534fgdgdfgfdg'),
(22, 44, 7, '23:40:12.000000', 'active', 1, 423432, '324234'),
(23, 44, 7, '23:40:12.000000', 'active', 2, 324234, '324234'),
(24, 44, 7, '23:40:49.000000', 'active', 1, 234234, '23423423'),
(25, 44, 7, '00:05:40.000000', 'active', 1, 3123, '23232323'),
(26, 44, 7, '00:32:12.000000', 'active', 1, 4332, '234234');

-- --------------------------------------------------------

--
-- Table structure for table `special_requests`
--

CREATE TABLE `special_requests` (
  `request_id` int(11) NOT NULL,
  `departure_point` varchar(255) NOT NULL,
  `arrival_point` varchar(255) NOT NULL,
  `time` time NOT NULL,
  `date` date NOT NULL,
  `notes` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `special_requests`
--

INSERT INTO `special_requests` (`request_id`, `departure_point`, `arrival_point`, `time`, `date`, `notes`, `user_id`) VALUES
(5, 'Damascus', 'Aleppo', '14:30:23', '2026-04-28', 'Passenger requested VIP seat', NULL),
(6, 'دمشق', 'حلب', '17:18:46', '2026-06-09', 'تفاصيل إضافية للطلب', NULL),
(7, 'حلب', 'حمص', '17:24:58', '2026-06-09', 'التوقيت: 16/6/2026  8:24 م - عدد المقاعد: 3 - uuu', NULL),
(8, 'sss', 'cc', '20:22:00', '2026-06-09', 'التوقيت: 9/6/2026  3:21 م - عدد المقاعد: 2', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `trips`
--

CREATE TABLE `trips` (
  `trip_id` int(11) NOT NULL,
  `departure_city` varchar(100) NOT NULL,
  `destination_city` varchar(100) NOT NULL,
  `trip_date` date NOT NULL,
  `trip_time` time NOT NULL,
  `trip_price` double NOT NULL,
  `bus_namber` int(11) NOT NULL,
  `point_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trips`
--

INSERT INTO `trips` (`trip_id`, `departure_city`, `destination_city`, `trip_date`, `trip_time`, `trip_price`, `bus_namber`, `point_id`, `company_id`) VALUES
(7, 'sss', 'cc', '2026-04-20', '10:00:00', 52, 3, NULL, NULL),
(8, 'sss', 'cc', '2026-04-20', '10:00:00', 52, 3, NULL, NULL),
(9, 'sss', 'cc', '2026-04-20', '10:00:00', 52, 3, NULL, NULL),
(10, 'sss', 'cc', '2026-04-20', '10:00:00', 52, 3, NULL, NULL),
(13, 'Damascus', 'Homs', '2026-05-01', '14:30:00', 15000, 0, NULL, NULL),
(14, 'Damascus', 'Homs', '2026-05-01', '14:30:00', 15000, 0, NULL, NULL),
(15, 'Damascus', 'Homs', '2026-05-01', '14:30:00', 15000, 0, NULL, NULL),
(16, 'Damascus', 'Homs', '2026-05-01', '14:30:00', 15000, 0, NULL, NULL),
(17, 'Damascus', 'Homs', '2026-05-01', '14:30:00', 15000, 0, NULL, NULL),
(18, 'Aleppo', 'Latakia', '2026-06-10', '09:45:00', 18000, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(10) NOT NULL,
  `phone` int(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(200) NOT NULL,
  `account_creation_date` date NOT NULL,
  `image` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `phone`, `name`, `email`, `password`, `account_creation_date`, `image`) VALUES
(1, 988888888, 'new name', 'sdfgh', '82yuj', '2026-04-01', 'new.png'),
(22, 12345, 'qsadses', 'qwqw', '145', '2026-04-17', 'dasda'),
(33, 599999, 'Ahmed Ali', 'ah21med@ele.com', '$2y$10$7kTkEbPcoatrF.7TbeUGaO.F8e7iqpEOGiKjaLr03ILcN8uYysJbC', '2026-04-27', 'profile.png'),
(34, 123, 'Ahmed Ali', 'new@mail.com', '$2y$10$qhe98bvgMBb5Z5dh9.zc2erhIcLMW6SRSwCWlSMbje1oY9jRRkfVa', '2026-04-27', 'profile.png'),
(35, 345333, 'Ahmed Ali', 'shhss@mail.com', '$2y$10$Yfu5VyCVe9SLJA.HYUBZjObRQHw76A1qCnSGPo0mKMIPdrByYKHh.', '2026-04-27', 'profile.png'),
(36, 55, 'Ahmed Ali', 't@mail.com', '$2y$10$CwXrHitlnRaIEqPnx5is.eTS.Ule4Nh58SXO6NvnxYcmymOZa9gRy', '2026-04-27', 'profile.png'),
(37, 5255, 'Ahmed Ali', 'tss@mail.com', '$2y$10$xSk1aoRkK9hQfCqbJqrs/eP4tJwxO7NGMZ9Zj6dUi1wLdV/UiNo4O', '2026-04-28', 'profile.png'),
(38, 54445, 'Ahmed Ali', 'tsss@magsrdsil.com', '$2y$10$YAN.ooYzldooaVM4IbmYFOa7WOlhu7G25ak8Q16aP/648os1f7J4G', '2026-04-28', 'profile.png'),
(39, 1234567, 'Ahmed Ali', 'qwertyu@magsrdsil.com', '$2y$10$OHI8Zop/vtijUi1X0DjdfeLHp7AsgkDiVr4Jg/JfoFarD6WqcmSIm', '2026-04-28', 'profile.png'),
(40, 2147483647, 'new djdjd', 'c', '$2y$10$.g1Rar7D.4m5/vxVn/yfiOpItB/KxqhyNjV1Hs2Nh4Cas.MRXb2a.', '2026-04-28', 'new.png'),
(41, 123456789, 'kjhgfdsertyu Ali', 'ddr@dttresersserrrwe.com', '$2y$10$FqjKokPTUQWnxZg7oZO8S.yn4E4P0CjMN5pKUl9DYQpbHmKXtbq6e', '2026-04-28', 'profserasdfghjkefile.png'),
(42, 2147483647, 'ahmad', 'rtyfsis@example.com', '$2y$10$eaqmmfVQiX2D3jA7TkdL5.hIgtbpRC.pmaIUMVEm0/yD4BvHNqb8a', '2026-04-28', 'test.png'),
(43, 2147483647, 'ahmad', 'qwqw@gmail.com', '$2y$10$YL6DArMH6Xva4jcIkFCVf.ccxX74Jyc5BHR.DMDnJO.DSa2nRLGNm', '2026-04-28', 'test.png'),
(44, 19232323, '2Testman', 'safejo4396@fanchatu.com', '$2y$10$PapCCysPwavtgB2I7C7Gv..AJ4Bi6fBH1c79iASXJgevltH6XZNnG', '2026-06-09', ''),
(45, 917810328, 'StringIdName', 'diag_1781032816@test.com', '$2y$10$JhbAW8hnH84pBzdYeXVdKuVGNacCqawRXnRsTpCYPfi9kZAz/UfgC', '2026-06-09', 'none');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`company_id`);

--
-- Indexes for table `departure_points`
--
ALTER TABLE `departure_points`
  ADD PRIMARY KEY (`station_id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`),
  ADD KEY `company_id` (`company_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `res_id` (`res_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`res_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `trip_id` (`trip_id`);

--
-- Indexes for table `special_requests`
--
ALTER TABLE `special_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `trips`
--
ALTER TABLE `trips`
  ADD PRIMARY KEY (`trip_id`),
  ADD KEY `point_id` (`point_id`),
  ADD KEY `company_id` (`company_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `company_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `departure_points`
--
ALTER TABLE `departure_points`
  MODIFY `station_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `employee_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `res_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `special_requests`
--
ALTER TABLE `special_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `trips`
--
ALTER TABLE `trips`
  MODIFY `trip_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`res_id`) REFERENCES `reservations` (`res_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `special_requests`
--
ALTER TABLE `special_requests`
  ADD CONSTRAINT `special_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `trips`
--
ALTER TABLE `trips`
  ADD CONSTRAINT `trips_ibfk_1` FOREIGN KEY (`point_id`) REFERENCES `departure_points` (`station_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `trips_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
