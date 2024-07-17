--DROP DATABASE HomeSync;
CREATE DATABASE HomeSync;
go

use HomeSync;


CREATE TABLE Room(
    room_id INT PRIMARY KEY, 
    type VARCHAR(20), 
    floor INT, 
    status VARCHAR(20)
);

CREATE TABLE Users (
    ID INT PRIMARY KEY IDENTITY,
    f_name VARCHAR (20),
    l_name VARCHAR (20),
    password VARCHAR(20),
    email VARCHAR(50) UNIQUE,
    preference VARCHAR(20),
    room INT,
    FOREIGN KEY (room) REFERENCES room (room_id) ON DELETE CASCADE ON UPDATE CASCADE,
    TYPE VARCHAR(5),
    birthdate DATETIME NOT NULL,
    age AS (YEAR(CURRENT_TIMESTAMP)- YEAR(birthdate))
);

/*guest and admin are inherited so i gotta figure that out*/

CREATE TABLE Admin(
    admin_id INT PRIMARY KEY, 
    FOREIGN KEY (admin_id) REFERENCES Users (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    no_of_guests_allowed INT,
    salary DECIMAL(10,2)
);

CREATE TABLE Guest(
    guest_id INT PRIMARY KEY,
    guest_of INT NOT NULL DEFAULT 1,
    FOREIGN KEY (guest_id) REFERENCES Users (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (guest_of) REFERENCES Admin (admin_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    address VARCHAR(100),
    arrival_date DATE,
    departure_date DATE, /*datetime?*/
    residential VARCHAR(200) /*what*/
);



CREATE TABLE Task (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR (30),
    creation_date DATE DEFAULT CURRENT_TIMESTAMP,
    due_date DATETIME, 
    category VARCHAR(20),
    creator INT,
    FOREIGN KEY (creator) REFERENCES admin (admin_id) ON DELETE CASCADE ON UPDATE CASCADE,
    status VARCHAR (20), /*bas tbh status is limited to stuff so check!*/
    reminder_date DATETIME, 
    priority INT
);

CREATE TABLE Assigned_to ( /*how to make an attribute fk & pk*/
    admin_id INT NOT NULL,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (task_id, user_id, admin_id),
    FOREIGN KEY (admin_id) REFERENCES Admin (admin_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (task_id) REFERENCES Task (id)ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE Calendar (
    event_id INT,
    user_assigned_to INT,
    PRIMARY KEY (event_id,user_assigned_to),
    FOREIGN KEY (user_assigned_to) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    name VARCHAR (20),
    description VARCHAR (40),
    location VARCHAR (50),
    reminder_date DATE /*date*/
);

CREATE TABLE Notes (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    content VARCHAR (300), /*TEXT ??*/
    creation_date DATE, /*same question abt date*/
    title VARCHAR (20),
);


CREATE TABLE Travel(
    trip_no INT PRIMARY KEY, 
    hotel_name VARCHAR (20),
    destination VARCHAR (50),
    ingoing_flight_num VARCHAR(40), /*unique? or varchar?*/
    outgoing_flight_num VARCHAR(40), /*unique?*/
    ingoing_flight_date DATE,
    outgoing_flight_date DATETIME,
    ingoing_flight_airport VARCHAR (30), 
    outgoing_flight_airport VARCHAR (30), 
    transport VARCHAR (30), 
);

/*no idea if this is inheritence or relation?*/
CREATE TABLE User_trip(
    trip_no INT,
    user_id INT, 
    PRIMARY KEY (trip_no, user_id),
    FOREIGN KEY (trip_no) REFERENCES TRAVEL (trip_no) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    hotel_room_no INT, 
    in_going_flight_seat_number VARCHAR(4), /*eg A6*/
    out_going_flight_seat_number VARCHAR(4)
    );

CREATE TABLE Finance(
    payement_id INT PRIMARY KEY IDENTITY, 
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE, 
    type VARCHAR(30), 

    amount DECIMAL(8,5),
    currency VARCHAR(25), 
    method VARCHAR(20),  
    status VARCHAR(30), /*like sent/ recieved or not?? BIT?*/ 
    date DATE,
    receipt_no INT, 
    deadline DATE,
    penalty DECIMAL(8,5)
);

CREATE TABLE Health( /*she made it strong*/
    user_id INT, 
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    date DATE, 
    activity VARCHAR(20), /*do i add options?check?*/ 
    PRIMARY KEY (date, activity), 
     /*is it really unique without the user id tho what if 2 users did the same thing on the same day?*/
    hours_slept DECIMAL(4,2), /*check if a time dt exists*/
    food VARCHAR (200) /*no clue man*/
    );

CREATE TABLE Communication(
    message_Id INT PRIMARY KEY IDENTITY, 
    sender_ID INT, 
    reciever_id INT, 
    FOREIGN KEY (sender_ID) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (reciever_id) REFERENCES Users (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    content VARCHAR (500), 
    time_sent DATETIME, /*is there a data type called time?*/
    time_received DATETIME, 
    time_read DATETIME, 
    title VARCHAR (20)
);

CREATE TABLE Device(
    device_id INT PRIMARY KEY, 
    room INT, 
    FOREIGN KEY (room) REFERENCES Room (room_id) ON DELETE CASCADE ON UPDATE CASCADE,
    type VARCHAR(30), 
    status VARCHAR(30),  
    battery_status DECIMAL (3,0) /*we want a range*/
);



CREATE TABLE RoomSchedule( /*weak*/
    creator_id INT, 
    FOREIGN KEY (creator_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    room INT
    FOREIGN KEY (room) REFERENCES Room (room_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    start_time DATETIME, 
    end_time DATETIME, 
    PRIMARY KEY (creator_id ,start_time),
    action VARCHAR (100)   
);

CREATE TABLE Log(
    room_id INT, 
    FOREIGN KEY (room_id) REFERENCES Room(room_id) ON DELETE CASCADE ON UPDATE CASCADE,
    device_id INT, 
    FOREIGN KEY (device_id) REFERENCES Device(device_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    user_id INT, 
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
    date DATE, 
    PRIMARY KEY (room_id, device_id, user_id, date),
    activity VARCHAR (50), 
    duration DECIMAL(2,2)  /*datatype? decimal*/
);

CREATE TABLE Consumption(
    device_id INT, 
    FOREIGN KEY (device_id) REFERENCES Device (device_id) ON DELETE CASCADE ON UPDATE CASCADE,
    consumption DECIMAL(8,5), 
    date DATE,
    PRIMARY KEY (device_id, date)
);

CREATE TABLE Preferences(
    user_id INT, 
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    category VARCHAR(50), 
    preference_no INT,
    content VARCHAR(100),
    PRIMARY KEY (user_id, preference_no)
);

CREATE TABLE Recommendation(
    Recommendation_id INT PRIMARY KEY IDENTITY, 
    user_id INT, 
    FOREIGN KEY (user_id, preference_no) REFERENCES Preferences (user_id, preference_no) ON DELETE CASCADE ON UPDATE CASCADE,
    category VARCHAR(50), 
    preference_no INT, 
    /*FOREIGN KEY (preference_no) REFERENCES Preferences (preference_no) ON DELETE CASCADE ON UPDATE CASCADE,*/
    Content VARCHAR(100)
);

CREATE TABLE Inventory(
    supply_id INT PRIMARY KEY, 
    name VARCHAR(20), 
    quantity INT, 
    expiry_date DATE, 
    price DECIMAL(10,2), 
    manufacturer VARCHAR(50), 
    category VARCHAR(50)
);

CREATE TABLE Camera(
    monitor_id INT PRIMARY KEY, 
    FOREIGN KEY (monitor_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    camera_id INT,
    room_id INT
    FOREIGN KEY (room_id) REFERENCES Room (room_id) ON DELETE NO ACTION ON UPDATE NO ACTION,
);


---------------------------------------------------------------------------
--insertions--

INSERT INTO Room(room_id, type,floor,status) 
VALUES (1, 'Bedroom', 2 , 'Occupied' ) ;

INSERT INTO Room(room_id, type,floor,status) 
VALUES (2, 'Kitchen' , 1 , 'Occupied') ;

INSERT INTO Room(room_id, type,floor,status) 
VALUES (3, 'Bedroom' , 2 ,'Occupied') ;

INSERT INTO Room(room_id, type,floor,status) 
VALUES (4, 'Living room ' , 1 , 'Occupied') ;

INSERT INTO Room(room_id, type,floor,status) 
VALUES (5, 'Bedroom', 1 , 'Occupied') ;

INSERT INTO Room(room_id,type, floor,status) 
VALUES (6, 'Bedroom' , 3 , 'Vaccant') ;

INSERT INTO Room(room_id, type,floor,status) 
VALUES (7, 'Bedroom', 3 , 'Occupied' ) ;

INSERT INTO Room(room_id, type,floor,status) 
VALUES (8, 'Garden' , 0 , 'Occupied' ) ;

-----------------------------


INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('Eugene', 'Fitzherbert', 'qwerty123', 'eugene.Fitzherbert@gmail.com', 'Preference A', 1, 'Admin', '1990-05-15');

INSERT INTO Admin (admin_id, no_of_guests_allowed, salary)
VALUES (1, 5, 5000.00)


INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('Lara', 'Ali', 'TC123456', 'Lara.Ali@hotmail.com', 'Preference B', 2, 'Guest', '2004-12-06');

INSERT INTO GUEST (guest_id, guest_of, address, arrival_date, departure_date, residential)
VALUES (2, 1, 'Cornelia Street', '2023-11-23', '2023-11-28', 'room 3')


INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('Luna', 'Lee', 'Luna_lee-0921', 'Luna.lee@hotmail.com', 'Preference C', 3, 'Admin', '2004-08-22' );

INSERT INTO Admin (admin_id, no_of_guests_allowed, salary)
VALUES (3, 3, 25000.00)


INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('Code', 'Forces', 'cf_29018', 'code.forces@gmail.com', 'Preference D', 4, 'Guest', '1972-11-10');

INSERT INTO GUEST (guest_id, guest_of, address, arrival_date, departure_date, residential)
VALUES (4, 3, 'sea st', '2023-11-28', '2023-11-30', 'room 3')


INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('Java', 'Lava', 'java_lava20044', 'java.lava@gmail.com', 'Preference E', 5, 'Admin', '1994-04-06');

INSERT INTO Admin (admin_id, no_of_guests_allowed, salary)
VALUES (5, 2, 1000.00)


INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('Miriam', 'Koko', 'koko.123758', 'Miriam.koko@hotmail.com', 'Preference F', 4, 'Guest', '2002-12-24');

INSERT INTO GUEST (guest_id, guest_of, address, arrival_date, departure_date, residential)
VALUES (6, 3, 'Barbie st', '2023-11-28', '2023-11-30', 'room 3')



INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('Mo', 'Mi', 'Momi28982', 'Mo.Mi@gmail.com', 'Preference G ',1 , 'Admin', '1999-05-03');

INSERT INTO Admin (admin_id, no_of_guests_allowed, salary)
VALUES (7, 2, 1000.00)



INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('youssef', 'osman', 'Y_osman9082', 'youssef.osman@gmail.com', 'Preference H', 5, 'Guest', '2005-05-12');

INSERT INTO GUEST (guest_id, guest_of, address, arrival_date, departure_date, residential)
VALUES (8, 7 , 'gym st', '2023-12-01', '2023-12-02', 'room 5')


INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('Lana', 'Dream', 'uiiop_2121', 'Lana.Dream@gmail.com', 'Preference I', 8, 'Admin', '1990-05-15');

INSERT INTO Admin (admin_id, no_of_guests_allowed, salary)
VALUES (9, 3, 100000.00)


INSERT INTO Users (f_Name, l_Name, password, email, preference, room, type, birthdate) 
VALUES ('Olivia', 'Rodrigo', 'olivia_rod1982', 'olivia.rodrigo@hotmail.com', 'Preference J', 8, 'Guest', '1950-12-01');

INSERT INTO GUEST (guest_id, guest_of, address, arrival_date, departure_date, residential)
VALUES (10, 9 , 'vampire st', '2023-12-05', '2023-12-30', 'room 7')

 --------------------------


INSERT INTO Device(device_id, room ,type, status, battery_status)	
VALUES (1,1,'Mobile','Idle',60);

INSERT INTO Device(device_id, room ,type,status, battery_status)	
VALUES (2, 2,'Laptop','Active',90);

INSERT INTO Device(device_id, room ,type,status, battery_status)	
VALUES (3, 4,'Tablet','Acive', 100);

INSERT INTO Device(device_id, room ,type,status, battery_status)	
VALUES (4, 5,'Mobile','Idle',80);

INSERT INTO Device(device_id, room ,type,status, battery_status)	
VALUES (5, 3,'Laptop','Active',75);

-----------------------------------


INSERT INTO Task(name, creation_date, due_date, category, creator, status,reminder_date, priority)
VALUES ('Wash Dishes', '01/11/2023' , '01/11/2023' ,'cleaning' , 1 , 'DONE' , '01/11/2023' , 7 );

INSERT INTO Task(name, creation_date, due_date, category, creator, status,reminder_date, priority)
Values ('gym time' , '2023-11-17' , '2023-11-17' , 'self care' , 1 ,'ongoing' , '2023-11-17' , 7 );

INSERT INTO Task(name, creation_date, due_date, category, creator, status,reminder_date, priority)
Values ('fold clothes' ,'2023-11-05' , '2023-11-10' , 'cleaning' ,3 ,'ongoing' , '2023-11-09' , 3); --issue


--------------------------------


INSERT INTO Calendar(event_id, user_assigned_to , name, description, location, reminder_date)
VALUES (1, 1, 'Picinc' , 'Morning breakfast picnic' , 'Garden', '2023-11-01');

INSERT INTO Calendar(event_id, user_assigned_to , name, description, location, reminder_date)
VALUES (2, 3 , 'Movie night' ,'Watching a Horror movie at night' , 'Home cinema' , '2023-12-05');



------------------------------------------------------------------------------------------------------------------------------

-- (1-1) youssef ---
-- 

go

CREATE PROCEDURE UserRegister
@usertype varchar(20),
@email varchar(50),
@first_name varchar(20),
@last_name varchar(20),
@birth_date datetime , 
@password varchar(10),
@user_id INT OUTPUT
 AS 
 BEGIN 

IF NOT EXISTS (SELECT * FROM Users WHERE email= @email)
BEGIN 
	 INSERT INTO Users (f_name, l_name , password , type, email, birthdate) 
	 Values ( @first_name , @last_name , @password, @usertype, @email , @birth_date )

    SET @user_id = SCOPE_IDENTITY() ;

     IF (@usertype = 'Admin')
        BEGIN
        INSERT INTO Admin (admin_id) VALUES (@user_id)
        END
    ELSE
        BEGIN
        INSERT INTO Guest (guest_id) VALUES (@user_id)
        END
END 
ELSE 
BEGIN 
	PRINT 'This user already exists!'
    SET @user_id = (SELECT id FROM Users WHERE email = @email)
	END 
END


-- (2-1) youssef ------
go
CREATE PROCEDURE UserLogin 
@email varchar(50),
@password varchar(10),
@success bit OUTPUT ,
@User_id int OUTPUT 
AS 
BEGIN 
SET @success = 0 ;
SET @User_id = -1 ;
IF EXISTS (SELECT id FROM Users WHERE email = @email AND password = @password )
BEGIN 
SET @success = 1 ;
SELECT @User_id = id FROM users WHERE email = @email AND password = @password 
	END
END

/*DECLARE @mail VARCHAR(50) = 'user@example.com';
DECLARE @pass VARCHAR(10) = 'password';
DECLARE @flag BIT;
DECLARE @uid INT;
EXEC UserLogin
    @email = @mail,
    @password = @pass,
    @success = @flag OUTPUT,
    @user_id = @uid OUTPUT;
IF @flag = 1
    PRINT 'Login successful. User ID: ' + @uid;
ELSE
    PRINT 'Login failed. User not registered.';*/

-- (2-2) youssef---------
go
CREATE PROCEDURE ViewProfile
@user_id INT 
AS 
BEGIN 
 SELECT *
 FROM Users
 WHERE id = @user_id 
 END 




--(2-4) youssef ------

go
CREATE PROCEDURE ViewMyTask
@user_id int 
AS
BEGIN 
UPDATE Task SET Status = 'done'
WHERE id IN (SELECT task_id
             FROM Assigned_to
             WHERE user_id = @user_id)  AND due_date <GETDATE() ;

SELECT *
FROM Task 
WHERE id IN(
    SELECT task_id
    FROM Assigned_to
    WHERE user_id = @user_id
)
END





--(2-5) youssef ------ 

go
CREATE PROCEDURE  FinishMyTask
	 @user_id int,
	 @title varchar(50)
AS 
BEGIN 
UPDATE Task 
SET status = 'done'
WHERE Task.name = @title AND @user_id IN (
    SELECT A.user_id
    FROM Assigned_to A
    WHERE A.user_id = @user_id
)

END



--(2-6) youssef ----
go
CREATE PROCEDURE  ViewTask
 @user_id int,
 @creator int
 AS 
 BEGIN 
 SELECT *
	FROM Task 
	WHERE creator = @creator AND @user_id IN (
        SELECT user_id
        FROM Assigned_to
        WHERE creator = @creator AND user_id = @user_id
    )
	ORDER BY creation_date DESC ;
END 





--(2-7) youssef ---
go
CREATE PROCEDURE ViewMyDeviceCharge
 @device_id int, 
 @charge int OUTPUT, 
 @location int output 
 AS 
 BEGIN 
 SET @charge = NULL;
 SET @location = NULL;
    IF EXISTS (SELECT 1 FROM Device WHERE device_id = @device_id)
    BEGIN
        -- Get device charge and location
        SELECT @charge = battery_status, @location = room
        FROM Device
        WHERE device_id = @device_id;
    END
    ELSE
    BEGIN
    PRINT 'Incorrect device id!'
    END
END;

---PRINT 'Device Charge: ' + ISNULL(CAST(@charge AS VARCHAR), 'N/A');
---PRINT 'Device Location: ' + ISNULL(CAST(@location AS VARCHAR), 'N/A');

 --(2-8) youssef ----
 go
 CREATE PROCEDURE AssignRoom
 @user_id int,
 @room_id int
 AS
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE ID = @user_id) AND
       EXISTS (SELECT 1 FROM Room WHERE room_id = @room_id AND status = 'empty')
    BEGIN
        UPDATE Room
        SET status = 'booked'
        WHERE room_id = @room_id;
        UPDATE Users
        SET room = @room_id
        WHERE ID = @user_id;
    END
END;


 --(2-9) youssef--
 go
CREATE PROCEDURE CreateEvent
    @event_id INT,
    @user_id INT,
    @name VARCHAR(50),
    @description VARCHAR(200),
    @location VARCHAR(40),
    @reminder_date DATETIME,
    @other_user_id INT
AS
BEGIN
   
    
    INSERT INTO Calendar (event_id, user_assigned_to, name, description, location, reminder_date)
    VALUES (@event_id, @user_id, @name, @description, @location, @reminder_date);

    -- If there is another user involved, insert the information into the Calendar table as well
    IF (@other_user_id IS NOT NULL)
    BEGIN
        INSERT INTO Calendar (event_id, user_assigned_to, name, description, location, reminder_date)
        VALUES (@event_id, @other_user_id, @name, @description, @location, @reminder_date);
    END
END;

-- 2-10 --
go
CREATE PROCEDURE AssignUser
    @user_id INT,
    @event_id INT
AS
BEGIN
    -- Check if the user and event exist
    IF EXISTS (SELECT 1 FROM Users WHERE ID = @user_id) AND
       EXISTS (SELECT 1 FROM Calendar WHERE event_id = @event_id)
    BEGIN
        -- Insert the assignment into the Assigned_to table
        INSERT INTO Assigned_to (admin_id, task_id, user_id)
        VALUES (NULL, NULL, @user_id);
        -- Select and return details of the assigned user and event
        SELECT Users.ID, Calendar.*
        FROM Users
        JOIN Calendar ON Users.ID = @user_id AND Calendar.event_id = @event_id;
    END
    ELSE
    BEGIN
        PRINT 'User or Event not found.';
    END
END;

--(2-11) youssef --
go
CREATE PROCEDURE AddReminder
    @task_id int,
    @reminder datetime
AS
BEGIN
    UPDATE Task
    SET reminder_date = @reminder
    WHERE id = @task_id;
END



--(2-12) youssef --
go
CREATE PROCEDURE Uninvite
    @event_id INT,
    @user_id INT
AS
BEGIN
    DELETE FROM Calendar
    WHERE event_id = @event_id AND user_assigned_to = @user_id;
END;



--(2-13) youssef --
go
CREATE PROCEDURE UpdateTaskDeadline
    @deadline datetime,
    @task_id int
AS
BEGIN
    UPDATE Task
    SET due_date = @deadline
    WHERE id = @task_id;
END


--(2-14) youssef-----------------

go

CREATE PROCEDURE ViewEvent
    @User_id INT,
    @Event_id INT
AS
BEGIN
    IF @Event_id IS NULL
    BEGIN
        SELECT event_id, name, description, location, reminder_date
        FROM Calendar
        WHERE user_assigned_to = @User_id
        ORDER BY reminder_date;
    END
    ELSE
    BEGIN 
        SELECT event_id, name, description, location, reminder_date
        FROM Calendar
        WHERE user_assigned_to = @User_id AND event_id = @Event_id;
    END
END;



--(2-15) youssef ----------
go
CREATE PROCEDURE ViewRecommendation
AS
BEGIN
    SELECT Users.f_name, Users.l_name
    FROM Users
    WHERE NOT EXISTS (
        SELECT 1 --?
        FROM Recommendation
        WHERE Recommendation.user_id = Users.ID
    );
END;


--(2-16) youssef --
go
CREATE PROCEDURE CreateNote
    @User_id INT,
    @note_id INT,
    @title VARCHAR(50),
    @Content VARCHAR(500),
    @creation_date DATETIME
AS
BEGIN
    INSERT INTO Notes (user_id, Id, title, content, creation_date)
    VALUES (@User_id, @note_id, @title, @Content, @creation_date);
END

-------------------------------------------------------------------------------------------------------------------------------------


--(2-17) batool----

go
CREATE PROCEDURE ReceiveMoney
    @receiver_id INT,
    @type VARCHAR(30),
    @amount DECIMAL(13,2),
    @status VARCHAR(10),
    @date DATETIME
AS
BEGIN
    INSERT INTO Finance (user_id, type, amount, status, date)
    VALUES (@receiver_id, @type, @amount, @status, @date);
END;


--(2-18) batool -----
go
CREATE PROCEDURE PlanPayment
    @sender_id INT,
    @receiver_id INT,
    @type VARCHAR(30),
    @amount DECIMAL(13,2),
    @status VARCHAR(10),
    @deadline DATETIME
AS
BEGIN
    INSERT INTO Finance (user_id, type, amount, status, deadline)
    VALUES (@receiver_id, @type, @amount, @status, @deadline);

    INSERT INTO Finance (user_id, type, amount, status, deadline)
    VALUES (@sender_id, @type, @amount, @status, @deadline);
END;

 

--(2-19) batool ---------
go
CREATE PROCEDURE SendMessage
    @sender_id INT,
    @receiver_id INT,
    @title VARCHAR(30),
    @content VARCHAR(200),
    @timesent TIME,
    @timereceived TIME
AS
BEGIN
    INSERT INTO Communication (sender_ID, reciever_id, title, content, time_sent, time_received)
    VALUES (@sender_id, @receiver_id, @title, @content, @timesent, @timereceived);
END;



--the NoteTitle stored procedure
--(2-20) batool ---
go
CREATE PROCEDURE NoteTitle
    @user_id INT,
    @note_title VARCHAR(50)
AS
BEGIN
    UPDATE Notes
    SET title = @note_title
    WHERE user_id = @user_id;
END;
 

-- the ShowMessages stored procedure
--(2-21) batool -------
go
CREATE PROCEDURE ShowMessages
    @user_id INT,
    @sender_id INT
AS
BEGIN
    SELECT *
    FROM Communication
    WHERE reciever_id = @user_id
        AND sender_ID = @sender_id;
END;
 
 
-- the ViewUsers stored procedure
--(3-1) batool -----
GO
CREATE PROCEDURE ViewUsers
    @user_type VARCHAR(20)
AS
BEGIN
    SELECT *
    FROM Users
    WHERE type = @user_type;
END;




-- the RemoveEvent stored procedure
--(3-2) batool ---

go
CREATE PROCEDURE RemoveEvent
    @event_id INT,
    @user_id INT
AS
BEGIN
    DELETE FROM Calendar
    WHERE event_id = @event_id
      AND user_assigned_to = @user_id;
END;


--the CreateSchedule stored procedure
--(3-3) batool ---
go
CREATE PROCEDURE CreateSchedule
    @creator_id INT,
    @room_id INT,
    @start_time DATETIME,
    @end_time DATETIME,
    @action VARCHAR(20)
AS
BEGIN
    INSERT INTO RoomSchedule (creator_id, room, start_time, end_time, action)
    VALUES (@creator_id, @room_id, @start_time, @end_time, @action);
END;


-- the GuestRemove stored procedure
--(3-4) batool -- i stopped here

go
CREATE PROCEDURE GuestRemove
    @guest_id INT,
    @admin_id INT,
    @number_of_allowed_guests INT OUTPUT
AS
BEGIN
   IF EXISTS (
        SELECT 1
        FROM Admin
        WHERE admin_id = @admin_id
    )
    BEGIN
        DELETE FROM Guest
        WHERE guest_id = @guest_id;

        SELECT @number_of_allowed_guests = no_of_guests_allowed
        FROM Admin 
        WHERE admin_id = @admin_id --issue
    END
END --issue
 

 
-- the RecommendTD stored procedure

---3-5  batool ---
go
CREATE PROCEDURE RecommendTD
@Guest_id INT,
@destination  VARCHAR(10),
@age INT,
@preference_no INT
AS
BEGIN
DECLARE @G_age INT
SELECT @G_age = age
FROM Users U
INNER JOIN Guest G On U.id = G.guest_id
WHERE G.guest_id = @Guest_id

IF @G_age < @age
INSERT INTO Recommendation VALUES (@Guest_id, 'Travel' , @preference_no, @destination)

END



-- the Surveillance stored procedure
--(3-6) batool ----
go
CREATE PROCEDURE Surveillance
    @user_id INT,
    @location INT,
    @camera_id INT
AS
BEGIN
    SELECT *
    FROM Camera
    WHERE monitor_id = @user_id
        AND room_id = @location
        AND camera_id = @camera_id;
END;



-- the RoomAvailability stored procedure
--(3-7) batool --
go
CREATE PROCEDURE RoomAvailability
    @location INT,
    @status VARCHAR(40)
AS
BEGIN
    UPDATE Room
    SET status = @status
    WHERE room_id = @location; -- location is int and the only this that makes sense to be = location is room-id but it doesnt make sense :)

    PRINT 'Room status updated.';
END;



-- the Inventory stored procedure
--(3-8 ) batool --
go
CREATE PROCEDURE AddInventory --issue, rename
    @item_id INT,
    @name VARCHAR(30),
    @quantity INT,
    @expirydate DATETIME,
    @price DECIMAL(10, 2),
    @manufacturer VARCHAR(30),
    @category VARCHAR(20)
AS
BEGIN
    INSERT INTO Inventory (supply_id, name, quantity, expiry_date, price, manufacturer, category)
    VALUES (@item_id, @name, @quantity, @expirydate, @price, @manufacturer, @category);

    PRINT 'Inventory item added.';
END;

    

-- Create the Shopping stored procedure
--(3-9) batool --
go
CREATE PROCEDURE Shopping
    @id INT,
    @quantity INT,
    @total_price DECIMAL(10, 2) OUTPUT
AS
BEGIN
    DECLARE @item_price DECIMAL(10, 2);
    SELECT @item_price = price
    FROM Inventory
    WHERE supply_id = @id;
    SET @total_price = @item_price * @quantity;
    SELECT @total_price AS 'Total Price';
END;
        



-- the LogActivityDuration stored procedure
--(3-10)
go
CREATE PROCEDURE LogActivityDuration
    @room_id INT,
    @device_id INT,
    @user_id INT,
    @date DATETIME,
    @duration VARCHAR(50)
AS
BEGIN
    UPDATE Log
    SET duration = @duration
    WHERE room_id = @room_id
        AND device_id = @device_id
        AND user_id = @user_id
        AND date = @date;
END;


--  the TabletConsumption stored procedure
--(3-11) batool --
go
CREATE PROCEDURE TabletConsumption
    @consumption INT
AS
BEGIN
   
    UPDATE Consumption
    SET consumption = @consumption
    WHERE device_id IN (SELECT device_id FROM Device WHERE type = 'tablet');
END;

---3-12 batool ---
go
CREATE PROCEDURE MakePreferencesRoomTemp
@user_id INT,
@category VARCHAR(20),
@preferences_number INT
AS
BEGIN
DECLARE @U_age INT
SELECT @U_age = age
FROM Users
WHERE id = @user_id

IF @U_age>40
INSERT INTO Preferences VALUES (@user_id, @category, @preferences_number, 'Set room temperature to 30')
END


--the ViewMyLogEntry stored procedure
--(3-13) batool --
go
CREATE PROCEDURE ViewMyLogEntry
    @user_id INT
AS
BEGIN
    SELECT *
    FROM Log
    WHERE user_id = @user_id;
END;


-- the UpdateLogEntry stored procedure
--(3-14) batool --
go
CREATE PROCEDURE UpdateLogEntry
    @user_id INT,
    @room_id INT,
    @device_id INT,
    @activity VARCHAR(30)
AS
BEGIN
    UPDATE Log
    SET activity = @activity
    WHERE user_id = @user_id
        AND room_id = @room_id
        AND device_id = @device_id;
END;



-- the ViewRoom stored procedure
--(3-15) batool --
go
CREATE PROCEDURE ViewRoom
AS
BEGIN
    SELECT *
    FROM Room
    WHERE status = 'empty';
END;


-- the ViewMeeting stored procedure
--(3-16) batool --
go
CREATE PROCEDURE ViewMeeting
    @room_id INT,
    @user_id INT
AS
BEGIN
    SELECT
        A.activity_id,
        A.room_id,
        A.activity_name,
        U.user_name
    FROM
        Activity A
    JOIN
        Users U ON A.user_id = U.user_id
    WHERE
        (@room_id IS NULL OR A.room_id = @room_id)
        AND A.user_id = @user_id;
END;


-------------------------------------------------------------------------------------------------------------------------------------------


/*3-17 aya_________________________________________________________________________*/
go
CREATE PROCEDURE AdminAddTask
@user_id INT , @creator INT ,@name VARCHAR(30), @category VARCHAR(20), @priority INT,@status VARCHAR(20),
@reminder DATETIME , @deadline DATETIME , @other_user VARCHAR(20)
AS
BEGIN

DECLARE @t_id INT

INSERT INTO TASK (name, due_date, category, creator, status, reminder_date, priority)
VALUES (@name, @deadline, @category, @creator, @status, @reminder,@priority)
SET @t_id = SCOPE_IDENTITY();
INSERT INTO Assigned_to VALUES (@user_id, @t_id, @other_user)
END



/*3-18 aya_________________________________________________________________________*/
go
CREATE PROCEDURE AddGuest
@email varchar(30),
@first_name varchar(10),
@address varchar (30),
@password varchar(30),
@guest_of int,
@room_id int,
@number_of_allowed_guests INT OUTPUT
AS 
BEGIN

IF (EXISTS (SELECT email FROM Users WHERE @email = email))
BEGIN
PRINT 'This guest is already in the System!'
END

ELSE
BEGIN
/*I want to check if the admin has exceeded the number of guests allowed*/
DECLARE @sum INT

SELECT @sum = COUNT(*)
FROM Guest G INNER JOIN Admin A ON A.admin_id = G.guest_of
WHERE A.admin_id = @guest_of

DECLARE @guest_allowed INT --issue
SELECT @guest_allowed = no_of_guests_allowed
FROM Admin
WHERE admin_id = @guest_of

IF @sum >= @guest_allowed
BEGIN
PRINT 'This admin has reached the limit of guests allowed!!'
END

ELSE
BEGIN
DECLARE @G_id INT
INSERT INTO Users (f_name, password, email, room)
VALUES (@first_name, @password, @email, @room_id)
SET @G_id = SCOPE_IDENTITY();

INSERT INTO GUEST (guest_id, guest_of, address) --issue
VALUES (@G_id, @guest_of, @address)

SELECT @number_of_allowed_guests = no_of_guests_allowed
FROM Admin
WHERE @guest_of = admin_id

END
END
END

/*DECLARE @numofGuestsAllowed INT
EXEC AddGuest 'layla.N@gmail.com', 'layla', '123moonst', 'thislaylaisbeautiful', 1, 1, @numofGuestsAllowed OUTPUT
PRINT @numofGuestsAllowed*/


/*3-19 aya _________________________________________________________________________*/

go

CREATE PROCEDURE AssignTask
@user_id INT, 
@task_id INT, 
@creator_id INT
AS 
BEGIN 


INSERT INTO Assigned_to VALUES (@creator_id, @task_id, @user_id) --issue

END




/*3-20 aya_________________________________________________________________________*/


go
CREATE PROCEDURE DeleteMsg
AS
BEGIN

DECLARE @lastmsg INT

SELECT @lastmsg = MAX(message_id)
FROM Communication

DELETE FROM Communication
WHERE message_id = @lastmsg

/*DELETE FROM Communiaction WHERE message_id= (SELECT MAX(message_id) FROM Communication) ??*/

END



/*3-21  aya Update the travel itnerary for a specifc trip_______________________________________________________________________*/

go
CREATE PROCEDURE AddItinerary
@trip_no int,
@flight_num varchar(30),
@flight_date datetime,
@destination varchar(40)

AS
BEGIN

IF(NOT EXISTS (SELECT trip_no FROM Travel WHERE trip_no = @trip_no))
BEGIN
PRINT 'The trip you are trying update does not exist, please check the trip_id!!'
END

ELSE
BEGIN
UPDATE Travel
SET outgoing_flight_num = @flight_num, outgoing_flight_date = @flight_date, destination = @destination
WHERE trip_no = @trip_no
END

END



/*3-22 aya________________________________________________________________________*/
go
CREATE PROCEDURE ChangeFlight

AS
BEGIN

UPDATE Travel
SET outgoing_flight_date = DATEADD(YEAR, 1, outgoing_flight_date)
WHERE DATEPART(yyyy, outgoing_flight_date) = YEAR(GETDATE())

UPDATE Travel
SET ingoing_flight_date = DATEADD(YEAR, 1, ingoing_flight_date)
WHERE DATEPART(yyyy, ingoing_flight_date) = YEAR(GETDATE())

END




/*3-23 aya Alter the incoming flights of a pre-existing trip_________________________________*/
 go
CREATE PROCEDURE UpdateFlight
@date datetime,
@trip_no INT, 
@destination varchar(15)
AS
BEGIN

IF (NOT EXISTS (SELECT trip_no FROM Travel WHERE trip_no = @trip_no)) --issue
BEGIN
PRINT 'The trip you are trying to update does not exist' --issue?
END

ELSE
BEGIN
UPDATE Travel
SET ingoing_flight_date = @date, destination = @destination
WHERE trip_no = @trip_no
END

END




/*3-24 aya_____________________________________________________________________________________________________________*/

go
CREATE PROCEDURE AddDevice
@device_id int, 
@status varchar(20), 
@battery int,
@location int, 
@type varchar(20)
AS
BEGIN

IF (EXISTS(SELECT * FROM Device WHERE device_id = @device_id))
BEGIN
PRINT 'This device is already in the system!'
END

ELSE
BEGIN
INSERT INTO Device VALUES (@device_id, @location, @type, @status, @battery)
END

END





/*3-25 aya _____________________________________________________________________________________________________________*/
go
CREATE PROCEDURE OutOfBattery

AS
BEGIN

SELECT D.device_id, R.room_id, R.floor
FROM Device D
INNER JOIN Room R on D.room = R.room_id
WHERE D.battery_status = 0

END

/*EXEC OutOfBattery the output would be the result of the query*/


/*3-26: assumed that charging is a status, just like dead, idle, in use, etc______________________________________________________*/
GO
CREATE PROCEDURE Charging

AS
BEGIN

UPDATE Device
SET status = 'Charging'
WHERE battery_status = 0

END



/*3-27 aya_________________________________________________________________________________________________________________________*/
go
CREATE PROCEDURE GuestsAllowed
@admin_id int,
@number_of_guests int
AS 
BEGIN
UPDATE Admin
SET no_of_guests_allowed = @number_of_guests
WHERE admin_id = @admin_id

END



/*3-28 aya_________________________________________________________________________________________________________________________*/
go 
CREATE PROCEDURE Penalize
@Penalty_amount INT

AS
BEGIN

UPDATE FINANCE
SET penalty = @Penalty_amount
WHERE deadline < GETDATE()

END




/*3-29 aya___________________________________________________________________________________________________________________________*/
go
CREATE PROCEDURE GuestNumber
@admin_id INT,
@number INT OUTPUT
AS
BEGIN
SELECT @number = COUNT(guest_of)
FROM GUEST
WHERE guest_of = @admin_id
END



/*3-30 aya___________________________________________________________________________________________________________________________*/
go
CREATE PROCEDURE Youngest
/*@youngestUser INT OUTPUT*/

AS
BEGIN

DECLARE @young INT /*to store the smallest age available */

SELECT @young = MIN(age)
FROM Users

SELECT TOP 1 * /*output is the result of this query*/
FROM Users
WHERE age = @young
ORDER BY age

END



/*3-31 aya___________________________________________________________________________________________________________________________*/
go
CREATE PROCEDURE AveragePayment
@amount decimal(10,2)

AS
BEGIN

SELECT U.f_name + ' ' + U.l_name AS 'Name'
FROM Users U
INNER JOIN Admin A ON U.id = A.admin_id
WHERE A.salary > @amount --issue

END




/*3-32 aya___________________________________________________________________________________________________________________________*/
go
CREATE PROCEDURE Purchase
@sum DECIMAL(10,2) OUTPUT
AS
BEGIN

SELECT @sum = SUM(price)
FROM INVENTORY
WHERE quantity = 0;

END
/*DECLARE @moneyNeeded DECIMAL(10,2)
EXEC Purchase @moneyNeeded OUTPUT
PRINT @moneyNeeded*/


/*3-33 aya___________________________________________________________________________________________________________________________*/
go 
CREATE PROCEDURE NeedCharge

AS
BEGIN

SELECT d1.device_id, d2.device_id, d1.room 
FROM Device d1
INNER JOIN Device d2 ON d1.room = d2.room 
WHERE d1.device_id <> d2.device_id AND d1.battery_status = 0 AND d2.battery_status = 0


END




/*3-34 aya_______________________________________________________________________________________________________________________________*/
go
CREATE PROCEDURE Admins

AS
BEGIN


SELECT U.f_name + ' ' + U.l_name AS 'Name'
FROM Users U
INNER JOIN Admin A ON a.admin_id = U.id 
WHERE A.admin_id IN (SELECT A1.admin_id
                     FROM Admin A1 INNER JOIN Guest G on A1.admin_id = G.Guest_of 
                     GROUP BY A1.admin_id --issue
                     HAVING COUNT(A1.admin_id) > 2)

END

