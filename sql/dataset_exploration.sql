--overview of every table's size first
SELECT table_id, row_count, size_bytes
FROM `physionet-data.mimiciv_3_1_hosp.__TABLES__`
ORDER BY row_count DESC;

--for diagnosis codes, see what's actually common
SELECT d.icd_code, dd.long_title, COUNT(DISTINCT d.subject_id) AS num_patients
FROM `physionet-data.mimiciv_3_1_hosp.diagnoses_icd` d
JOIN `physionet-data.mimiciv_3_1_hosp.d_icd_diagnoses` dd
  ON d.icd_code = dd.icd_code AND d.icd_version = dd.icd_version
WHERE d.icd_code LIKE 'I2%' OR d.icd_code LIKE 'I4%' OR d.icd_code LIKE 'I5%'
GROUP BY d.icd_code, dd.long_title
ORDER BY num_patients DESC
LIMIT 50;

--for labs, check which biomarkers actually have good coverage
SELECT d.label, COUNT(DISTINCT l.subject_id) AS num_patients, COUNT(*) AS num_measurements
FROM `physionet-data.mimiciv_3_1_hosp.labevents` l
JOIN `physionet-data.mimiciv_3_1_hosp.d_labitems` d
  ON l.itemid = d.itemid
WHERE d.label LIKE '%troponin%' OR d.label LIKE '%natriuretic%' OR d.label LIKE '%lactate%'
GROUP BY d.label
ORDER BY num_patients DESC;