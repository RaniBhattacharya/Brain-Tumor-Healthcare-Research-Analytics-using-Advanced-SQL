USE mini_project;
SHOW TABLES;

SELECT * FROM brain_tumor_treatments;
SELECT * FROM brain_tumor_genomics;
SELECT * FROM brain_tumor_imaging;
SELECT * FROM brain_tumor_patients;
SELECT * FROM brain_tumor_trials;

-- LINK -----
-- brain_tumor_treatments -------- treatment_id (PK), patient_id (FK)
-- brain_tumor_genomics ----------- speciman_id (PK), patient_id (FK)
-- brain_tumor_imaging ------------ study_id (PK), patient_id (FK)
-- brain_tumor_patients ----------- patient_id (PK)
-- brain_tumor_trials ------------- trialrecord_id (PK), patient_id (FK)

-- DOMAIN: BRAIN TUMOUR HEALTHCARE & RESEARCH ANALYTICS QUERIES --

-- 1. FOR EACH TUMOR TYPE, RANK PATIENTS BY SURVIVAL_MONTHS
SELECT patient_id, tumor_type, survival_months, rank_patient
FROM (
    SELECT
        p.patient_id,
        p.tumor_type,
        t.survival_months,
        RANK() OVER (PARTITION BY p.tumor_type ORDER BY survival_months DESC) AS rank_patient
    FROM brain_tumor_patients p
    JOIN brain_tumor_treatments t
        ON p.patient_id = t.patient_id
) t;

-- 2. TOP 3 PATIENTS PER TUMOR TYPE USING DENSE_RANK
SELECT patient_id, tumor_type, survival_months
FROM (
    SELECT
        p.patient_id,
        p.tumor_type,
        t.survival_months,
        DENSE_RANK() OVER (PARTITION BY p.tumor_type ORDER BY t.survival_months) AS dense_rank_patient
    FROM brain_tumor_patients p
    JOIN brain_tumor_treatments t
        ON p.patient_id = t.patient_id
) temp
WHERE dense_rank_patient <= 3;

-- 3. -- 3. For each hospital, assign a sequential number to patients based on diagnosis_date using ROW_NUMBER().
SELECT
    patient_id,
    hospital,
    diagnosis_date,
    ROW_NUMBER() OVER (PARTITION BY hospital ORDER BY diagnosis_date) AS sequential_number
FROM brain_tumor_patients;

-- 4..Divide patients into quartiles (NTILE 4) based on radiomic_score and show which
-- quartile each patient falls into.
SELECT
    patient_id,
    radiomic_score,
    NTILE(4) OVER (ORDER BY radiomic_score DESC) AS quartiles
FROM brain_tumor_imaging;

-- 5. Compute the average survival_months per tumor type, but also show each patient’s survival alongside
-- that average using AVG() OVER (PARTITION BY ...).
SELECT patient_id, tumor_type, survival_months, average_survival_months
FROM (
    SELECT
        p.patient_id,
        p.tumor_type,
        t.survival_months,
        AVG(survival_months) OVER (PARTITION BY tumor_type) AS average_survival_months
    FROM brain_tumor_patients p
    JOIN brain_tumor_treatments t
        ON p.patient_id = t.patient_id
) t;

-- SECTION B – GROUP BY VS PARTITION BY

-- 6.Using GROUP BY, calculate the average tumor volume per tumor type.Then rewrite the query using AVG() 
-- OVER (PARTITION BY tumor_type) to retain patient-level rows. 
-- using group by
SELECT
    p.tumor_type,
    AVG(i.tumor_volume_cc) AS avg_tumor_volume
FROM brain_tumor_patients p
JOIN brain_tumor_imaging i
    ON p.patient_id = i.patient_id
GROUP BY p.tumor_type;

-- PARTITION BY
SELECT tumor_type, tumor_volume, avg_tumor_volume
FROM (
    SELECT
        p.tumor_type,
        i.tumor_volume_cc AS tumor_volume,
        AVG(i.tumor_volume_cc) OVER (PARTITION BY p.tumor_type) AS avg_tumor_volume
    FROM brain_tumor_patients p
    JOIN brain_tumor_imaging i
        ON p.patient_id = i.patient_id
) t;

