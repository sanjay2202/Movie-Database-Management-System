

create table subscription (
    id int AUTO_INCREMENT,
    sub_price int,
    sub_name varchar(255),
    active varchar(10),
    PRIMARY KEY(id)
);


create table users (
    id int AUTO_INCREMENT,
    F_name varchar(30),
    L_name varchar(30),
    age_req int,
    email varchar(255),
    username varchar(255),
    gender varchar(30),
    subscription int,
    password varchar(100),
    primary key(id),
    foreign key(subscription) references subscription(id)

);

create table genre (
    id int AUTO_INCREMENT,
    title varchar(100),
    img_name varchar(255),
    featured varchar(10),
    active varchar(10),
    primary key(id)
);

create table movies (
    id int AUTO_INCREMENT,
    age_req varchar(10),
    genre int,
    description varchar(255),
    revenue int,
    title varchar(100),
    image_name varchar(255),
    actor varchar(100),
    producer varchar(100),
    director varchar(100),
    featured varchar(10),
    active varchar(10),
    primary key(id),
    foreign key(genre) references genre(id)
);



create table admin (
    id int AUTO_INCREMENT,
    full_name varchar(100),
    username varchar(100),
    password varchar(100),
    primary key(id)
);

create table review (
    id int AUTO_INCREMENT,
    likes int,
    dislikes int,
    review varchar(255),
    movie_id int,
    user_id int,
    primary key(id),
    foreign key(user_id) references users(id),
    foreign key(movie_id) references movies(id)
)

SELECT SUM(sub_price) AS Total from users JOIN subscription on users.subscription = subscription.id;

-- TRIGGER ---------------------------------------------------

DELIMITER $$
CREATE TRIGGER age_validation 
BEFORE INSERT 
ON users 
FOR EACH ROW
BEGIN
    DECLARE error_msg VARCHAR(300);
    SET error_msg = ("Age of the user should be 12 or more");
    IF new.age_req < 12 THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = error_msg;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER review_validation 
BEFORE INSERT 
ON review 
FOR EACH ROW
BEGIN
    DECLARE error_msg VARCHAR(300);
    SET error_msg = ("Review filed is empty");
    IF new.review = ' ' THEN 
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = error_msg;
    END IF;
END $$
DELIMITER ;

-- ---- ---------------------------------------------------

$sql5 = "SELECT MAX(revenue) AS Maximum from movies ";

-- PROCEDURE ---------------------------------------------------

DELIMITER $$
delimiter &&
CREATE PROCEDURE getmovies_genre(in genre varchar(20))
    BEGIN
    select movies.id, movies.title, movies.actor, movies.producer, movies.director
    from movies JOIN genre ON movies.genre=genre.id WHERE genre.title = genre;
    end &&
delimiter ;
CALL getmovies_genre('Thriller');

DELIMITER $$
delimiter &&
CREATE PROCEDURE getmovies_review(in movie varchar(20))
    BEGIN
    select movies.id, movies.title, review.id, review.review
    from movies JOIN review ON movies.id=review.movie_id WHERE movies.title = movie;
    end &&
delimiter ;
CALL getmovies_review('Black-swan');


-- FUNCTION ---------------------------------------------------


delimiter $$
create function eligible(AGE integer)
    RETURNS varchar(20)
    DETERMINISTIC
    BEGIN
    IF age > 12 THEN
    RETURN ("yes");
    ELSE
    RETURN ("No");
    END IF;
    end$$
delimiter ;
select eligible(11);
select eligible(13);


-- CURSOR ---------------------------------------------------

CREATE TABLE movies_likes(
    movie_id int,
    movie_title varchar(10),
    no_likes VARCHAR(50)
);


DELIMITER $$
CREATE PROCEDURE get_movie_likes()
BEGIN
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

DELIMITER ;
CALL get_movie_likes();

-- INTERSECT ---------------------------

SELECT user_id from review where movie_id = 7
INTERSECT
SELECT user_id from review where movie_id = 8;

-- UNION ------------------------------------

SELECT movies.title from movies where genre = 4
UNION
SELECT movies.title from movies where genre = 5;

-- UNION ALL----------------------------------
SELECT movies.title from movies
UNION ALL
SELECT movie_title from movies_likes ;