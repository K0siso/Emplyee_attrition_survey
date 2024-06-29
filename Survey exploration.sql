								-- DATA EXPLORATION
-- CONTENTS
-- 1.  Employee Attrition Analysis
-- 2. Impact of Business Travel on Employee Satisfaction and Performance
-- 3. Department-wise Employee Analysis
-- 4. Influence of Demographic Factors on Employee Outcomes
-- 5. Predictive Analysis for Employee Retention


-- 1.0  EMPLOYEE ATTRITION ANALYSIS
	-- 1.1 What are the key factors contributing to employee attrition?
		-- Gender
    SELECT Gender, COUNT(*) Totalemployee,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as AttritionCount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/Count(*)*100 as AttritionRate
    FROM general_data
    GROUP BY Gender;			-- RESULT: Attrition rate; Male = 16.6%   Female = 15.3%

		-- Department
	SELECT Department, COUNT(*) Totalemployee,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as AttritionCount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/Count(*)*100 as AttritionRate
    FROM general_data
    GROUP BY Department;			-- RESULT: Attrition rate; Sales = 15.1%   Research&Department = 15.6%   Human Resources = 29.4%
    
		-- MaritalStatus
	SELECT MaritalStatus, COUNT(*) Totalemployee,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as AttritionCount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/Count(*)*100 as AttritionRate
    FROM general_data
    GROUP BY MaritalStatus;				-- RESULT: Single = 25.3%   Married = 12.5%   Divorced = 10.1%
    
	-- 1.2 What is the relationship between years at the company and attrition??
    SELECT Attrition, AVG(em.YearsAtCompany) AvgYearsAtCompany
    FROM general_data
    JOIN employee_metrics as em ON general_data.EmployeeID = em.EmployeeID
    GROUP BY Attrition;				-- RESULT:The avg employee attrition occurs after 5 years, while employees who do not leave stay for an average of 7 years.
    
    -- 1.3 How does job role and level influence attrition rates?
    SELECT JobRole, JobLevel, COUNT(*) Totalemployee,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as AttritionCount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*) as AttritionRate
    FROM general_data
    GROUP BY JobRole, JobLevel, Attrition;		-- RESULT: Job level 1&2 have the highest attrition rate, the rate drops as the level increase.
    
-- 2.0 IMPACT OF BUSINESS TRAVEL ON EMPLOYEE SATISFACTION AND PERFORMANCE
	-- 2.1 How does frequency of business travel correlate with employee attrition?
    SELECT BusinessTravel, COUNT(*) as Totalemployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as AttritionCount,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100 as AttritionRate
    FROM general_data
    GROUP BY BusinessTravel;				-- RESULT: Rare-travellers = 14.96% 	 Frequent = 24.73%	 Non-travel = 8.04%
    
    -- 2.2 What is the impact of business travel on employee monthly income and job performance?
		-- Monthly Income
        SELECT BusinessTravel, COUNT(*) as Totalemployee, AVG(MonthlyIncome) as Avg_MonthlyIncome
		FROM general_data
		GROUP BY BusinessTravel;				-- RESULT: Non-travellers = $73,342		Frequent = $62,320		Rare-travellers = $64,596
    
		-- Salary Hike
        SELECT BusinessTravel, COUNT(*) as Totalemployee, AVG(em.PercentSalaryHike) as AvgHike
        FROM general_data
        JOIN employee_metrics as em ON em.EmployeeID = general_data.EmployeeID
        GROUP BY BusinessTravel;			-- RESULT: Rare = 15.2%,	Frequent = 15.2%,	Non-tavel = 15.6%
    
    -- 2.3 Is there a significant difference in job satisfaction between employees who travel frequently and those who do not?
    SELECT BusinessTravel, COUNT(*) as Total_employee, esd.JobSatisfaction
    FROM general_data
    JOIN employee_survey_data as esd ON esd.EmployeeID = general_data.EmployeeID
    GROUP BY BusinessTravel, JobSatisfaction
    ORDER BY 1;					-- RESULT: There's no significant difference for the Highest satisfaction (4/4).
    
-- 3.0 DEPARTMENT-WISE EMPLOYEE ANALYSIS
	-- 3.1 How do different departments compare in terms of average monthly income and salary hikes?
		-- Monthly Income
        SELECT Department, AVG(MonthlyIncome) as Avg_Monthly_income
        FROM general_data
        GROUP BY Department;		-- RESULT: Sales = $61,382	Research&Dev = $67,223	Human Resources = $58,101
        
        -- Salary Hikes
        SELECT Department, AVG(em.PercentSalaryHike) as Avg_Salary_Hike
        FROM general_data
        JOIN employee_metrics em ON em.EmployeeID = general_data.EmployeeID
        GROUP BY Department;			-- RESULT: Sales = 15.1%	Research&Dev = 15.3%	Human Resources = 14.7%
        
	-- 3.2 How does employee distribution by education field vary across departments?
    SELECT Department, EducationField, COUNT(*) as Totalemployee
    FROM general_data
    GROUP BY Department, EducationField
    ORDER BY 1,2;			-- RESULT: There are more employees with Life Siences(LS) and Medical degree in Reasearch&Dev compared to others. LS is top
							-- Human Resource(HR) dept alone have employees with HR degree. Life sciences records highest employee too then Medical
                            -- Sales dept alone have employees with degree in Marketing. Employees with Marketing degree tops the list followed by LS
                            
	-- 3.3 What are the common metrics for employees leaving each department?
	SELECT Department, AVG(esd.JobSatisfaction) AS Avg_JobSatisfaction, 
		AVG(esd.WorkLifeBalance) AS Avg_WorkLifeBalance, 
        AVG(em.YearsSinceLastPromotion) AS AvgYears_SinceLastPromotion,
		COUNT(*) AS EmployeeCount,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as AttritionCount,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100 as AttritionRate
	FROM general_data
	JOIN employee_metrics em ON em.EmployeeID = general_data.EmployeeID
    JOIN employee_survey_data esd ON esd.EmployeeID = general_data.EmployeeID
	GROUP BY Department
	ORDER BY AttritionCount DESC;		-- RESULT: The metrics are approximately identical. No obvious marker
    
