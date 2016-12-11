/**** Code to drop all the tables in case of a re-run *****/
/*
-- drop sequences first
drop sequence seq_task_id;
drop sequence seq_bank_emp_id ;
drop sequence  seq_Consultant_ID;
drop sequence Seq_loan_ID ;
drop sequence  seq_customer_id;

-- drop all the tables
drop table  Loan_status;
drop table Bank_Employee_Details;
drop table  consultant_details;
drop table  Loan_application;
drop table  customer_details;
*/

/* Customer Details Table:- This table stores the details of all the existing custoers and has an unique identifier allocated to each.  */

create table customer_details
(
Customer_ID number(5),
C_First_name varchar2(20) not null,
C_Last_name varchar2(20) not null,
acct_activation_date date default sysdate,          --Date on customer opened account
PAN_Number varchar2(10) not null,
customer_phone number(10),
customer_email varchar2(30),
Date_of_Birth date,
constraint pk_1 PRIMARY key(Customer_id),          --Customer_ID uniquely identifies a bank customer
constraint email check(customer_email like '%@%.%')--Email ID should contain a @ and .
);

--------------------------------------------------------------------------------------------------
/* Loan Application Table:- This table contains the list of loan applications and respective customer IDs, 
loan amount and other loan realted detsils  */

Create table Loan_application
(
Loan_ID number(5),
L_customer_id number(5) not null,
loan_type varchar2(20) not null,
Loan_amount number(10) not null,
Application_date date default sysdate,                --Date on which an applicant applies for loan
Final_status varchar2(20) default 'Pending',          --Initial stautus of loan is pending
constraint pk_2 Primary key(Loan_id),                 --Loan ID uniquely identifies an application
Constraint FK_1 Foreign key(L_customer_id) references customer_details(Customer_ID),--Reference to customer records in customer table
constraint check_f_status check(Final_status in ('Pending','Approved','Rejected')) --Status can be either Pending, Approved or Rejected
);



--------------------------------------------------------------------------------------------------
/* Consultant Details Table: - This tables has the list of all property and legal consultants assocaited with the bank's loan process. Both 
legal and property consultants can be identified using their IDs and consultant_type defined below */
create table consultant_details
(
Consultant_ID number(5),
Consultant_type varchar2(10) not null check(Consultant_type='Legal' or Consultant_type='Property'),--Classifies to be either Legal or Property
Consultant_name varchar2(20) not null,
Location varchar2(20) ,
Zipcode number(6) not null,
Max_amount number(15),              --Identifies the evaluation capacity of a customer
consultant_phone number(10),
consultant_email varchar2(30),
constraint pk_4 Primary key(Consultant_ID),       --Uniquely Identifies a consultant
constraint cons_email check(consultant_email like '%@%.%')-- Email contains @ and ..
);

--------------------------------------------------------------------------------------------------
/* Bank Employees Table: - This table consists of all the bank employee details including bank manager and zonal manager's. These are 
uniquely identified by their employee IDs and designations assigned to each */

Create table Bank_Employee_Details
(
B_Employee_ID number(5),
B_Last_name varchar2(20) not null,
B_First_name varchar2(20) not null,
Designation varchar2(20) not null check(Designation='Employee' or Designation='Manager'or Designation='Zonal Manager' ),--Employee/Manager/Zonal Manager
Branch_code varchar2(20) not null,
B_Employee_phone number(10),
B_Employee_Email varchar2(30),
constraint pk_3 Primary key(b_Employee_ID),               -- Employee Id  uniquely identifies a bank employee
constraint bank_email check(B_Employee_Email like '%@%.%')--  Email mandatorily contains @ and ..
);

--------------------------------------------------------------------------------------------------
/*Loan Status table: - This tables keeps a track of all the activites associated with every loan application process. 
To be more specific, each and every task of a particular loan application is recorded in this table with the corresponding 
task owner, start date, end date along with SLA(Service Level Agreement) status. */

