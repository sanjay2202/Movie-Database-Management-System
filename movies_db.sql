-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 23, 2023 at 03:36 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `movies_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getmovies_genre` (IN `genre` VARCHAR(20))   BEGIN
    select movies.id, movies.title, movies.actor, movies.producer, movies.director
    from movies JOIN genre ON movies.genre=genre.id WHERE genre.title = genre;
    end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getmovies_review` (IN `movie` VARCHAR(20))   BEGIN
    select movies.id, movies.title, review.id, review.review
    from movies JOIN review ON movies.id=review.movie_id WHERE movies.title = movie;
    end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_movie_likes` ()   BEGIN
	DECLARE done INTEGER DEFAULT 0;
    DECLARE movie_id int;
    DECLARE movie_title varchar(10);
    DECLARE no_likes int;
	DEClARE curlikes CURSOR FOR SELECT movies.id, movies.title, COUNT(likes) FROM movies JOIN review ON movies.id=review.movie_id GROUP BY movies.id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN curlikes;

	LABLE: LOOP
	FETCH curlikes INTO movie_id, movie_title, no_likes;
	IF done = 1 THEN 
	LEAVE LABLE;
	END IF;
	INSERT INTO movies_likes VALUES(movie_id, movie_title, no_likes);
	END LOOP;

	CLOSE curlikes;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `eligible` (`AGE` INTEGER) RETURNS VARCHAR(20) CHARSET utf8mb4 DETERMINISTIC BEGIN
    IF age > 12 THEN
    RETURN ("yes");
    ELSE
    RETURN ("No");
    END IF;
    end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `full_name`, `username`, `password`) VALUES
(5, '1', '1', 'c4ca4238a0b923820dcc509a6f75849b'),
(6, '2', '2', 'c4ca4238a0b923820dcc509a6f75849b'),
(7, 'BBBBBB', 'PES1UG20CS000', 'c81e728d9d4c2f636f067f89cc14862c');

-- --------------------------------------------------------

--
-- Table structure for table `genre`
--

CREATE TABLE `genre` (
  `id` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `img_name` varchar(255) DEFAULT NULL,
  `featured` varchar(10) DEFAULT NULL,
  `active` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `genre`
--

INSERT INTO `genre` (`id`, `title`, `img_name`, `featured`, `active`) VALUES
(4, 'Thriller', 'genere_175.jpg', 'No', 'Yes'),
(5, 'Romance', 'genere_540.jpg', 'Yes', 'Yes'),
(6, 'Children', 'genere_693.jpg', 'Yes', 'Yes'),
(7, 'Comedies', 'genere_773.jpg', 'No', 'Yes'),
(8, 'Crime', 'genere_103.jpg', 'No', 'Yes'),
(9, 'Documentries', 'genere_150.jpg', 'Yes', 'Yes'),
(10, 'Drama', 'genere_749.jpg', 'No', 'Yes'),
(11, 'Suspense', 'genere_167.jpg', 'No', 'Yes'),
(12, 'Feel-Good', 'genere_542.jpg', 'No', 'Yes');

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `id` int(11) NOT NULL,
  `age_req` varchar(10) DEFAULT NULL,
  `genre` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `revenue` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `image_name` varchar(255) DEFAULT NULL,
  `actor` varchar(100) DEFAULT NULL,
  `producer` varchar(100) DEFAULT NULL,
  `director` varchar(100) DEFAULT NULL,
  `featured` varchar(10) DEFAULT NULL,
  `active` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`id`, `age_req`, `genre`, `description`, `revenue`, `title`, `image_name`, `actor`, `producer`, `director`, `featured`, `active`) VALUES
