/*
 * author: Itmam Alam
 * desc: raid5 system
 * date: 11.04.2025
*/

use raid5;
go

Drop Table if exists DiskArray;
go

Create Table DiskArray (
	BlockNo integer primary key,
	Disk1 tinyint,
	Disk2 tinyint,
	Disk3 tinyint,
	ParityDisk tinyint
)
go

Create or Alter Function PrintDiskArray()
returns table
as
return (Select char(Disk1) as Disk1, 
			   char(Disk2) as Disk2, 
			   char(Disk3) as Disk3 
		From DiskArray);
go

Create or Alter Procedure KillAndRecoverDisk
    @DiskToKill varchar(5)
as
begin
    if @DiskToKill = 'Disk1'
        update DiskArray set Disk1 = null;
    else if @DiskToKill = 'Disk2'
        update DiskArray set Disk2 = null;
    else if @DiskToKill = 'Disk3'
        update DiskArray set Disk3 = null;

    Select * From PrintDiskArray();

    if @DiskToKill = 'Disk1'
        UPDATE DiskArray set Disk1 = Disk2 ^ Disk3 ^ ParityDisk;
    else if @DiskToKill = 'Disk2'
        UPDATE DiskArray set Disk2 = Disk1 ^ Disk3 ^ ParityDisk;
    else if @DiskToKill = 'Disk3'
        UPDATE DiskArray set Disk3 = Disk1 ^ Disk2 ^ ParityDisk;

    Select * From PrintDiskArray();
end;
go

-- Befülen der Tabelle
Insert Into DiskArray(BlockNo, Disk1, Disk2, Disk3, ParityDisk) values
	(1, ascii('W'), ascii('F'), ascii('D'), null),
	(2, ascii('i'), ascii('i'), ascii('a'), null),
	(3, ascii('c'), ascii('r'), ascii('t'), null),
	(4, ascii('h'), ascii('m'), ascii('e'), null),
	(5, ascii('t'), ascii('e'), ascii('n'), null),
	(6, ascii('i'), ascii('n'), ascii(' '), null),
	(7, ascii('g'), ascii(' '), ascii(' '), null),
	(8, ascii('e'), ascii(' '), ascii(' '), null);
go

-- Befüllen von Parity Disk mit xor
Update DiskArray 
	Set ParityDisk = Disk1^Disk2^Disk3;
go

-- Print disk array
Select * From DiskArray;
go

-- Kill and recover disk1
exec dbo.KillAndRecoverDisk 'Disk1';

-- Kill and recover disk2
exec dbo.KillAndRecoverDisk 'Disk2';

-- Kill and recover disk3
exec dbo.KillAndRecoverDisk 'Disk3';
