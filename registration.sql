/*
* This is a test table for the registration module. We can rename or use a different one
* for more extensive tests later --EM
*/
drop table registration;
create table registration(username char(20), pass char(20), first char(20), last char(20), address varchar(30), phone int);
insert into registration values('blue', 'squirtle', 'ash', 'ketchum', '0 pallet town', '1234567890');
insert into registration values('red', 'charmander', 'ash', 'ketchum', '0 pallet town', '1234567890');