(6, '16', 4, 'sdfghjk', 20000000, 'A-quiet-place', 'content_5657.jpg', 'John Krasinski  ', 'ambani ', 'Christopher Nolan ', 'Yes', 'Yes'),
(7, '12', 4, 'aaaaaaaaaaaaaaaaaaa', 230000000, 'Black-swan', 'content_5076.jpg', 'Natali Portman   ', 'Malya  ', 'karan johar  ', 'No', 'Yes'),
(8, '16', 5, 'bbbbbbbb', 540000000, 'Titanic', 'content_6527.jpg', 'Leonardo Decaprio ', 'Nirav Modi ', 'Moeen Ali ', 'No', 'Yes'),
(9, '12', 5, 'nnnnnnnnnn', 8000000, 'La La land', 'content_8825.jpg', 'Emma Stone', 'Malya', 'karan johar', 'Yes', 'Yes'),
(10, '6', 6, 'Minions!!!!!!!!', 26300000, 'Despicable-Me', 'content_6534.jpg', 'Gru ', 'Nirav Modi ', 'Christopher Nolan ', 'No', 'Yes'),
(11, '6', 6, 'Frozen Lady', 78000000, 'Frozen', 'content_9128.jpg', 'Natali Portman', 'ambani', 'Moeen Ali', 'Yes', 'Yes'),
(12, '16', 10, 'Facebook', 65005000, 'The-Social-Network', 'content_2049.jpg', 'Mark Zukerberg', 'Nirav Modi', 'Christopher Nolan', 'Yes', 'Yes'),
(13, '16', 10, 'a dont know', 37090000, 'Fight-Club', 'content_9394.jpg', 'Brad Pitt ', 'Malya ', 'Moeen Ali ', 'No', 'Yes'),
(14, '16', 11, 'Girl-Goneee.', 53826490, 'Gone-Girl', 'content_8068.jpg', 'Emma Stone', 'Malya', 'karan johar', 'Yes', 'Yes'),
(15, '16', 11, 'island', 2147483647, 'Shutter-Island', 'Food-Name-5196.jpg', 'Leonardo Decaprio ', 'Nirav Modi ', 'karan johar ', 'Yes', 'Yes'),
(16, '16', 7, 'Peter Griffin', 976026671, 'Family-Guy', 'content_1621.jpg', 'Mark Zukerberg', 'ambani', 'Christopher Nolan', 'Yes', 'Yes'),
(17, '14', 7, 'No God Please Noooo!!', 274874299, 'The Office', 'content_2217.jpg', 'Brad Pitt', 'Malya', 'Christopher Nolan', 'Yes', 'Yes'),
(18, '18', 8, 'crimee', 42000000, 'Making-a-Murderer', 'content_9803.jpg', 'Natali Portman', 'ambani', 'yakuza', 'Yes', 'Yes'),
(19, '18', 8, 'loooooong', 420420420, 'Long-Shot', 'content_4360.jpg', 'Mark Zukerberg  ', 'Nirav Modi  ', 'yakuza  ', 'No', 'Yes'),
(20, '12', 12, 'Minecrafft', 53547888, 'Forest-Gump', 'content_6982.jpg', 'Brad Pitt', 'ambani', 'karan johar', 'Yes', 'Yes'),
(21, '12', 12, 'school dont rock', 79366600, 'School-of-rock', 'content_3156.jpg', 'Brad Pitt', 'ambani', 'Moeen Ali', 'Yes', 'Yes'),
(22, '14', 9, 'documentries are boring', 34520000, 'Amanda Knox', 'content_5592.jpg', 'Amanda', 'Malya', 'karan johar', 'Yes', 'Yes'),
(23, '14', 9, 'balance', 47290090, 'Man On Wire', 'content_6096.jpg', 'Natali Portman ', 'ambani ', 'Christopher Nolan ', 'No', 'Yes'),
(24, '16', 4, 'i love batman', 590000000, 'Joker', 'content_5818.jpg', 'Joaquin Pheonix ', 'ambani ', 'Christopher Nolan ', 'No', 'Yes'),
(25, '16', 4, 'Mysterio', 2147483647, 'Night Crawler', 'content_6851.jpg', 'Jake jillehnhall', 'Malya', 'Moeen Ali', 'No', 'Yes'),
(26, '16', 4, 'Transformers guy', 21876381, 'The silence of the Lambs', 'Food-Name-600.jpg', 'Leonardo Decaprio ', 'Nirav Modi ', 'karan johar ', 'No', 'Yes');

-- --------------------------------------------------------

--
-- Table structure for table `movies_likes`
--