-- 4.0 INFLUENCE OF DEMOGRAPHIC FACTORS ON EMPLOYEE OUTCOMES
	-- 4.1 How does age influence employee attrition and job satisfaction?
		-- Age Group
		SELECT 
		CASE WHEN Age < 30 THEN '<30'
			WHEN Age BETWEEN 30 AND 40 THEN '30-40'
			WHEN Age BETWEEN 40 AND 50 THEN '40-50'
			ELSE '50+' 
		END AS AgeGroup, COUNT(*) AS TotalEmployees,
		SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS AttritionCount,
		SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS AttritionRate
	FROM general_data
	GROUP BY 
		CASE WHEN Age < 30 THEN '<30'
			WHEN Age BETWEEN 30 AND 40 THEN '30-40'
			WHEN Age BETWEEN 40 AND 50 THEN '40-50'
			ELSE '50+' 
		END;								-- RESULT: <30 = 27.7%	 30-40 = 13.9%	 40-50 = 10.5%	 50+ = 12.6%
    
		-- Job Satisfaction by AgeGroup
        SELECT
		CASE WHEN Age < 30 THEN "<30"
			WHEN Age BETWEEN 30 AND 40 THEN "30-40"
			WHEN Age BETWEEN 40 AND 50 THEN "40-50"
			ELSE "50+"
		END as AgeGroup, AVG(esd.JobSatisfaction) as Avg_Satisfaction
        FROM general_data
        JOIN employee_survey_data esd ON esd.EmployeeID = general_data.EmployeeID
        GROUP BY 
			CASE WHEN Age < 30 THEN "<30"
				WHEN Age BETWEEN 30 AND 40 THEN "30-40"
				WHEN Age BETWEEN 40 AND 50 THEN "40-50"
				ELSE "50+"
			END;				-- RESULT: AVG Job satisfaction across AgeGroup is approx. same		2.7, 2.7, 2.7, 2.8 respectively
            
	-- 4.2 Are there any gender disparities in terms of monthly income and job roles?
		SELECT Gender, AVG(MonthlyIncome) as AVG_MonthlyIncome
		FROM general_data
		GROUP BY Gender;						-- RESULT: Male = $65,324	Female = $64,669
	
		-- JobRole
		SELECT JobRole, Gender, COUNT(*) as TotalEmployees
		FROM general_data
		GROUP BY Gender, JobRole
		ORDER BY JobRole;			-- RESULT: Male employees are > the Female by 870. The Roles where both genders have a small disparities include;
									-- [FEMALE:MALE] Human resources 1:1.6, Manager 1:1.1, Sale rep 1:1.4, the disparities in others roles are more
                                
	-- 4.3 What is the impact of marital status on employee performance and attrition?
		-- Attrition
		SELECT MaritalStatus, COUNT(*) TotalEmployee,
		SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as AttritionCount,
		SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)/COUNT(*)*100 as AttritionRate
		FROM general_data
		GROUP BY MaritalStatus;				-- RESULT: Attrition Rate; Married = 12.5%	 Single 25.3%	 Divorced = 10.1%
    
		-- Performance
        SELECT MaritalStatus, AVG(em.PercentSalaryHike) Avg_PercentageSalaryHike
        FROM general_data
        JOIN employee_metrics em ON em.EmployeeID = general_data.EmployeeID
        GROUP BY MaritalStatus;				-- RESULT: Married = 15.1% 		Single = 15.3% 		Divorced = 15.2%
        
        
-- 5.0 PREDICTIVE ANALYSIS FOR EMPLOYEE RETENTION
	-- 5.1 What are the key predictive indicators of employee attrition?
    SELECT 
		Attrition,  COUNT(*) Employees,
        AVG(Age) as AvgAge, 
        AVG(JobSatisfaction) as AvgJobSatisfaction, 
		AVG(YearsAtCompany) as AvgYearsAtCompany,
		AVG(MonthlyIncome) as AvgMonthlyIncome, 
		AVG(TotalWorkingYears) as AvgTotalWorkingYears, 
		AVG(TrainingTimesLastYear) as AvgTrainingTimesLastYear,
		AVG(YearsSinceLastPromotion) as AvgYearsSinceLastPromotion, 
		AVG(PerformanceRating) as Avg_PerformanceRating,
        AVG(JobInvolvement) as Avg_JobInvolvement,
		AVG(YearsWithCurrManager) as AvgYearsWithCurrManager,
		AVG(WorkLifeBalance) as AvgWorkLifeBalance, 
		AVG(NumCompaniesWorked) as AvgNumComapniesWorked, 
		AVG(EnvironmentSatisfaction) as Avg_EnvironmentSatisfaction
	FROM general_data
	JOIN employee_metrics em ON em.EmployeeID = general_data.EmployeeID
	JOIN employee_survey_data esd ON esd.EmployeeID = general_data.EmployeeID
    JOIN manager_survey_data msd ON msd.EmployeeID = general_data.EmployeeID
	GROUP BY Attrition;							
								-- RESULT: Employees that left do have -on average- a lower marker for every recorded parameter except,
                                -- interestingly, in the managers performance rating which they have higher. What are the likely reasons?
                                -- # High performers have more opportunities, they are prone to burnout, lack of career advacement, etc


-- END