Create table Loan_status
(
Task_ID number(6),
T_Loan_ID number(5),
T_Evaluator_ID number(5),
T_Manager_ID number(5),
T_Start_date date default sysdate,     --inserts date of insertion
T_end_date date,
SLA_date date default sysdate+15,      --default SLA date to be 15 days
Status varchar2(12) default 'Pending', --Initial status of any task is 'Pending
Remarks varchar2(50),
Constraint pk_5 primary key(Task_ID),
Constraint fk_2 foreign key(T_Loan_ID) references Loan_application(loan_id),-- References Loan application table
Constraint fk_3 foreign key(T_Evaluator_ID) references consultant_details(Consultant_ID),-- References Consultant table
Constraint fk_4 foreign key(T_Manager_ID) references Bank_Employee_Details(B_Employee_ID) --References Bank Employee table
);

--------------------------------------------------------------------------------------------------
--Sequence to generate customer_ID
CREATE SEQUENCE seq_customer_id
MINVALUE 10000
MAXVALUE 99999
START WITH 10000
INCREMENT BY 1;

---------------------------------------------------------------------------------------------------
--Sequence to genrate Loan_ID 
CREATE SEQUENCE Seq_loan_ID
MINVALUE 10000
MAXVALUE 99999
START WITH 10000
INCREMENT BY 1;

---------------------------------------------------------------------------------------------------
--Sequence to generate Consultant_ID
CREATE SEQUENCE seq_Consultant_ID
MINVALUE 10000
MAXVALUE 99999
START WITH 10000
INCREMENT BY 1;


-----------------------------------------------------------------------------------------------------
--Sequence to generate bank employee ID
CREATE SEQUENCE seq_bank_emp_id
MINVALUE 10000
MAXVALUE 99999
START WITH 10000
INCREMENT BY 1;
-----------------------------------------------------------------------------------------------------
--Sequence to generate Task ID
CREATE SEQUENCE seq_task_id
MINVALUE 100000
MAXVALUE 999999
START WITH 100000
INCREMENT BY 1;
-----------------------------------------------------------------------------------------------------

/**************************************************************************************************
INSERT DATA INTO THE TABLES
**************************************************************************************************/
------------------------------------------------------------------------------------------------------------
---Inserting sample values into Customer Table.
/* Interactive way to input customer details -
  insert into customer_details values(seq_customer_id.nextval,'&Customer_First_Name','&Customer_Last_Name',default,'&PAN_Number',
  '&Customer_Phone','&Customer_Email','&Date_Of_Birth'); */
  
insert into customer_details values(seq_customer_id.nextval,'James','Hayden','2-oct-2016','HHD23232','1234533323','james@gmail.com','23-jan-1988');
insert into customer_details values(seq_customer_id.nextval,'Michel','Ross','31-jul-2016','MRS3433','9864533323','michel.ross@gmail.com','21-jun-1978');
insert into customer_details values(seq_customer_id.nextval,'Harvey','Spector','15-oct-2016','HAS4584','7896598432','harvey.spector@gmail.com','23-aug-1972');
insert into customer_details values(seq_customer_id.nextval,'Louis','Litt','1-feb-2015','LOL8878','6749848567','louis.litt@gmail.com','16-jan-1975');
insert into customer_details values(seq_customer_id.nextval,'Donna','Paulsen','4-nov-2016','DOP4333','9693756930','donna.paulsen@gmail.com','09-sep-1988');
insert into customer_details values(seq_customer_id.nextval,'Jessica','Pearson','4-jul-2016','JPE6565','9784434431','jessipear@gmail.com','2-jan-1989');
commit;

--select * from customer_details
------------------------------------------------------------------------------------------------------------
---Inserting sample values into consultant details table
/*  insert into consultant_details 
    values(seq_Consultant_ID.nextval,'&Type_Legal_Property','&Consultant_Name','&Location','&ZipCode','&Max_Amount','&Consultant_Phone',
    '&Consultant_Email');*/

insert into consultant_details values(seq_Consultant_ID.nextval,'Legal','DBA Phiper','Hyderabad','500002',null,'3439856789','dbapiper@gmail.com');
insert into consultant_details values(seq_Consultant_ID.nextval,'Property','Dandon','Chennai','600782','100000','9079045609','dandon@yahoo.com');
insert into consultant_details values(seq_Consultant_ID.nextval,'Legal','Herbert Free hills','Bangalore','707231',null,'8454948949','freehills@hotmail.com');
insert into consultant_details values(seq_Consultant_ID.nextval,'Property','Paul Wilkins','Kolkatta','345221','200000','5840478092','wilkins@gmail.com');
insert into consultant_details values(seq_Consultant_ID.nextval,'Legal','Cooles','Mumbai','567454',null,'8799934120','cooles@yahoo.co.in');
insert into consultant_details values(seq_Consultant_ID.nextval,'Property','Baker Motts','Delhi','100234','600000','9848484840','bakermotts@gmail.com');
commit;

