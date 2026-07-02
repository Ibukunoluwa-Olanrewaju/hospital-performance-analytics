select*
from fact_encounters_real ;

--------------------------------
select*
from fact_patients_real ;

----Objective Question 1(How have inpatient encounter volume and Average Length of Stay (ALOS) changed over time)

CREATE VIEW v_inpatient_encounter_volume_over_time AS (
    SELECT 
        encounter_id,
        encounter_class,
        DATE_TRUNC('month', start_date::timestamp)::date AS encounter_month
    FROM fact_encounters_real 
    WHERE start_date::timestamp >= (SELECT MAX(start_date::timestamp) FROM fact_encounters_real) - INTERVAL '24 months'
      AND encounter_class = 'inpatient'
);

------------------------------1b Average Length of Stay (ALOS) changed over time,


CREATE OR REPLACE VIEW v_inpatient_alos_over_time AS (
    SELECT
        DATE_TRUNC('month', stop_date::timestamp)::date AS discharge_month,
        SUM(EXTRACT(DAY FROM (stop_date::timestamp - start_date::timestamp))) AS total_inpatient_days,
        COUNT(encounter_id) AS total_inpatient_discharges,
        ROUND(
            SUM(EXTRACT(DAY FROM (stop_date::timestamp - start_date::timestamp)))::numeric /
            NULLIF(COUNT(encounter_id), 0), 2
        ) AS average_los
    FROM fact_encounters_real
    WHERE stop_date::timestamp >= (SELECT MAX(stop_date::timestamp) FROM fact_encounters_real) - INTERVAL '24 Months'
      AND encounter_class = 'inpatient'
      AND stop_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', stop_date::timestamp)::date
);


------------Objective Question 2
---Which departments are experiencing the highest inpatient workload?

CREATE OR REPLACE VIEW v_inpatient_department_volume AS (
    SELECT
        department,
        COUNT(encounter_id) AS departmental_volume, -- Fixed: Added an explicit name
        ROUND(
            SUM(EXTRACT(DAY FROM (stop_date::timestamp - start_date::timestamp)))::numeric / 
            NULLIF(COUNT(encounter_id), 0), 2
        ) AS average_los
    FROM fact_encounters_real
    WHERE encounter_class = 'inpatient'
      AND start_date::timestamp >= (SELECT MAX(start_date::timestamp)::date FROM fact_encounters_real) - INTERVAL '24 months'
    GROUP BY department -- Fixed: Corrected the spelling typo here
);



----Objective Question 3
--Which departments are associated with prolonged inpatient Length of Stay (LOS)?

CREATE VIEW v_inpatient_dept_los_summary AS (
    SELECT 
    
       department,
        -- FIX: Use timestamp subtraction for text columns to find the exact difference in days
        SUM(EXTRACT(DAY FROM (stop_date::timestamp - start_date::timestamp))) AS total_inpatient_days,
        COUNT(encounter_id) AS total_inpatient_discharges,
        -- FIX: Added NULLIF to prevent division-by-zero crashes
        ROUND(
            SUM(EXTRACT(DAY FROM (stop_date::timestamp - start_date::timestamp)))::numeric / 
            NULLIF(COUNT(encounter_id), 0), 2
        ) AS average_los
    FROM fact_encounters_real 
    -- FIX: Cast to timestamp here so the 24-month timeline maps accurately
    WHERE stop_date::timestamp >= (SELECT MAX(stop_date::timestamp) FROM fact_encounters_real) - INTERVAL '24 Months'
      AND encounter_class = 'inpatient'
      AND stop_date IS NOT NULL 
      group by department 
   
);


----Objective Question 4
--Which procedures are most frequently performed?

CREATE OR REPLACE VIEW v_procedure_volume AS (
    SELECT 
        fp.procedure_description,
        COUNT(fp.encounter_id) AS volume_of_procedure
    FROM fact_procedures_real fp
    JOIN fact_encounters_real fer 
        ON fp.encounter_id = fer.encounter_id
    WHERE fer.start_date::timestamp >= (SELECT MAX(start_date::timestamp) FROM fact_encounters_real) - INTERVAL '24 Months'
      AND fer.encounter_class = 'inpatient' 
    GROUP BY fp.procedure_description 
    ORDER BY volume_of_procedure DESC
);

----------------4B  Are certain procedures associated with prolonged Length of Stay (LOS) 
--or increased operational burden?


