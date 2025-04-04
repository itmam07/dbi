use AirportDB;

INSERT INTO Airport VALUES('-LCY-00125','London City Airport','London','United Kingdom',1987);
INSERT INTO Airport VALUES('-NCL-00564','Newcastle Airport','Newcastle','United Kingdom',1965);
INSERT INTO Airport VALUES('-LPL-01245','John Lennon Airport','Liverpool','United Kingdom',1933);
INSERT INTO Airport VALUES('-LAX-03412','LA Airport','Los Angeles','United Kingdom',1928);
INSERT INTO Airport VALUES('-AUH-00178','Abu Dhabi Airport','Abu Dhabi','United Arab Emirates',1969);
INSERT INTO Airport VALUES('-DXB-00153','Dubai Airport','Dubai','United Arab Emirates',1990);
INSERT INTO Airport VALUES('-BKK-16430','Suvarnabhumi Airport','Suvarnabhumi','Thailand',1973);
INSERT INTO Airport VALUES('-DEL-12630','IndiraGandhi Airport','New Delhi','India',1930);
INSERT INTO Airport VALUES('-CMB-00012','Bandaranaike Airport','Katunayake','Sri Lanka',1971);
INSERT INTO Airport VALUES('-HRI-00184','Mattala Airport','Mattala','Sri Lanka',2013);
INSERT INTO Airport values('-MAX-00123','Maxican Airport','Sorento','Mexico',1992)


insert into Airline values(00603,'SriLanka Airlines','SL Government','Bandaranaike Airport,Katunayake, Sri Lanka.','feedback@srilankan.com','www.srilankan.com',27,'2',1988,'-CMB-00012')
insert into Airline values(00016,'United Airlines','United Holdings','233 S Wacker Dr, Chicago, IL','feedback@unitedairlines.com','www.united.com',758,'5',1931,'-AUH-00178')
insert into Airline values(00250,'Uzbekistan Airways','Uzbekistan Gov.t','51 Amir Temur Ave., Tashkent','uzairplus@uzairways.com','www.uzairways.com',31,'10',1992,'-AUH-00178')
insert into Airline values(00738,'Vietnam Airlines','Vietnam Governmnet','200 Long Bien Dist., Hanoi, Vietnam','lotusmiles@vietnamairlines.com ','www.vietnamairlines.com',87,'13',1956,'-BKK-16430')
insert into Airline values(00235,'Turkish Airlines','Turkey Wealth Fund','THY Genel Yonetim Binasi Ataturk Airport, Yesilkoy','turkeyairlines@feedback.com','www.turkishairlines.com',329,'20',1933,'-DEL-12630')
insert into Airline values(00618,'Singapore Airlines','Temasek Holdings','25 Airline Road Singapore 819829','feedback@singaporeair.com','www.singaporeair.com',117,'15',1947,'-LCY-00125')
insert into Airline values(00180,'Korean Air Airlines','Korea Airport Ltd.','9th floor,Korean Air Building South Korea','customersvc@koreanair.com','www.koreanair.com',174,'16',1962,'-LPL-01245')
insert into Airline values(00131,'Japan Airlines','Japan Airport Ltd.','Nomura Real Estate Bldg.,Shinagawa-ku, Tokyo','japanair@feedback.com','www.jal.co.jp',164,'25',1951,'-NCL-00564')
insert into Airline values(00297,'China Airlines','China Aviation Foun.','No. 1, Hangzhan S. Rd, Taoyuan City, 33758 ','chinaair@feedback.com','www.china-airlines.com',88,'34',1959,'-HRI-00184')
insert into Airline values(00001,'American Airlines','USA Airlines Group','4333 Amon Carter Blvd, Fort Worth, TX 76155','usaair@customercare.us','www.americanairlines.com',949,'48',1926,'-LAX-03412')
insert into Airline values(00023,'Mexical Airline','Mexican Aviation Grp','8961 Hansora Rd. Sorento Mexico','mexavaition@info.com','www.mexairlline.com',23,'43',1988,'-MAX-00123')