--select  * from consultant_details
------------------------------------------------------------------------------------------------------------
---Inserting sample values into Bank employee details
 /* insert into Bank_Employee_Details
    values(seq_bank_emp_id.nextval,'&Employee_Last_Name','&Employee_First_Name','&Designation', '&BranchCode','&Employee_Phone',
    '&Employee_Email'); */
    
  insert into Bank_Employee_Details values(seq_bank_emp_id.nextval,'Bing','Chandler','Manager','IB3231','9344445454','bing@idbi.com');
  insert into Bank_Employee_Details values(seq_bank_emp_id.nextval,'Geller','Ross','Manager','IB5434','9344445545','geller@idbi.com');
  insert into Bank_Employee_Details values(seq_bank_emp_id.nextval,'Heyden','Tim','Zonal Manager','IB4544','9344453454','tim@idbi.com');
  insert into Bank_Employee_Details values(seq_bank_emp_id.nextval,'Hunter','Monica','Zonal Manager','IB5433','9344445784','monica@idbi.com');
  insert into Bank_Employee_Details values(seq_bank_emp_id.nextval,'Williams','Jack','Manager','IB6453','9344445546','jack@idbi.com');
commit;
--select * from Bank_Employee_Details

-----------------------------------------------------------------------------------------
/* Inserting sample data  into Loan Application table */

Insert INTO LOAN_APPLICATION values(Seq_loan_ID.NEXTVAL,10002,'Business','900000','15-Oct-16','Approved');
Insert INTO LOAN_APPLICATION values(Seq_loan_ID.NEXTVAL,10000,'Home','1000000','23-Oct-16','Rejected');
Insert INTO LOAN_APPLICATION values(Seq_loan_ID.NEXTVAL,10004,'Education','500000','27-Oct-16','Rejected');
Insert INTO LOAN_APPLICATION values(Seq_loan_ID.NEXTVAL,10003,'Home','400000','1-Nov-16','Pending');
Insert INTO LOAN_APPLICATION values(Seq_loan_ID.NEXTVAL,10005,'Education','100000','4-Nov-16','Pending');
Insert INTO LOAN_APPLICATION values(Seq_loan_ID.NEXTVAL,10001,'Agriculture','50000','7-Nov-16','Pending');
Insert INTO LOAN_APPLICATION values(Seq_loan_ID.NEXTVAL,10002,'Home','500000','11-Nov-16','Pending');
commit;

