use AirportDB;
go

create or alter function udfFindData (
    @startDate date,
    @endDate date
)
returns table
as
return (
    select 
        al.Airline_code,
        al.Airline_name,
        ac.Aircraft_code,
        f.Flight_number,
        fla.Leg_number,
        p.Passport_number,
        p.First_name,
        p.Minit,
        p.Last_name,
        pb.Air_ticket_number
    from Flight_leg_A fla
    join Flight f on fla.Flight_number = f.Flight_number
    join Aircraft ac on fla.Aircraft_code = ac.Aircraft_code
    join Airline al on f.Airline_code = al.Airline_code
    join Passenger_A p on fla.Leg_number = p.Leg_number
    join Passenger_B pb on p.Leg_number = pb.Leg_number 
                        and p.Air_ticket_number = pb.Air_ticket_number
    where fla.Date_of_flight between @startDate and @endDate
);
go

Select * From udfFindData('2018-12-01', '2018-12-31');
go

-- func two

CREATE or alter FUNCTION udfstatusInfo(@status VARCHAR(50), @date DATE)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        FLB.Status,
        FLB.Remark,
        FLA.Arrival_teminal_number,
        FLA.Staff_ID,
        FLA.Leg_number,
        FLA.Flight_number,
        PA.Passport_number,
        CONCAT(PA.First_name, ' ', PA.Last_name) AS Passenger_name,
        PC.Passenger_catogary,
        PR.Requirement AS Passenger_Requirement,
        FSD.Date AS Schedule_date
    FROM 
        Flight_leg_B FLB
    INNER JOIN 
        Flight_leg_A FLA ON FLB.Arrival_teminal_number = FLA.Arrival_teminal_number
    INNER JOIN 
        Flight F ON FLA.Flight_number = F.Flight_number
    INNER JOIN 
        Passenger_A PA ON FLA.Leg_number = PA.Leg_number
    LEFT JOIN 
        Passenger_catogary PC ON PA.Passport_number = PC.Passport_number
    LEFT JOIN 
        Passenger_requirements PR ON PA.Passport_number = PR.Passport_number
    INNER JOIN 
        Flight_shedule_date FSD ON F.Flight_number = FSD.Flight_number
    WHERE 
        FLB.Status = @status 
        AND FSD.Date = @date
);
go

SELECT * 
FROM udfstatusInfo('Canceled', '2018-12-21');
go 

-- stp 1
CREATE or alter PROCEDURE stp_passExpire(@PassportNumber CHAR(10))
AS
BEGIN
    DECLARE @ExpireDate DATE;
    DECLARE @CurrentDate DATE = GETDATE();

    SELECT @ExpireDate = Date_of_Expire
    FROM Passenger_A
    WHERE Passport_number = @PassportNumber;

    IF @ExpireDate IS NULL
    BEGIN
        PRINT 'Passports details not found for the provided Passport number.';
        RETURN;
    END

    IF @ExpireDate < @CurrentDate
    BEGIN
        PRINT 'Passenger''s Passport has been expired';
    END
    ELSE
    BEGIN
        PRINT 'This Passenger has a valid Passport';
    END
END;
go

EXEC stp_passExpire 'M100123458';