insert into Aircraft values('A0310','Airbus A310','Airbus',737,'AB838',00603)
insert into Aircraft values('G0159','Gulfstream Aerospace','Grumman',530,'gr525',00016)
insert into Aircraft values('A0311','Airbus A310','Airbus',700,'AB763',00250)
insert into Aircraft values('E0170','Embraer 170','Embraer',432,'em300',00738)
insert into Aircraft values('DC087','Douglas DC-8-72 pax','McDonelle Douglas',680,'md450',00235)
insert into Aircraft values('A0321','Airbus A310','Airbus',747,'AB838',618)
insert into Aircraft values('DC010','Douglas DC-10 pax','McDonelle Douglas',362,'md450',00618)
insert into Aircraft values('CL060','Canadair Challenger','Bombadier Inc.',620,'bi225',00180)
insert into Aircraft values('A0320','Airbus A310','Airbus',747,'AB763',00131)
insert into Aircraft values('AN026','Antonov AN-26','Antonov',550,'an520',00297)
insert into Aircraft values('BA011','Boeing 011-100 pax','Boeing',737,'Bo723',00001)
insert into Aircraft values('A0400','Airbus A310','Airbus',700,'AB600',00180)
insert into Aircraft values('B0732','Boeing 732-200 pax','Boeing',720,'Bo450',00250)
insert into Aircraft values('B0703','Boeing 707 Freighter','Boeing',450,'Bo490',00235)
insert into Aircraft values('A0300','Airbus A310','Airbus',722,'AB853',00016)


insert into Flight values('A1235','Arrival','02:35:00','11:25:00','02:00:00','Landing successfull','Take off successfull',603)
insert into Flight values('C7561','Arrival','04:21:00','13:56:00','17:25:00','Landing successfull','Take off successfull',00016)
insert into Flight values('B4375','Departure','10:00:00','23:15:00','13:15:00','Ridirected to Mattala International Airport','Take off successfull',250)
insert into Flight values('A7566','Arrival','02:05:00','19:05:00','21:50:00','Landing successfull','Take off successfull',738)
insert into Flight values('D1375','Arrival','15:10:00','04:40:00','13:10:00','Landing delayed due to extreme weather','Take off successfull',235)
insert into Flight values('X7543','Departure','02:20:00','02:00:00','00:20:00','Landing successfull','Take off successfull',618)
insert into Flight values('F4367','Departure','04:30:00','00:40:00','05:10:00','Landing successfull','Take off delayed',618)
insert into Flight values('R7334','Arrival','09:40:00','17:50:00','03:45:00','Successfully landed to runway 02','Take off successfull',180)
insert into Flight values('S2354','Departure','7:30:00','17:30:00','10:00:00','Landing successfull','Take off successfull',297)
insert into Flight values('A9877','Departure','10:20:00','16:10:00','01:30:00','Landing successfull','Take off canceled',001)
insert into Flight values('V8006','Departure','09:50:00','16:20:00','08:10:00','Landing delayed due to extreme weather','Take off successfull',001)
insert into Flight values('N3314','Arrival','01:30:00','17:00:00','15:30:00','Landing successfull','Take off delayed',297)
insert into Flight values('M1434','Departure','2:12:00','10:00:00','12:12:00','Landing successfull','Take off successfull',016)
insert into Flight values('G9880','Arrival','05:55:00','18:05:00','00:00:00','Landing delayed due to technical failure','Take off canceled',131)
insert into Flight values('H1256','Departure','03:20:00','06:25:00','10:55:00','Landing successfull','Take off successfull',016)