--select * from loan_application
------------------------------------------------------------------------------------------- 
/*  Insert into loan status table */
insert into loan_status values(seq_task_id.nextval,'10000','','10000','15-Oct-16','15-Oct-16','16-Oct-16','Completed','Forwarded for legal opinion');
insert into loan_status  values(seq_task_id.nextval,'10000','10000','10000','15-Oct-16','19-Oct-16','18-Oct-16','Completed','Legal satisfactory');
insert into loan_status values(seq_task_id.nextval,'10000','','10000','19-Oct-16','20-Oct-16','21-Oct-16','Completed','Forwarded for property evaluation');
insert into loan_status values(seq_task_id.nextval,'10000','10001','10000','20-Oct-16','25-Oct-16','27-Oct-16','Completed','Estimated market value-340000');
insert into loan_status values(seq_task_id.nextval,'10001','','10001','23-Oct-16','24-Oct-16','24-Oct-16','Completed','Forwarded for legal opinion');
insert into loan_status values(seq_task_id.nextval,'10001','10002','10001','24-Oct-16','26-Oct-16','27-Oct-16','Completed','Legal partially satisfactory');
insert into loan_status values(seq_task_id.nextval,'10000','','10000','25-Oct-16','29-Oct-16','26-Oct-16','Completed','Need zonal manager consent');
insert into loan_status values(seq_task_id.nextval,'10001','','10001','26-Oct-16','29-Oct-16','28-Oct-16','Completed','Forwarded for property evaluation');
insert into loan_status values(seq_task_id.nextval,'10002','','10004','27-Oct-16','27-Oct-16','28-Oct-16','Completed','Forwarded for legal opinion');
insert into loan_status values(seq_task_id.nextval,'10002','10004','10004','27-Oct-16','28-Oct-16','30-Oct-16','Completed','Legal  satisfactory');
insert into loan_status values(seq_task_id.nextval,'10002','','10004','28-Oct-16','28-Oct-16','30-Oct-16','Completed','Forwarded for property evaluation');
insert into loan_status values(seq_task_id.nextval,'10002','10005','10004','28-Oct-16','03-Nov-16','05-Nov-16','Completed','Estimated market value-150000');
insert into loan_status values(seq_task_id.nextval,'10000','','10002','29-Oct-16','31-Oct-16','31-Oct-16','Completed','Satisfactory');
insert into loan_status values(seq_task_id.nextval,'10001','10003','10001','29-Oct-16','03-Nov-16','06-Nov-16','Completed','Estimated market value-600000');
insert into loan_status values(seq_task_id.nextval,'10000','','10000','31-Oct-16','31-Oct-16','01-Nov-16','Completed','Loan Approved');
insert into loan_status values(seq_task_id.nextval,'10003','','10000','01-Nov-16','01-Nov-16','02-Nov-16','Completed','Forwarded for legal opinion');
insert into loan_status values(seq_task_id.nextval,'10003','10000','10000','01-Nov-16','03-Nov-16','04-Nov-16','Completed','Legal  satisfactory');
insert into loan_status values(seq_task_id.nextval,'10001','','10001','03-Nov-16','03-Nov-16','04-Nov-16','Completed','Need zonal manager consent');
insert into loan_status values(seq_task_id.nextval,'10001','','10003','03-Nov-16','04-Nov-16','05-Nov-16','Completed','Rejected-Improper credit score and legal ');
insert into loan_status values(seq_task_id.nextval,'10002','','10004','03-Nov-16','05-Nov-16','04-Nov-16','Completed','Rejected-Low property value');
insert into loan_status values(seq_task_id.nextval,'10003','','10000','03-Nov-16','04-Nov-16','05-Nov-16','Completed','Forwarded for property evaluation');
insert into loan_status values(seq_task_id.nextval,'10001','','10001','04-Nov-16','04-Nov-16','05-Nov-16','Completed','Loan-Rejected');
insert into loan_status values(seq_task_id.nextval,'10003','10001','10000','04-Nov-16',null,'12-Nov-16','Pending','Property evaluation pending');
insert into loan_status values(seq_task_id.nextval,'10004','','10004','04-Nov-16','05-Nov-16','05-Nov-16','Completed','Forwarded for legal opinion');
insert into loan_status values(seq_task_id.nextval,'10004','10002','10004','05-Nov-16','09-Nov-16','08-Nov-16','Completed','Legal  satisfactory');
insert into loan_status values(seq_task_id.nextval,'10005','','10001','07-Nov-16','08-Nov-16','08-Nov-16','Completed','Forwarded for legal opinion');
insert into loan_status values(seq_task_id.nextval,'10005','10004','10001','08-Nov-16','09-Nov-16','11-Nov-16','Completed','Legal  satisfactory');
insert into loan_status values(seq_task_id.nextval,'10004','','10004','09-Nov-16','11-Nov-16','11-Nov-16','Completed','Forwarded for property evaluation');
insert into loan_status values(seq_task_id.nextval,'10005','','10001','09-Nov-16',null,'11-Nov-16','Pending','Pending manager review on legal');
insert into loan_status values(seq_task_id.nextval,'10004','10005','10004','11-Nov-16',null,'18-Nov-16','Pending','Property evaluation pending');
insert into loan_status values(seq_task_id.nextval,'10006','','10000','11-Nov-16','11-Nov-16','12-Nov-16','Completed','Forwarded for legal opinion');
insert into loan_status values(seq_task_id.nextval,'10006','10000','10000','11-Nov-16',null,'16-Nov-16','Pending','Legal opinion pending');
commit;

/********************************************************************************************************************************************
 Below shown is a typical step-by-step process explained with a sample use case which is to be followed in real time for 
approving a loan application with relavant explanations
*********************************************************************************************************************************************/

