-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 18, 2025 at 05:38 AM (Adjusted for demonstration)
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+08:00";


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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
(17, 'DENTAL', NULL);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tblproject_stages`
--
-- REMOVED: `office` varchar(255) DEFAULT NULL
-- ADDED: `officeID` int(11) DEFAULT NULL
CREATE TABLE `tblproject_stages` (
  `stageID` int(11) NOT NULL,
  `projectID` int(11) NOT NULL,
  `stageName` varchar(255) NOT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `approvedAt` datetime DEFAULT NULL,
  `officeID` int(11) DEFAULT NULL, -- New column to store office ID
  `remarks` text DEFAULT NULL,
  `isSubmitted` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbluser`
--

INSERT INTO `tbluser` (`userID`, `firstname`, `middlename`, `lastname`, `position`, `admin`, `username`, `password`, `officeID`) VALUES
(1, 'Admin', '', 'User', 'Admin', 1, 'admin', 'admin', 1),
(2, 'Eloi', 'Pogi', 'Baculpo', 'Employee', 0, 'user', 'user', 1);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  ADD KEY `fk_stage_office` (`officeID`); -- Added index for the new foreign key

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
  MODIFY `officeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18; -- Changed AUTO_INCREMENT to 18 to reflect all existing data

--
-- AUTO_INCREMENT for table `tblproject`
--
ALTER TABLE `tblproject`
  MODIFY `projectID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `tblproject_stages`
--
ALTER TABLE `tblproject_stages`
  MODIFY `stageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `tbluser`
--
ALTER TABLE `tbluser`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

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
  ADD CONSTRAINT `tblproject_stages_fk` FOREIGN KEY (`projectID`) REFERENCES `tblproject` (`projectID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_stage_office` FOREIGN KEY (`officeID`) REFERENCES `officeid` (`officeID`) ON DELETE SET NULL ON UPDATE CASCADE; -- Added new foreign key constraint

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