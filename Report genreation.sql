/*
This file contains two queries supplimented by a user defined function. Below is a quick summary of these two queries -

1.Out of SLAs: When a bank manager is given the task of handling number of loans, he often gets lost and its hard for him to keep a track of it.
Hence we wrote a query which will help to look at the tasks which are running over time and he can quickly follow-up with the responsible 
person to get the loan application moving. Further applications of this query could be keeping a track of who all evalautors are always meet
their SLAs without a miss and accordingly they can be rewarded/penalized. 

2. Current Status: The major objective of the impovements we did was to improve the transparancy in the process and to have the loan applicant 
to know the status of his loan at any given time. This query is specifically designed for that purpose. It requires just the loan ID and 
will output the current status and remarks.
 
*/

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Query 1: Out of SLAs
-- Below query leverages the function defined above to fetch the current status of the loan application.
select T_loan_id "Loan ID",               --Loan Application ID
c.LOAN_TYPE "Loan Purpose",               --Loan Purpose
c.LOAN_AMOUNT "Loan Amount",              --Loan Amount 
c.APPLICATION_DATE "Application Date",    --Loan Application Date
trunc(a.SLA_DATE-sysdate) "Days post SLA",--Days past SLA
(case when (a.SLA_DATE-sysdate)>0 then 'Out of SLA' else 'In SLA' end) "SLA Status",--SLA Status In SLA or OUT of SLA
t_start_date "Task Start Date",           --Last task start date
SLA_Date "SLA Date",                      --Date by which a task is expected to complete
Status "Task Status",                     --Task Status
pending_status_fn(a.T_loan_id) " Task Owner",--Pending task owner details
Remarks,                                  --Remarks from the task ownner
c.FINAL_STATUS "Final Loan Status",       --Final Loan Status
c.L_CUSTOMER_ID,p.C_LAST_NAME,p.C_FIRST_NAME --Customer Details
from LOAN_STATUS a join loan_application c on (c.loan_id=a.t_loan_id)--Joins loan application table with Loan staus table using loan ID
join CUSTOMER_DETAILS p on(p.CUSTOMER_ID=c.L_CUSTOMER_ID)            --Joins customer details table with the Loan application table to fetch customer details
where  a.t_end_date is  null                                         --Fetches details of all pending tasks ie; tasks with end date
--and (a.SLA_DATE-sysdate)>0                                        --Filters all out of SLA cases
order by "Days post SLA" desc                                       --Orders all tasks that has slipped quiet a days ago
;                                      

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/* Query 2: Current Status **** STARTS *** */
define loan_id_tp=&Enter_Loan_ID.; 
/* Substitution Inputs. Sample Input use cases - 10000 (approved loan), 10006 (pendng loan application), 10002 (Rejected loan application) */
select 'Current Status:'||a.Status||' with '||pending_status_fn(a.T_loan_id)||' ; Remarks - '||Remarks as Current_Status
from LOAN_STATUS a join loan_application c on (c.loan_id=a.t_loan_id) --Joins
where  a.t_end_date is  null and a.t_loan_id=&loan_id_tp.
Union
select c.final_status||' ; Remarks - '||Remarks as Current_Status
from LOAN_STATUS a join loan_application c on (c.loan_id=a.t_loan_id and c.final_status<>'Pending')
where a.t_loan_id=&loan_id_tp.
and a.task_id=(select max(task_id) from LOAN_STATUS y where y.t_loan_id=a.t_loan_id);

