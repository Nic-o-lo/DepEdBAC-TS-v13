-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 26, 2025 at 09:31 AM
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
-- Database: `doc_tracking`
--

-- --------------------------------------------------------

--
-- Table structure for table `officeid`
--

CREATE TABLE `officeid` (
  `officeID` int(11) NOT NULL,
  `officename` varchar(255) NOT NULL,
  `officedetails` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `officeid`
--

INSERT INTO `officeid` (`officeID`, `officename`, `officedetails`) VALUES
(1, 'OSDS', NULL),
(2, 'OASDS', NULL),
(3, 'ADMIN', NULL),
(4, 'SGOD CHIEF', NULL),
(5, 'CID CHIEF', NULL),
(6, 'CID', NULL),
(7, 'SGOD', NULL),
(8, 'RECORDS', NULL),
(9, 'BAC', NULL),
(10, 'CASH', NULL),
(11, 'BUDGET', NULL),
(12, 'PERSONNEL', NULL),
(13, 'PAYROLL', NULL),
(14, 'SUPPLY', NULL),
(15, 'IT', NULL),
(16, 'MEDICAL', NULL),
(17, 'DENTAL', NULL),
(18, '12 - PERSONNEL', NULL),
(19, '17 - DENTAL', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tblproject`
--

CREATE TABLE `tblproject` (
  `projectID` int(11) NOT NULL,
  `projectDetails` text DEFAULT NULL,
  `userID` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `editedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `prNumber` varchar(20) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `editedBy` int(11) DEFAULT NULL,
  `lastAccessedAt` datetime DEFAULT NULL,
  `lastAccessedBy` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tblproject`
--

INSERT INTO `tblproject` (`projectID`, `projectDetails`, `userID`, `createdAt`, `editedAt`, `prNumber`, `remarks`, `editedBy`, `lastAccessedAt`, `lastAccessedBy`) VALUES
(26, '1', 1, '2025-06-26 11:00:22', '2025-06-26 11:00:22', '1', NULL, NULL, NULL, NULL),
(27, 'qttyiti', 1, '2025-06-26 11:06:10', '2025-06-26 11:06:10', '987', NULL, NULL, NULL, NULL),
(28, 'ewq', 1, '2025-06-26 11:15:15', '2025-06-26 11:15:15', '123', NULL, NULL, NULL, NULL),
(35, 'fedvvsregvdzegwdbveadaefedvvsregvdzegwdbveadaefedvvsregvdzegwdbveadaefedvvsregvdzegwdbveadaefedvvsregvdzegwdbveadaefedvvsregvdzegwdbveadaefedvvsregvdzegwdbveadaefedvvsregvdzegwdbveadaefedvvsregvdzegwdbveadae', 1, '2025-06-26 11:55:45', '2025-06-26 13:58:10', '4536436', NULL, 1, '2025-06-26 13:58:10', 1),
(36, 'qwadsfavgedg', 1, '2025-06-26 14:04:56', '2025-06-26 14:07:34', '123', NULL, 1, '2025-06-26 14:07:34', 1),
(37, 'hjghj', 1, '2025-06-26 14:40:07', '2025-06-26 15:29:24', '88', NULL, 1, '2025-06-26 15:29:24', 1),
(38, 'asd', 1, '2025-06-26 14:58:29', '2025-06-26 14:58:29', '2147483647', NULL, NULL, NULL, NULL),
(39, 'asd', 1, '2025-06-26 14:59:00', '2025-06-26 14:59:00', '12345678956789', NULL, NULL, NULL, NULL),
(40, 'ads', 1, '2025-06-26 15:07:17', '2025-06-26 15:07:17', '1-1', NULL, NULL, NULL, NULL),
(42, 'asd', 2, '2025-06-26 15:15:27', '2025-06-26 15:15:27', '34567876543456787654', NULL, NULL, NULL, NULL),
(43, 'kk', 2, '2025-06-26 15:15:40', '2025-06-26 15:15:40', '6789-098765434567-09', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tblproject_stages`
--

CREATE TABLE `tblproject_stages` (
  `stageID` int(11) NOT NULL,
  `projectID` int(11) NOT NULL,
  `stageName` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `approvedAt` datetime DEFAULT NULL,
  `officeID` int(11) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `isSubmitted` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tblproject_stages`
--

INSERT INTO `tblproject_stages` (`stageID`, `projectID`, `stageName`, `createdAt`, `approvedAt`, `officeID`, `remarks`, `isSubmitted`) VALUES
(81, 26, 'Purchase Request', '2025-06-26 05:00:22', NULL, NULL, NULL, 0),
(82, 26, 'RFQ 1', NULL, NULL, NULL, NULL, 0),
(83, 26, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(84, 26, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(85, 26, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(86, 26, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(87, 26, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(88, 26, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(89, 27, 'Purchase Request', '2025-06-26 05:06:10', NULL, NULL, NULL, 0),
(90, 27, 'RFQ 1', NULL, NULL, NULL, NULL, 0),
(91, 27, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(92, 27, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(93, 27, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(94, 27, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(95, 27, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(96, 27, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(97, 28, 'Purchase Request', '2025-06-26 05:15:15', NULL, NULL, NULL, 0),
(98, 28, 'RFQ 1', NULL, NULL, NULL, NULL, 0),
(99, 28, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(100, 28, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(101, 28, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(102, 28, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(103, 28, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(104, 28, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(153, 35, 'Purchase Request', '2025-06-26 05:55:45', NULL, NULL, '', 0),
(154, 35, 'RFQ 1', '2025-06-26 07:56:36', NULL, NULL, NULL, 0),
(155, 35, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(156, 35, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(157, 35, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(158, 35, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(159, 35, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(160, 35, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(161, 36, 'Purchase Request', '2025-06-26 08:04:56', '2025-06-26 14:07:00', NULL, 'gk', 1),
(162, 36, 'RFQ 1', '2025-06-26 08:07:34', NULL, NULL, NULL, 0),
(163, 36, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(164, 36, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(165, 36, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(166, 36, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(167, 36, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(168, 36, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(169, 37, 'Purchase Request', '2025-06-26 14:40:07', '2025-06-26 15:29:00', 1, 'qwe', 1),
(170, 37, 'RFQ 1', '2025-06-26 14:56:21', NULL, NULL, NULL, 0),
(171, 37, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(172, 37, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(173, 37, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(174, 37, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(175, 37, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(176, 37, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(177, 38, 'Purchase Request', '2025-06-26 14:58:29', NULL, NULL, NULL, 0),
(178, 38, 'RFQ 1', NULL, NULL, NULL, NULL, 0),
(179, 38, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(180, 38, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(181, 38, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(182, 38, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(183, 38, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(184, 38, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(185, 39, 'Purchase Request', '2025-06-26 14:59:00', NULL, NULL, NULL, 0),
(186, 39, 'RFQ 1', NULL, NULL, NULL, NULL, 0),
(187, 39, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(188, 39, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(189, 39, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(190, 39, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(191, 39, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(192, 39, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(193, 40, 'Purchase Request', '2025-06-26 15:07:17', NULL, NULL, NULL, 0),
(194, 40, 'RFQ 1', NULL, NULL, NULL, NULL, 0),
(195, 40, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(196, 40, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(197, 40, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(198, 40, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(199, 40, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(200, 40, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(209, 42, 'Purchase Request', '2025-06-26 15:15:27', NULL, NULL, NULL, 0),
(210, 42, 'RFQ 1', NULL, NULL, NULL, NULL, 0),
(211, 42, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(212, 42, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(213, 42, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(214, 42, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(215, 42, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(216, 42, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0),
(217, 43, 'Purchase Request', '2025-06-26 15:15:40', NULL, NULL, NULL, 0),
(218, 43, 'RFQ 1', NULL, NULL, NULL, NULL, 0),
(219, 43, 'RFQ 2', NULL, NULL, NULL, NULL, 0),
(220, 43, 'RFQ 3', NULL, NULL, NULL, NULL, 0),
(221, 43, 'Abstract of Quotation', NULL, NULL, NULL, NULL, 0),
(222, 43, 'Purchase Order', NULL, NULL, NULL, NULL, 0),
(223, 43, 'Notice of Award', NULL, NULL, NULL, NULL, 0),
(224, 43, 'Notice to Proceed', NULL, NULL, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbluser`
--

CREATE TABLE `tbluser` (
  `userID` int(11) NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `middlename` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) NOT NULL,
  `position` varchar(100) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT 0,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `officeID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbluser`
--

INSERT INTO `tbluser` (`userID`, `firstname`, `middlename`, `lastname`, `position`, `admin`, `username`, `password`, `officeID`) VALUES
(1, 'Admin', '', 'User', '', 1, 'admin', 'admin', 1),
(2, 'Eloi', 'Pogi', 'Baculpo', 'Employee', 0, 'user', 'user', 1),
(7, 'wqe', 'qwe', 'qwe', 'qwe', 0, 'qwe', 'qwe', 9),
(8, 'Aaron', 'L', 'Villa', 'Admin', 1, 'aero', 'aero', 7),
(9, 'etits', 'etits', 'etits', 'etits', 1, 'etits', 'etits', 18);

-- --------------------------------------------------------

--
-- Table structure for table `track`
--

CREATE TABLE `track` (
  `trackID` int(11) NOT NULL,
  `trackDetails` text DEFAULT NULL,
  `userID` int(11) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `projectID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `officeid`
--
ALTER TABLE `officeid`
  ADD PRIMARY KEY (`officeID`);

--
-- Indexes for table `tblproject`
--
ALTER TABLE `tblproject`
  ADD PRIMARY KEY (`projectID`),
  ADD KEY `userID` (`userID`),
  ADD KEY `fk_edited_by` (`editedBy`),
  ADD KEY `fk_last_accessed_by` (`lastAccessedBy`);

--
-- Indexes for table `tblproject_stages`
--
ALTER TABLE `tblproject_stages`
  ADD PRIMARY KEY (`stageID`),
  ADD KEY `projectID` (`projectID`),
  ADD KEY `fk_stage_office` (`officeID`);

--
-- Indexes for table `tbluser`
--
ALTER TABLE `tbluser`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_user_office` (`officeID`);

--
-- Indexes for table `track`
--
ALTER TABLE `track`
  ADD PRIMARY KEY (`trackID`),
  ADD KEY `userID` (`userID`),
  ADD KEY `projectID` (`projectID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `officeid`
--
ALTER TABLE `officeid`
  MODIFY `officeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `tblproject`
--
ALTER TABLE `tblproject`
  MODIFY `projectID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `tblproject_stages`
--
ALTER TABLE `tblproject_stages`
  MODIFY `stageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=225;

--
-- AUTO_INCREMENT for table `tbluser`
--
ALTER TABLE `tbluser`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `track`
--
ALTER TABLE `track`
  MODIFY `trackID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tblproject`
--
ALTER TABLE `tblproject`
  ADD CONSTRAINT `fk_edited_by` FOREIGN KEY (`editedBy`) REFERENCES `tbluser` (`userID`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_last_accessed_by` FOREIGN KEY (`lastAccessedBy`) REFERENCES `tbluser` (`userID`) ON DELETE SET NULL,
  ADD CONSTRAINT `tblproject_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `tbluser` (`userID`);

--
-- Constraints for table `tblproject_stages`
--
ALTER TABLE `tblproject_stages`
  ADD CONSTRAINT `fk_stage_office` FOREIGN KEY (`officeID`) REFERENCES `officeid` (`officeID`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `tblproject_stages_fk` FOREIGN KEY (`projectID`) REFERENCES `tblproject` (`projectID`) ON DELETE CASCADE;

--
-- Constraints for table `tbluser`
--
ALTER TABLE `tbluser`
  ADD CONSTRAINT `fk_user_office` FOREIGN KEY (`officeID`) REFERENCES `officeid` (`officeID`) ON DELETE SET NULL;

--
-- Constraints for table `track`
--
ALTER TABLE `track`
  ADD CONSTRAINT `track_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `tbluser` (`userID`),
  ADD CONSTRAINT `track_ibfk_2` FOREIGN KEY (`projectID`) REFERENCES `tblproject` (`projectID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
