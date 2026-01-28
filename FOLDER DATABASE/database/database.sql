-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 27, 2026 at 06:50 AM
-- Server version: 11.4.9-MariaDB-cll-lve
-- PHP Version: 8.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bere9277_db_sayyid`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_tokens`
--

CREATE TABLE `auth_tokens` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `auth_tokens`
--

INSERT INTO `auth_tokens` (`id`, `user_id`, `token`, `expires_at`, `created_at`) VALUES
(1, 1, 'e4cf014dddbd7258c293513d3ea7f1730b0bb6750e84c0ca52d70cd4269b714c', '2026-02-08 02:14:04', '2026-01-09 02:14:04'),
(2, 1, '99580ebbda82b2bfba6dfd9cee3ada6d4879478690318524ebeff313a3414999', '2026-02-08 02:14:21', '2026-01-09 02:14:21'),
(3, 1, 'f1afe352be53d0b451442fe4affa68ac221612b6672ff3843ec35afb59445398', '2026-02-08 02:14:36', '2026-01-09 02:14:36'),
(4, 4, '1e496b16878fef25c9ce9ccc2cddc7945d58bd35fb43aaa649a8d1c4de5b669c', '2026-02-08 02:14:51', '2026-01-09 02:14:51'),
(5, 4, '8605823a093fbf8aea7c16c7c311a78735c4556ec8c17b2273b8b9aa01f327ae', '2026-02-08 02:15:14', '2026-01-09 02:15:14'),
(6, 4, '49cdeac8f9a02d3d53621c839e3f014f92a56de402dae72b29e2c422bdcb04fa', '2026-02-08 02:17:41', '2026-01-09 02:17:41'),
(7, 4, '2a8c497c4cb5680720b4912886de9dba2005473e0dd358e9d9820e0c23265c74', '2026-02-08 02:19:28', '2026-01-09 02:19:28'),
(8, 4, 'd97ca8aa52bf4656915f3ee19546e53d68e633e8154a50a3f8affb78ca569186', '2026-02-08 02:24:46', '2026-01-09 02:24:46'),
(9, 1, '60ede166a96c317308d2c36ddd7b13ff22f8243b4c3f9029d519b4b39bd02fcd', '2026-02-08 02:27:57', '2026-01-09 02:27:57'),
(10, 4, '9e20b6bb54c53d824d34cd383fe7a79854f22a0e7780d28e6a93c7b7e7c90435', '2026-02-08 02:37:54', '2026-01-09 02:37:54'),
(11, 4, '9777ded1cea89131005680db9b43621b86b872de2814bea77b634fb08468054b', '2026-02-08 02:53:00', '2026-01-09 02:53:00'),
(12, 4, '1af84204b25ab5d04f153971287b39f78fa76c2dea7dcd3159207ab3365a51ba', '2026-02-08 02:57:05', '2026-01-09 02:57:05'),
(13, 1, 'f3d50916cc1def42c2453e5b44f17f39732eb6c4bae4565ebed331eebe836e13', '2026-02-08 03:14:40', '2026-01-09 03:14:40'),
(14, 4, '35212d570e20209c8fd43939113bb54db8c502f4aede71649aa67bcd0a8b24ef', '2026-02-08 03:19:39', '2026-01-09 03:19:39'),
(15, 4, 'fc898f36a1cd82588eac8c7420a442097a070683554a5967a3a55241f10ca408', '2026-02-08 03:22:10', '2026-01-09 03:22:10'),
(16, 4, '463b2392bd048c613476677e07ef89752d6a30314b215c83a2bf23236e9cb81f', '2026-02-10 03:33:54', '2026-01-11 03:33:54'),
(17, 4, '78d379bd3cf4404a9abd234b28cde2d70dc2ed87493f29e1e0c7a7b2e5efd602', '2026-02-10 03:37:17', '2026-01-11 03:37:17'),
(18, 4, 'd86bd000746b415e5a479e9a42b9f3b6adbb5cf56cf9ea47c237eb1eeb1af23e', '2026-02-10 04:13:17', '2026-01-11 04:13:17'),
(19, 4, 'a073354be485f853d0f47b1d6f9bea60b333123f27aa8ae5b47367e5214d5bdd', '2026-02-10 04:20:04', '2026-01-11 04:20:04'),
(20, 4, 'a69c7e50bb063f57930c79f373739113d82024d66e208bf47149e311b7e02acd', '2026-02-10 04:22:41', '2026-01-11 04:22:41'),
(21, 4, '20ab63689ccc2940433b7cca3a0ea351ecc72d6546b0f97e3503186fc23fb271', '2026-02-12 07:41:29', '2026-01-13 07:41:29'),
(22, 4, 'b231e742bd4e0217ccf4197948567220348ceae0b9a3f3298470bc8389f9d84f', '2026-02-12 07:44:27', '2026-01-13 07:44:27'),
(23, 4, 'ffa2a76fdc9c97cf6833416782fc76d0d6d015733f5cea80d2342f3841149542', '2026-02-13 13:02:58', '2026-01-14 13:02:58'),
(24, 4, '5425eb2b8b9bdb3f58945e9b68cf84e8b24ee19110bc9e6a6ae0b882cfddbf3d', '2026-02-13 13:07:57', '2026-01-14 13:07:57'),
(25, 4, 'c2fd9c5508fda43bdc4e3c3d1cc90fa00de06d9901d9e85afe4d2e2fe6accbda', '2026-02-13 13:10:15', '2026-01-14 13:10:15'),
(26, 4, '6828cc270467b3a8fefc8aa6a570cc3c83b03cc01fd4d50f448befa04f232493', '2026-02-14 03:53:18', '2026-01-15 03:53:18'),
(27, 4, '9d770582cee80f454cb623687c2a8b4490b0393fcd0f8025f1b948780a329d19', '2026-02-14 04:31:58', '2026-01-15 04:31:58'),
(28, 4, 'eb7da8c25f7af37c6f04800fe6409191c211a74eb2b90c920253005e2237fa63', '2026-02-19 23:50:34', '2026-01-20 23:50:34'),
(29, 5, '791a17e9f21f32c4aa45c3f5b14f39d3e3bef8212eb24badf9a9ad89c4c13276', '2026-02-20 13:21:35', '2026-01-21 13:21:35'),
(30, 5, '8588036a4909999dbc28541455a39012f63b635c9c2182b63e5c2de95b6ab8e0', '2026-02-20 13:23:35', '2026-01-21 13:23:35'),
(31, 5, '8b365dbadfbc39e6525f79673592633bb9184d52b617e4c3a3aff5c35b29b6a1', '2026-02-20 13:56:12', '2026-01-21 13:56:12'),
(32, 4, 'a188cb2b0e4346b11557b0a0db55e0804e070acfa905df9081e4e0417708bc37', '2026-02-20 14:42:32', '2026-01-21 14:42:32'),
(33, 6, '4b783df39f2a0a532ba3c363872a80bcd1f62333354e02b97e95847e8c100812', '2026-02-21 13:17:36', '2026-01-22 13:17:36'),
(34, 7, '749ceae8faf1b13b866f19013822f8920bdcb3442d250ed47144669753e27ad6', '2026-02-21 13:37:39', '2026-01-22 13:37:39'),
(35, 8, '943abb4fc4ff7d68b28521b628061bf7130db1b2bbac5f05373a9bd7bfc73907', '2026-02-21 13:45:38', '2026-01-22 13:45:38'),
(36, 9, 'd14e86ba99efc95c44ad28228ebceb3a511a0759835a1c0a3da92ac53de8a80e', '2026-02-21 13:47:24', '2026-01-22 13:47:24'),
(37, 9, '5e72b0a542fb3da00b2dd2ff7668469c456caf300524fc4d41168a9b94d12ee2', '2026-02-21 13:47:35', '2026-01-22 13:47:35'),
(38, 4, 'daf0558578a4926b0d98576948c2d053575ea4bb61f260ad1e597b902e64f560', '2026-02-21 14:18:38', '2026-01-22 14:18:38'),
(39, 4, 'b9a44372f06c80eab89635918ee8361cccfb6ad5fcaf9eb4452d3f3fa93fd6ee', '2026-02-21 14:38:39', '2026-01-22 14:38:39'),
(40, 4, 'fda98b1a39c7c4ab1819b925afa49566b243a4e8543a887696e01df66ecfb8bb', '2026-02-21 14:43:50', '2026-01-22 14:43:50'),
(41, 4, 'd8795b6dacb3f816e1dc746918f068f1d192c1d99f18159b1cef3e78eb52748b', '2026-02-21 15:09:22', '2026-01-22 15:09:22');

