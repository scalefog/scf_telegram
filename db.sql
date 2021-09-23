CREATE TABLE `telegrams` (
  `id` int(11) NOT NULL,
  `recipient` varchar(255) NOT NULL,
  `sender` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `sentTime` varchar(25) NOT NULL,
  `message` varchar(455) NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT '0',
  `postoffice` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;