-- 7. -- 7.	For each patient, display:
-- o	tumor_type
-- o	survival_months
-- o	maximum survival within the same tumor type (using window function)

SELECT tumor_type, survival_months, maximum_survival
FROM (
    SELECT
        p.tumor_type,
        t.survival_months,
        MAX(t.survival_months) OVER (PARTITION BY p.tumor_type) AS maximum_survival
    FROM brain_tumor_patients p
    JOIN brain_tumor_treatments t
        ON p.patient_id = t.patient_id
) t;

-- 8. 	Show the total number of patients per hospital using GROUP BY, and alongside each row show the overall
-- patient count using COUNT() OVER().

SELECT hospital, COUNT(*) AS total_patient
FROM brain_tumor_patients
GROUP BY hospital;

SELECT *,
    COUNT(*) OVER (PARTITION BY hospital) AS hospitals_total_pasents
FROM brain_tumor_patients;

-- SECTION C – JOINS + WINDOW FUNCTIONS

-- 9.  9.	Join patients, treatments, and genomics tables.
-- Rank patients within each tumor type by immune_biomarker_score.

SELECT patient_id, tumor_type, immune_biomarker_score, Rank_of_patient
FROM (
    SELECT
        t.patient_id,
        p.tumor_type,
        g.immune_biomarker_score,
        RANK() OVER (PARTITION BY p.tumor_type ORDER BY g.immune_biomarker_score) AS Rank_of_patient
    FROM brain_tumor_patients p
    JOIN brain_tumor_treatments t
        ON p.patient_id = t.patient_id
    JOIN brain_tumor_genomics g
        ON p.patient_id = g.patient_id
) t;

-- 10. 	Join patients and imaging tables.
-- For each tumor type, calculate the average radiomic_score and show each patient’s deviation from it.

SELECT
    p.tumor_type,
    i.radiomic_score,
    AVG(i.radiomic_score) OVER (PARTITION BY p.tumor_type) AS avg_radiomic_score,
    i.radiomic_score -
    AVG(i.radiomic_score) OVER (PARTITION BY p.tumor_type) AS deviation_score
FROM brain_tumor_patients p
JOIN brain_tumor_imaging i
    ON p.patient_id = i.patient_id;

-- 11. Using patients + treatments, find the latest treatment per patient using ROW_NUMBER().

SELECT patient_id, treatment_date, treatment_type, row_num
FROM (
    SELECT
        p.patient_id,
        t.end_date AS treatment_date,
        t.treatment_type,
        ROW_NUMBER() OVER (PARTITION BY p.patient_id ORDER BY t.end_date DESC) AS row_num
    FROM brain_tumor_patients p
    JOIN brain_tumor_treatments t
        ON p.patient_id = t.patient_id
) t
WHERE row_num = 1;

-- 12. Join patients + clinical_trials and rank patients by trial phase priority within each tumor type.
SELECT
    patient_id,
    tumor_type,
    trial_phase,
    DENSE_RANK() OVER (PARTITION BY tumor_type ORDER BY priority DESC) AS rank_of_patient
FROM (
    SELECT
        p.patient_id,
        p.tumor_type,
        t.trial_phase,
        CASE
            WHEN t.trial_phase = 'Phase I' THEN 1
            WHEN t.trial_phase = 'Phase II' THEN 2
            WHEN t.trial_phase = 'Phase III' THEN 3
            WHEN t.trial_phase = 'Phase IV' THEN 4
            ELSE 0
        END AS priority
    FROM brain_tumor_patients p
    JOIN brain_tumor_trials t
        ON p.patient_id = t.patient_id
) t;

-- Section D – Time-based & Research-oriented Analysis--
 
 
 -- 13.	Using JOINs, calculate the cumulative survival_months per tumor type ordered by diagnosis_date.
 
SELECT
    p.tumor_type,
    p.diagnosis_date,
    SUM(t.survival_months) OVER (PARTITION BY p.tumor_type ORDER BY p.diagnosis_date) AS cumulative_survival_months
FROM brain_tumor_patients p
JOIN brain_tumor_treatments t
    ON p.patient_id = t.patient_id;

-- 14. For each hospital, compute a running total of enrolled clinical trial patients over time.
SELECT
    hospital,
    SUM(exact_enroll) OVER (PARTITION BY hospital ORDER BY enroll_date) AS running_total_enrolled