-- --------------------------------------------------------

--
-- Table structure for table `notes`
--

CREATE TABLE `notes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `content` text NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `notes`
--

INSERT INTO `notes` (`id`, `user_id`, `title`, `content`, `image_url`, `created_at`, `updated_at`) VALUES
(4, 4, 'Nyuhu', 'Hihi', NULL, '2026-01-14 13:10:26', '2026-01-14 13:10:26'),
(5, 4, 'Catatan Hari ini', 'Hai Aku Azzam', NULL, '2026-01-20 23:50:52', '2026-01-20 23:50:52'),
(8, 6, 'hshshs', 'Test', NULL, '2026-01-22 13:19:28', '2026-01-22 13:19:28'),
(11, 4, 'p', 'p', 'https://sayyid.bersama.cloud/api/image-note/note_69723dd26ff80_1769094610.png', '2026-01-22 15:10:11', '2026-01-22 15:10:11');

-- --------------------------------------------------------

--
-- Table structure for table `todolists`
--

CREATE TABLE `todolists` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `date` date NOT NULL,
  `priority` enum('low','medium','high') DEFAULT 'medium',
  `status` enum('pending','completed') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `todolists`
--

INSERT INTO `todolists` (`id`, `user_id`, `title`, `date`, `priority`, `status`, `created_at`, `updated_at`) VALUES
(2, 1, 'Review PHP API code', '2024-01-15', 'medium', 'completed', '2026-01-09 02:08:39', '2026-01-09 03:15:22'),
(3, 1, 'Setup MySQL database', '2024-01-16', 'high', 'completed', '2026-01-09 02:08:39', '2026-01-09 03:15:20'),
(6, 1, 'Deploy to production', '2024-01-20', 'high', 'completed', '2026-01-09 02:08:39', '2026-01-09 03:15:21'),
(7, 2, 'Design UI mockups', '2024-01-15', 'high', 'completed', '2026-01-09 02:08:39', '2026-01-09 02:08:39'),
(8, 2, 'Create wireframes', '2024-01-16', 'medium', 'completed', '2026-01-09 02:08:39', '2026-01-09 02:08:39'),
(9, 2, 'User testing session', '2024-01-17', 'high', 'pending', '2026-01-09 02:08:39', '2026-01-09 02:08:39'),
(10, 2, 'Update color scheme', '2024-01-18', 'low', 'pending', '2026-01-09 02:08:39', '2026-01-09 02:08:39'),
(14, 4, 'Lahai', '2026-01-13', 'low', 'pending', '2026-01-09 02:57:33', '2026-01-20 23:51:37'),
(16, 4, 'Nyapu', '2026-01-15', 'high', 'pending', '2026-01-14 13:09:20', '2026-01-20 23:51:35'),
(18, 4, 'Saya Lapar', '2026-01-22', 'medium', 'pending', '2026-01-22 03:27:43', '2026-01-22 03:27:43'),
(19, 4, 'Data satu', '2026-01-22', 'medium', 'pending', '2026-01-22 03:28:04', '2026-01-22 03:28:04'),
(20, 4, 'Data Dua', '2026-01-22', 'medium', 'completed', '2026-01-22 03:28:12', '2026-01-22 03:31:11'),
(21, 4, 'Data Tiga', '2026-01-22', 'medium', 'completed', '2026-01-22 03:28:20', '2026-01-22 03:31:12'),
(22, 4, '????', '2026-01-22', 'high', 'completed', '2026-01-22 03:31:00', '2026-01-22 03:31:13');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `name`, `photo`, `created_at`, `updated_at`) VALUES
(1, 'john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Doe', NULL, '2026-01-09 02:08:39', '2026-01-09 02:08:39'),
(2, 'jane@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane Smith', NULL, '2026-01-09 02:08:39', '2026-01-09 02:08:39'),
(3, 'admin@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User', NULL, '2026-01-09 02:08:39', '2026-01-09 02:08:39'),
(4, 'sayyid@gmail.com', '$2y$10$Df5Ncq34anuhkLEQFDpuierXisdfKk4BSk7KPjUCBCdpYPPNn1S3O', 'NYUHUUUU', 'https://sayyid.bersama.cloud/api/image-pp/profile_4_1768953060.png', '2026-01-09 02:14:51', '2026-01-20 23:51:00'),
(5, 'joni@joni.com', '$2y$10$/4H7m5eJDvoOLHEWyaFHputahvfo41esDNhkC2bAKCJhowt4NDhFK', 'Joni Kasep', 'https://sayyid.bersama.cloud/api/image-pp/profile_5_1769003814.png', '2026-01-21 13:21:35', '2026-01-21 13:57:04'),
(6, 'ibnu@gmail.com', '$2y$10$Gwi3ypiV2vfBAF2zy0oM9uOwB3K1irRxH/Y1strxKLCfSv1Vj0CsS', 'Afri Yudha', NULL, '2026-01-22 13:17:36', '2026-01-22 13:17:36'),
(7, 'bang@b.com', '$2y$10$Vk655XMy1PZY9.TPmdqtP.Ss7oUN69kxk4KS.DjD3JviBBl2XyDcq', 'babang', NULL, '2026-01-22 13:37:39', '2026-01-22 13:37:39'),
(8, 't@t.com', '$2y$10$clkgn6S/QTxHELOTvAWTauMWJZ0GQtnNQZ4MIQgGGGYwLSrqMNrbu', 'test', NULL, '2026-01-22 13:45:38', '2026-01-22 13:45:38'),
(9, 'a@a.com', '$2y$10$gvEUaOKnMueTKYwCIXwBBODAG30VZizLsT5fy8jF/ZvXlag4HFkYa', 'apip', NULL, '2026-01-22 13:47:24', '2026-01-22 13:47:24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_tokens`
--
ALTER TABLE `auth_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_token` (`token`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Indexes for table `notes`
--
ALTER TABLE `notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `todolists`
--
ALTER TABLE `todolists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_date` (`date`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_tokens`
--
ALTER TABLE `auth_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `notes`
--
ALTER TABLE `notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `todolists`
--
ALTER TABLE `todolists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_tokens`
--
ALTER TABLE `auth_tokens`
  ADD CONSTRAINT `auth_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notes`
--
ALTER TABLE `notes`
  ADD CONSTRAINT `notes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `todolists`
--
ALTER TABLE `todolists`
  ADD CONSTRAINT `todolists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