/* ---Bank Employee opens a new loan application file in the system
        insert into Loan_application
        values(Seq_loan_ID.nextval,'10000','Education','1000000',sysdate,default);--inserts values into loan application table  (loan_ID-10007)       
        
        insert into Loan_status
        values(seq_task_id.nextval,Seq_loan_ID.currval,null,'10000',sysdate,null,sysdate+2,default,'New Appllication');-- creates a work order for manager
        commit;

--select * from Loan_application
--select * from Loan_status
------------------------------------------------------------------------------------
--Bank manager addresses the loan application, if satisfactory ,he assigns a Legal consultant else he updates the status as rejected

    Update Loan_status set status='Completed',t_end_date=sysdate,Remarks='Forwarded for legal opinion' where task_id='100032';--(task_id-100032)
    
    insert into Loan_status values(seq_task_id.nextval,'10007','10000','10000',sysdate,null,sysdate+2,default,'');--task_id=100033
commit;


------------------------------------------------------------------------------------
-- Legal Consultant reviews the application documents and gives opinion.
 
Update Loan_status set status='Completed',t_end_date=sysdate,Remarks='Satisfactory' where task_id='100033';

 insert into Loan_status
        values(seq_task_id.nextval,'10007',null,'10000',sysdate,null,sysdate+2,default,'Bank Manager Review');--task_id=100034

commit;

------------------------------------------------------------------------------------
--Manager reviews legal opinion,if satisfactory assigns property evaluator else updates status as rejected
 
     Update Loan_status set status='Completed',t_end_date='02-aug-2016',Remarks='Forwarded for Property Evaluation' where task_id='100034';
     insert into Loan_status values(seq_task_id.nextval,'10007','10001','10000',sysdate,null,sysdate+10,default,'');
commit;

--select * from Loan_status
------------------------------------------------------------------------------------
--Property Consultant reviews the property documents and gives opinion
 
  Update Loan_status set status='Completed',t_end_date=sysdate,Remarks='Estimated market value-340000' where task_id='100035';
  
   insert into Loan_status
        values(seq_task_id.nextval,'10007',null,'10000',sysdate,null,sysdate+2,default,'Manger review');
  commit;


--select * from Loan_status
---------------------------------------------------------------------------------------
--Manager review the property consultants estimation, and approves the if satisfactory and loan amount is below 5Lac else forwards to Zonal Manager
 
     Update Loan_status set status='Completed',t_end_date=sysdate,Remarks='Forwarded to Zonal Manager' where task_id='100036';

 insert into Loan_status
        values(seq_task_id.nextval,'10007',null,'10003',sysdate,null,sysdate+3,default,'Zonal Manger review');
commit;


----------------------------------------------------------------------------------------
--Zonal manager reviews all documents and takes decision
 

     Update Loan_status set status='Completed',t_end_date=sysdate,Remarks='Satisfactory' where task_id='100037';
    
   insert into Loan_status
        values(seq_task_id.nextval,'10007',null,'10000',sysdate,null,sysdate+2,default,'manager final review');
     
commit;

--------------------------------------------------------------------------------------
--Bank Manager finally approves loan
 

     Update Loan_status set status='Completed',t_end_date=sysdate,Remarks='Approved' where task_id='100038';
    
     Update LOAN_APPLICATION set Final_status='Approved' where loan_id='10007';
     
commit;

*/


/* User defined function: Created a function to find the pending task's owner details*/
CREATE OR REPLACE function pending_status_fn(loanid IN number) return varchar2 is 
pendingby VARCHAR2(20);
    ev_id number;
    mg_id number;
    mg_name varchar2(20);
    ev_name varchar2(20);    
 BEGIN        
    select T_EVALUATOR_ID,T_MANAGER_ID into ev_id,mg_id from LOAN_STATUS a 
    where  TASK_ID=(select max(b.task_id) from LOAN_STATUS b where b.T_LOAN_ID=loanid ) ;
    
   IF  ev_id is null THEN 
      select designation into mg_name from BANK_EMPLOYEE_DETAILS where B_EMPLOYEE_ID=mg_id;
      return mg_name;  
   ELSE 
      select CONSULTANT_TYPE into ev_name from CONSULTANT_DETAILS where CONSULTANT_ID=ev_id;
      return ev_name;  
      
   END IF; 
   END;
/