insert into Aircrew values ('cp012','Jason','M','Banner','1972-02-02','Male','Pilot','+95102482089','N001230013','2008-05-12','Fluent in English',16,00603)
insert into Aircrew values ('pa001','Mark','C','Bekham','1985-05-06','Male','Pilot Assistant','+96457895123','N001356002','2012-03-10','B.Sc in Aviation',12,00016)
insert into Aircrew values ('cp013','Peter','M','Sthatham','1975-12-03','Male','Captain','+12456235126','M123450639','2008-04-06','Fluent in English',12,738)
insert into Aircrew values ('pa002','Anne','B','Johansan','1981-08-04','Female','Pilot Assitant','+97150248089','V123458792','2016-01-10','Fluent in English',8,00603)
insert into Aircrew values ('cp014','Scralet','C','Tissera','1972-07-06','Female','Pilot','+11245987632','L123458034','2011-03-09','BSc Aeronautical Engineering',14,00001)
insert into Aircrew values ('pa003','Jarod','M','Polen','1986-10-11','Male','Pilot Assistant','+96612586420','M003154897','2008-11-12','Certificate in Private Pilot',16,00297)
insert into Aircrew values ('ah001','Saduni','M','Hemachandra','1987-11-10','Female','Air Hoster','+94774630528','N025896430','2014-07-06','Fluent in English',6,00131)
insert into Aircrew values ('ah002','Menaka','P','Siriwardhana','1985-06-03','Female','Air Hoster','+94770715248','N025864791','2016-05-06','Fluent in English',5,00738)
insert into Aircrew values ('ah003','Sasini','H','Hemachandra','1987-05-08','Female','Air Hoster','+947746536489','N025456321','2014-07-06','Fluent in English',7,00603)
insert into Aircrew values ('ah004','Sehansa','P','Thathsarani','1985-04-04','Female','Air Hoster','+94713629280','N124693015','2015-11-06','Fluent in English',4,00016)
insert into Aircrew values ('cp015','Jhona','P','Samuel','1974-10-30','Male','Pilot','+12443805126','M123803210','2013-10-02','B.Sc in Avation',12,00023)


insert into Flight_leg_A values ('dep0123456','2018-12-01','11:25:00','08:12:13','arl00012','dpr00001','A0300','A1235','cp012')
insert into Flight_leg_A values ('arl1597456','2018-12-02','01:36:00','05:16:00','arl12565','dpr01234','A0300','C7561','cp013')
insert into Flight_leg_A values ('arl1516556','2018-12-02','06:46:00','12:28:36','arl19665','dpr01334','A0311','B4375','pa001')
insert into Flight_leg_A values ('dpr1664556','2018-12-03','01:50:00','08:30:06','arl11465','dpr00034','A0311','B4375','pa001')
insert into Flight_leg_A values ('arl3462556','2018-12-03','11:15:00','15:49:36','arl10055','dpr10034','A0320','A7566','cp013')
insert into Flight_leg_A values ('dpr0056036','2018-12-04','03:15:00','11:22:15','arl05035','dpr10044','A0320','A7566','cp014')
insert into Flight_leg_A values ('arl1597526','2018-12-05','13:28:00','16:22:06','arl20015','dpr20334','AN026','X7543','pa003')
insert into Flight_leg_A values ('arl2645526','2018-12-06','08:04:00','14:32:06','arl30215','dpr23434','B0703','A9877','cp012')
insert into Flight_leg_A values ('dpr4325526','2018-12-11','04:45:00','12:52:06','arl30575','dpr24834','BA011','N3314','cp013')
insert into Flight_leg_A values ('dpr6545526','2018-12-15','06:45:00','11:58:06','arl95475','dpr24934','BA011','G9880','pa003')
insert into Flight_leg_A values ('arl1486720','2018-12-18','05:23:00','10:23:00','arl25498','dpr45621','AN026','A5403','cp012')
insert into Flight_leg_A values ('arl1403920','2018-12-30','07:23:00','14:23:00','arl05498','dpr08621','B0703','A1235','cp013')