CREATE OR REPLACE VIEW v_procedure_operation_summary AS (
    SELECT 
        fpr.procedure_description,
        -- 1. True Total Bed Day Burden for this procedure group
        SUM(enc.true_days) AS total_days_burden,
        
        -- 2. True Average LOS calculated purely from the encounter table
        ROUND(SUM(enc.true_days)::numeric / NULLIF(COUNT(DISTINCT fpr.encounter_id), 0), 2) AS average_los
    FROM fact_procedures_real fpr
    JOIN (
        -- SUBQUERY: Isolates encounters to get clean, un-duplicated stay metrics
        SELECT 
            encounter_id,
            EXTRACT(DAY FROM (stop_date::timestamp - start_date::timestamp)) AS true_days
        FROM fact_encounters_real 
        WHERE encounter_class = 'inpatient'
          AND stop_date IS NOT NULL
          AND stop_date::timestamp >= (SELECT MAX(stop_date::timestamp) FROM fact_encounters_real) - INTERVAL '24 Months'
    ) enc ON fpr.encounter_id = enc.encounter_id
    GROUP BY fpr.procedure_description
    ORDER BY total_days_burden desc;
);


-----------------------------------------------------------------------------------------------------
-----------------------------------------------CLINICAL ANALYTICS QUESTIONS
--Objective 5
---What diagnoses are driving inpatient hospital activity?

create or replace view v_diagnosis_volume as(
SELECT 
    fer.diagnosis, 
    COUNT(fer.encounter_id) AS patient_volume_activity
FROM fact_encounters_real fer 
WHERE fer.encounter_class = 'inpatient'      
  AND fer.diagnosis IS NOT NULL              
  AND TRIM(fer.diagnosis) != ''         
  and fer.start_date::date >= (SELECT MAX(start_date::date) FROM fact_encounters_real) - INTERVAL '24 Months'
GROUP BY fer.diagnosis -- 
ORDER BY patient_volume_activity DESC   
);


------------------------------------------objective 6 
---Are specific diagnoses, specialties, or departments associated with higher inpatient burden or 
---prolonged Length of Stay (LOS)?

create or replace view v_inpatient_diagnosis_clinical_summary as (
select diagnosis,
Count(encounter_id) as discharged_patient_volume,
  ROUND( SUM(EXTRACT(DAY FROM (stop_date::timestamp - start_date::timestamp)))::numeric / 
            NULLIF(COUNT(encounter_id), 0), 2
        ) AS average_los,
SUM(fer.stop_date::date - fer.start_date::date) AS total_bed_days_burden
from fact_encounters_real fer 
where encounter_class='inpatient'
AND fer.stop_date IS NOT null
AND fer.diagnosis IS NOT NULL              
AND TRIM(fer.diagnosis) != ''
AND fer.stop_date::date >= (SELECT MAX(stop_date::date) FROM fact_encounters_real) - INTERVAL '24 Months'
group by diagnosis
order by discharged_patient_volume desc, average_los desc
);

----- for sub_specialties
create or replace view v_inpatient_subspecialty_clinical_summary as (
select subspecialty,
Count(encounter_id) as volume_burden,
Round (SUM(stop_date::date-start_date::date)::numeric/count(encounter_id),2) as average_los,
SUM(fer.stop_date::date - fer.start_date::date) AS total_bed_days_burden
from fact_encounters_real fer 
where encounter_class='inpatient'
AND fer.stop_date IS NOT null
AND fer.stop_date::date >= (SELECT MAX(stop_date::date) FROM fact_encounters_real) - INTERVAL '24 Months'
group by subspecialty
order by volume_burden desc, average_los desc
);

-----------------------------------------------------------OBJECTIVE 7 and 8  (READMISSION))        
----- they are asking for the general rate, then by diagnosis and by department! (anwers 7 & 8)
CREATE OR REPLACE VIEW v_flagged_readmissions AS (
WITH clean_inpatient_encounter AS (
    SELECT
        patient_id,
        encounter_id,
        encounter_class,
        start_date::date AS admission_date,
        stop_date::date AS discharge_date,
        diagnosis,
        department,
        subspecialty 
    FROM fact_encounters_real 
    WHERE encounter_class = 'inpatient'
      -- AND diagnosis IS NOT NULL <-- Removed this so it includes blanks and lowers your rate to normal levels
      AND stop_date IS NOT NULL
      AND stop_date::date >= (SELECT MAX(stop_date::date) FROM fact_encounters_real) - INTERVAL '24 Months'
),

patient_timeline AS (
    SELECT 
        patient_id,
        encounter_id,
        admission_date,
        discharge_date,
        diagnosis,
        department,
        subspecialty, 
        LEAD(admission_date) OVER(PARTITION BY patient_id ORDER BY admission_date) AS next_admission_date
        
    FROM clean_inpatient_encounter
),

flagged_readmissions AS (
    SELECT 
        patient_id,
        encounter_id,
        diagnosis,
        department, 
        subspecialty, 
        CASE 
            WHEN next_admission_date IS NOT NULL -- Safety check for the patient's absolute last visit
            AND (next_admission_date - discharge_date) <= 30 -- Within 30 days
            AND (next_admission_date - discharge_date) > 0 THEN 1 -- Same-day transfer guardrail
            ELSE 0 
        END AS is_readmission
    FROM patient_timeline 
)

SELECT 
    patient_id,
    encounter_id,
    diagnosis,
    department,
    subspecialty, 
    is_readmission
FROM flagged_readmissions
);