FROM (
    SELECT
        p.hospital,
        t.enroll_date,
        CASE
            WHEN t.enrolled = 'TRUE' THEN 1
            ELSE 0
        END AS exact_enroll
    FROM brain_tumor_patients p
    JOIN brain_tumor_trials t
        ON p.patient_id = t.patient_id
) t;

-- 15. Compare average survival of patients enrolled in trials vs not enrolled, grouped by tumor type.
SELECT
    p.tumor_type,
    AVG(CASE WHEN t.enrolled = 'TRUE' THEN r.survival_months END) AS avg_survival_trial,
    AVG(CASE WHEN t.enrolled = 'FALSE' THEN r.survival_months END) AS avg_survival_nontrial
FROM brain_tumor_patients p
JOIN brain_tumor_trials t
    ON p.patient_id = t.patient_id
JOIN brain_tumor_treatments r
    ON p.patient_id = r.patient_id
GROUP BY p.tumor_type;

-- SECTION E –  Views & Reusable Research Insights--
-- 16.	Create a VIEW showing only Glioblastoma (GBM) patients who received Immunotherapy or Targeted Therapy,
--  including survival and biomarker details.
CREATE VIEW gbm_patient as 
select
p.tumor_type ,
t.treatment_type ,
t.survival_months,
g.immune_biomarker_score 
from brain_tumor_patients p
JOIN brain_tumor_genomics g
    ON p.patient_id = g.patient_id
JOIN brain_tumor_treatments t
    ON p.patient_id = t.patient_id
where p.tumor_type = 'Glioblastoma (GBM)' and t.treatment_type in ('Immunotherapy' , 'Targeted Therapy');
-- drop view gbm_patient;
select * from gbm_patient;

-- 17.	Replace the above VIEW to include radiomic_score and tumor volume from imaging data.

CREATE OR REPLACE VIEW gbm_patient AS
SELECT
    p.tumor_type,
    t.treatment_type,
    t.survival_months,
    g.immune_biomarker_score,
    i.radiomic_score,
    i.tumor_volume_cc
FROM brain_tumor_patients p
JOIN brain_tumor_genomics g
    ON p.patient_id = g.patient_id
JOIN brain_tumor_treatments t
    ON p.patient_id = t.patient_id
JOIN brain_tumor_imaging i
    ON p.patient_id = i.patient_id
WHERE p.tumor_type = 'Glioblastoma (GBM)'
  AND t.treatment_type IN ('Immunotherapy', 'Targeted Therapy');
  -- drop view gbm_patient;
select * from gbm_patient;

-- 18.	Drop the view once analysis is complete.
DROP VIEW gbm_patient;

-- Section F – Advanced Ranking & Decision Support--


 -- 19.	For each tumor type, identify the best performing treatment based on average survival using RANK().
SELECT
    tumor_type,
    treatment_type,
    RANK() OVER (PARTITION BY tumor_type ORDER BY avg_survival) AS rank_treatment,
    avg_survival
FROM (
    SELECT
        p.tumor_type,
        t.treatment_type,
        AVG(t.survival_months) AS avg_survival
    FROM brain_tumor_patients p
    JOIN brain_tumor_treatments t
        ON p.patient_id = t.patient_id
    GROUP BY p.tumor_type, t.treatment_type
) t;

-- 20.	Using JOINs across patients, genomics, treatments, classify patients into High / Medium / Low survival risk
-- groups using NTILE(3) based on survival_months.

SELECT
    patient_id,
    survival_months,
    survival_risk,
    bucket
FROM (
    SELECT
        patient_id,
        survival_months,
        bucket,
        CASE
            WHEN bucket = 1 THEN 'HIGH'
            WHEN bucket = 2 THEN 'MEDIUM'
            WHEN bucket = 3 THEN 'LOW'
        END AS survival_risk
    FROM (
        SELECT
            g.patient_id,
            t.survival_months,
            NTILE(3) OVER (ORDER BY t.survival_months DESC) AS bucket
        FROM brain_tumor_patients p
        JOIN brain_tumor_treatments t
            ON p.patient_id = t.patient_id
        JOIN brain_tumor_genomics g
            ON p.patient_id = g.patient_id
    ) t
) u;