insert into Flight_leg_B values ('arl19665','Check-in',NULL)
insert into Flight_leg_B values ('arl12565','On-air',NULL)
insert into Flight_leg_B values ('arl20015','Boarding',NULL)
insert into Flight_leg_B values ('arl30215','Delayed','Technical Problem')
insert into Flight_leg_B values ('arl10055','On-air',NULL)
insert into Flight_leg_B values ('arl00012','Check-in',NULL)
insert into Flight_leg_B values ('arl05035','Canceled','Due to the bad wether')
insert into Flight_leg_B values ('arl11465','On-air',NULL)
insert into Flight_leg_B values ('arl30575','Check-in',NULL)
insert into Flight_leg_B values ('arl95475','Delayed','Due to the bad whether')
insert into Flight_leg_B values ('arl25498','Check-in',null)


insert into Passenger_A values ('M100123456','Akash','M','Liyanaarachchi','Male','Sri Lankan','1998-02-21','2017-10-30','2025-10-30','arl1516556','sl001',null)
insert into Passenger_A values ('M100123457','Hasindu','H','Charith','Male','Sri Lankan','1997-05-06','2017-08-25','2025-05-06','arl1597456','sl002',null)
insert into Passenger_A values ('M100123458','Dinush','K','Karunarathne','Male','Sri Lankan','1996-05-12','2015-03-26','2022-03-26','arl1597526','sl003',null)
insert into Passenger_A values ('M100123459','John','C','Banner','Male','American','1988-06-07','2013-08-01','2022-05-01','arl2645526','usa01',null)
insert into Passenger_A values ('M100123460','Peter','B','Parker','Male','American','2015-05-20','2017-09-01','2025-05-01','arl2645526','usa02','M100123459')
insert into Passenger_A values ('M100123461','Anne','B','Carter','Female','Mexican','1990-02-17','2012-01-01','2019-01-01','arl3462556','max01',null)
insert into Passenger_A values ('M100123462','Anne','M','Johanson','Female','Canedian','1992-05-15','2014-01-01','2023-01-01','dep0123456','can01',null)
insert into Passenger_A values ('M100123463','Michelle','D','Wandaputt','Female','American','1988-03-19','2009-06-16','2019-06-16','dpr0056036','usa03',null)
insert into Passenger_A values ('M100123464','Sheron','V','Wandaputt','Male','American','2018-03-19','2018-08-16','2026-08-16','dpr0056036','usa04','M100123463')
insert into Passenger_A values ('M100123465','Renata','V','Kelaart','Female','Sri Lankan','1960-05-21','2017-08-16','2025-08-16','dpr1664556','usa05',null)
insert into Passenger_A values ('M100123155','Devon','H','Jhona','Male','Mexican','1976-04-22','2014-08-16','2019-01-14','dpr1664556','max01',null)


insert into Passenger_B values ('arl1516556','sl001','Ecomony','13:10:00','e001')
insert into Passenger_B values ('arl1597456','sl002','Ecomony','13:16:00','e002')
insert into Passenger_B values ('arl1597526','sl003','Ecomony','13:32:00','e003')
insert into Passenger_B values ('arl2645526','usa01','First Class','14:02:00','a001')
insert into Passenger_B values ('arl3462556','usa02','Bussiness Class','14:12:00','b001')
insert into Passenger_B values ('dep0123456','usa03','Bussiness Class','14:16:00','b002')
insert into Passenger_B values ('dpr0056036','usa04','First Class','14:25:00','a002')
insert into Passenger_B values ('dpr1664556','usa05','Economy','15:20:00','cp005')
insert into Passenger_B values ('dpr1664556','max01','Ecomony','15:01:00','e004')
insert into Passenger_B values ('dpr4325526','can01','Premium Ecomony','15:13:00','p001')
insert into Passenger_B values ('dpr6545526','usa05','Premium Ecomony','15:20:00','p002')