DROP VIEW IF EXISTS v_flagged_readmissions;

----------------------------------------------------------------------

---- for solving the diagnosis itself
SELECT 
    diagnosis,
    COUNT(encounter_id) AS total_inpatient_discharge,
    SUM(is_readmission) AS total_readmission_events,
    ROUND(
        SUM(is_readmission) * 100.0 / COUNT( encounter_id), 
        2
    ) AS readmission_rate
FROM v_flagged_readmissions  -- Calling your saved master view engine!
GROUP BY diagnosis
ORDER by total_inpatient_discharge desc, readmission_rate DESC;



------------for solving subspecailty itself

SELECT 
    subspecialty ,
    COUNT(DISTINCT encounter_id) AS total_inpatient_discharge,
    SUM(is_readmission) AS total_readmission_events,
    ROUND(
        SUM(is_readmission) * 100.0 / COUNT(DISTINCT encounter_id), 
        2
    ) AS readmission_rate
FROM v_flagged_readmissions  -- Calling the exact same master view engine!
GROUP BY subspecialty 
ORDER BY readmission_rate DESC;


-----FINANCE OBJECTIVES
------------------------------------------------------------------------------OBJECTIVE 9

--- How have hospital charges and payments changed over time?

CREATE VIEW v_financial_trend_monthly AS (
SELECT 
    date_trunc('month', fer.stop_date::date)::date AS payment_month,
    SUM(ffsr.total_charges) AS total_charges,
    SUM(ffsr.insurance_payments + ffsr.patient_payments) AS total_payments
FROM fact_encounters_real fer 
JOIN fact_financial_summary_real ffsr ON fer.encounter_id = ffsr.encounter_id 
WHERE fer.stop_date::date >= (SELECT MAX(stop_date::date) FROM fact_encounters_real) - INTERVAL '24 Months'
GROUP BY date_trunc('month', fer.stop_date::date)::date
);

----Objective 10
--- What is the distribution of insurance versus patient payments across the hospital system?
---System refers to department and subspecialty 

create or replace view v_payer_payment_distribution as (
select fer.department,
sum(ffsr.insurance_payments) as insurance_payment,
sum(ffsr.patient_payments) as patient_payments 
from fact_financial_summary_real ffsr 
join fact_encounters_real fer on fer.encounter_id=ffsr.encounter_id 
group by fer.department 
);  

create or replace view v_payer_payment_subspecialty_distribution as (
select fer.subspecialty,
sum(ffsr.insurance_payments) as insurance_payment,
sum(ffsr.patient_payments) as patient_payments 
from fact_financial_summary_real ffsr 
join fact_encounters_real fer on fer.encounter_id=ffsr.encounter_id 
group by fer.subspecialty 
);

---Objective 11 
---How does financial activity vary across departments with different operational workloads 
--and Length of Stay (LOS) patterns? 

create or replace view v_dept_financial_operational_metric as (
SELECT 
    fer.department,
    COUNT(fer.encounter_id) AS volume_burden,
    ROUND(SUM(fer.stop_date::date - fer.start_date::date)::numeric / COUNT(fer.encounter_id), 2) AS average_los,
    SUM(ffsr.insurance_payments + ffsr.patient_payments) AS total_net_revenue, 
    sum (ffsr.total_charges) AS gross_billed_amount,                  
    SUM(ffsr.total_charges) - SUM(ffsr.insurance_payments + ffsr.patient_payments) AS total_adjustments
FROM fact_encounters_real fer 
JOIN fact_financial_summary_real ffsr ON fer.encounter_id = ffsr.encounter_id 
WHERE fer.stop_date IS NOT NULL
  AND fer.encounter_class = 'inpatient'
  AND fer.stop_date::date >= (SELECT MAX(stop_date::date) FROM fact_encounters_real) - INTERVAL '24 Months'
GROUP BY fer.department
);

-----the end 