CREATE TABLE `movies_likes` (
  `movie_id` int(11) DEFAULT NULL,
  `movie_title` varchar(60) DEFAULT NULL,
  `no_likes` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `movies_likes`
--

INSERT INTO `movies_likes` (`movie_id`, `movie_title`, `no_likes`) VALUES
(6, 'A-quiet-pl', '1'),
(7, 'Black-swan', '3'),
(6, 'A-quiet-pl', '4'),
(7, 'Black-swan', '6'),
(8, 'Titanic', '1'),
(9, 'La La land', '1'),
(6, 'A-quiet-pl', '4'),
(7, 'Black-swan', '6'),
(8, 'Titanic', '1'),
(9, 'La La land', '1');

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `id` int(11) NOT NULL,
  `likes` int(11) DEFAULT NULL,
  `dislikes` int(11) DEFAULT NULL,
  `review` varchar(255) DEFAULT NULL,
  `movie_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`id`, `likes`, `dislikes`, `review`, `movie_id`, `user_id`) VALUES
(35, 0, 1, 'why is the swan black', 7, 10),
(36, 1, 0, 'nice movie', 7, 10),
(38, 0, 1, 'i dont like the movie', 7, 11),
(39, 1, 0, 'nice', 8, 11),
(41, 1, 0, 'nice movie', 7, 13),
(42, 1, 0, 'poiuytre', 6, 14),
(43, 0, 1, 'dggh', 6, 14),
(44, 1, 0, 'SUPER MOVIE', 9, 14),
(45, 1, 0, 'dfhgjhkl', 6, 14),
(46, 1, 0, ';poh', 6, 14),
(47, 1, 0, 'LOVED THE MOVIE', 7, 15),
(48, 1, 0, 'nice', 7, 17);

--
-- Triggers `review`
--
DELIMITER $$
CREATE TRIGGER `review_validation` BEFORE INSERT ON `review` FOR EACH ROW BEGIN
    DECLARE error_msg VARCHAR(300);
    SET error_msg = ("Review filed is empty");
    IF new.review = ' ' THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = error_msg;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

CREATE TABLE `subscription` (
  `id` int(11) NOT NULL,
  `sub_price` int(11) DEFAULT NULL,
  `sub_name` varchar(255) DEFAULT NULL,
  `active` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `subscription`
--

INSERT INTO `subscription` (`id`, `sub_price`, `sub_name`, `active`) VALUES
(1, 1000, 'Monthly', 'Yes'),
(2, 3000, 'Quarterly', 'Yes'),
(3, 4500, 'Half-Yealy', 'Yes'),
(4, 9000, 'Yearly', 'Yes');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `F_name` varchar(30) DEFAULT NULL,
  `L_name` varchar(30) DEFAULT NULL,
  `age_req` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `gender` varchar(30) DEFAULT NULL,
  `subscription` int(11) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `F_name`, `L_name`, `age_req`, `email`, `username`, `gender`, `subscription`, `password`) VALUES
(10, 'Manoj', 'Kendole', 1, '1@g.com', 'manoj', 'Male', 2, 'c4ca4238a0b923820dcc509a6f75849b'),
(11, 'Sanjay', 'Kendole', 13, '11@g.com', 'sanjay', 'Male', 4, '6512bd43d9caa6e02c990b0a82652dca'),
(13, 'Sanjay', 'Kendole', 20, '5@g.com', '5', 'Female', 2, 'e4da3b7fbbce2345d7772b0674a318d5'),
(14, 'bhanu', 'shekhar', 18, 'b@gmail.com', 'bhanu', 'Male', 1, '81dc9bdb52d04dc20036dbd8313ed055'),
(15, 'Sanjay', 'Kendole', 19, 'sanjay.kn2211@gmail.com', 'sanjay', 'Male', 4, '5f1c5342818bf8c161d8ff4e18ff1720'),
(16, 'raj', 'Kendole', 20, 'raj@gamil.com', 'raj', 'Male', 3, '65a1223dae83b8092c4edba0823a793c'),
(17, 'raj', 'shekhar', 20, 'raj@gmail.com', 'raj', 'Male', 3, '65a1223dae83b8092c4edba0823a793c');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `age_validation` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    DECLARE error_msg VARCHAR(300);
    SET error_msg = ("Age of the user should be 12 or more");
    IF new.age_req < 12 THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = error_msg;
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `genre`
--
ALTER TABLE `genre`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `genre` (`genre`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `movie_id` (`movie_id`);

--
-- Indexes for table `subscription`
--
ALTER TABLE `subscription`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subscription` (`subscription`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `genre`
--
ALTER TABLE `genre`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `subscription`
--
ALTER TABLE `subscription`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `movies`
--
ALTER TABLE `movies`
  ADD CONSTRAINT `movies_ibfk_1` FOREIGN KEY (`genre`) REFERENCES `genre` (`id`);

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `review_ibfk_2` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`subscription`) REFERENCES `subscription` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