insert into Flight_leg_arrival values ('arl1516556','belt001')
insert into Flight_leg_arrival values ('arl1597456','belt002')
insert into Flight_leg_arrival values ('arl1597526','belt003')
insert into Flight_leg_arrival values ('arl2645526','belt004')
insert into Flight_leg_arrival values ('arl3462556','belt005')
insert into Flight_leg_arrival values ('dep0123456','belt006')
insert into Flight_leg_arrival values ('dpr0056036','belt007')
insert into Flight_leg_arrival values ('dpr1664556','belt008')
insert into Flight_leg_arrival values ('dpr4325526','belt008')
insert into Flight_leg_arrival values ('dpr6545526','belt010')


insert into Flight_leg_departure values('arl1516556','bor001','ga001')
insert into Flight_leg_departure values('arl1597456','bor002','ga001')
insert into Flight_leg_departure values('arl1597526','bor003','ga001')
insert into Flight_leg_departure values('arl2645526','bor004','ga002')
insert into Flight_leg_departure values('arl3462556','bor005','ga002')
insert into Flight_leg_departure values('dep0123456','bor006','ga004')
insert into Flight_leg_departure values('dpr0056036','bor007','ga004')
insert into Flight_leg_departure values('dpr1664556','bor008','ga005')
insert into Flight_leg_departure values('dpr4325526','bor009','ga003')
insert into Flight_leg_departure values('dpr6545526','bor010','ga003')


insert into Flight_shedule_date values('A1235','2018-12-21')
insert into Flight_shedule_date values('A7566','2018-12-21')
insert into Flight_shedule_date values('A9877','2018-12-22')
insert into Flight_shedule_date values('B4375','2018-12-22')
insert into Flight_shedule_date values('C7561','2018-12-22')
insert into Flight_shedule_date values('D1375','2018-12-22')
insert into Flight_shedule_date values('F4367','2018-12-21')
insert into Flight_shedule_date values('G9880','2018-12-21')
insert into Flight_shedule_date values('H1256','2018-12-21')
insert into Flight_shedule_date values('M1434','2018-12-21')


insert into Passenger_catogary values ('M100123456','Adult')
insert into Passenger_catogary values ('M100123457','Adult')
insert into Passenger_catogary values ('M100123458','Adult')
insert into Passenger_catogary values ('M100123459','Adult')
insert into Passenger_catogary values ('M100123460','Children')
insert into Passenger_catogary values ('M100123461','Adult')
insert into Passenger_catogary values ('M100123462','Adult')
insert into Passenger_catogary values ('M100123463','Adult')
insert into Passenger_catogary values ('M100123464','Infant')
insert into Passenger_catogary values ('M100123465','Adult')


insert into Passenger_requirements values('M100123456','Need mobility equipment')
insert into Passenger_requirements values('M100123459','Carry baby strollers')
insert into Passenger_requirements values('M100123458','Need personal assistant in hearing')
insert into Passenger_requirements values('M100123457','Need personal assistant in hearing')
insert into Passenger_requirements values('M100123460','Visually impaired')
insert into Passenger_requirements values('M100123461','Need mobility equipment')
insert into Passenger_requirements values('M100123462','Carry pets')
insert into Passenger_requirements values('M100123463','Carry pets')
insert into Passenger_requirements values('M100123464','Carry baby strollers')
insert into Passenger_requirements values('M100123465','Need wheel chair')


insert into Airline_contact_number values(00603,'+940941125685','+940012486203',null)
insert into Airline_contact_number values(00016,'+910331541556',null,null)
insert into Airline_contact_number values(00250,'+950568561123','+950143206532',null)
insert into Airline_contact_number values(00738,'+710123564231',null,null)
insert into Airline_contact_number values(00235,'+380314863321',null,null)
insert into Airline_contact_number values(00618,'+970186312312','+9712340653128','+971643098135')
insert into Airline_contact_number values(00180,'+940132821365',null,null)
insert into Airline_contact_number values(00131,'+150954681231','+150319889654',null)
insert into Airline_contact_number values(00297,'+970321481312',null,null)
insert into Airline_contact_number values(00001,'+780355654481','+786459320015',null)
