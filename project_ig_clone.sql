USE ig_clone;

-- 1.Create an ER diagram or draw a schema for the given database.

-- 2.We want to reward the user who has been around the longest, Find the 5 oldest users.
SELECT *
FROM users
ORDER BY created_at
LIMIT 5;

-- 3.To target inactive users in an email ad campaign, find the users who have never posted a photo.
SELECT *
FROM users
WHERE id NOT IN (SELECT DISTINCT user_id
				FROM photos);
                    
-- 4.Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
WITH photo_count AS
	(SELECT photo_id, count(user_id) AS NoOfLikes 
    FROM likes 
    GROUP BY photo_id),
    userid AS 
    (SELECT ph.user_id AS postedby, pc.photo_id, pc.NoOfLikes 
    FROM photos ph INNER JOIN photo_count pc ON ph.id=pc.photo_id)
    
SELECT us.username, ud.photo_id, ud.NoOfLikes 
FROM users us 
INNER JOIN userid ud ON us.id = postedby
WHERE NoOfLikes = (SELECT max(NoOfLikes) FROM userid);


-- 5.The investors want to know how many times does the average user post.
WITH avg_post AS
	(SELECT COUNT(id) AS count 
	FROM photos 
	GROUP BY user_id)
SELECT round(AVG(count)) avg_post_per_user FROM avg_post;


-- 6.A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.
WITH hashtag AS
	(SELECT * 
	FROM photo_tags pt 
	INNER JOIN tags t ON pt.tag_id = t.id)
SELECT count(tag_id), tag_name 
FROM hashtag 
GROUP BY tag_name
ORDER BY count(tag_id) DESC
LIMIT 5;

            
-- 7.To find out if there are bots, find users who have liked every single photo on the site.
SELECT us.id, us.username 
FROM users us 
INNER JOIN likes lk ON us.id = lk.user_id
GROUP BY lk.user_id 
HAVING count(user_id) = (SELECT count(DISTINCT photo_id) FROM likes);


-- 8.Find the users who have created instagramid in may and select top 5 newest joinees from it?
SELECT id,username, created_at
FROM users
WHERE MONTH(created_at) = 5
ORDER BY created_at DESC
LIMIT 5;


-- 9.Can you help me find the users whose name starts with c and ends with any number and have 
-- posted the photos as well as liked the photos?
SELECT * 
FROM users 
WHERE username LIKE 'c%' AND username LIKE '[[:digit:]]$'
AND id IN (SELECT DISTINCT user_id FROM photos) 
AND id IN (SELECT DISTINCT user_id FROM likes);


-- 10.Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.
WITH user_count AS
	(SELECT user_id, count(*) photos_posted 
    FROM photos 
    GROUP BY user_id 
    HAVING count(*) BETWEEN 3 AND 5 
    LIMIT 30)
SELECT username, photos_posted 
FROM users us 
INNER JOIN user_count uc ON us.id = uc.user_id;