clear

cap log close

cd "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"

use usa_00004.dta
keep if year>=2009

gen post1=year>=2015
gen post2=year>=2017

preserve

* Strengthening Output-based, strengthening input-based, comps weakening both (Check Arkansas)
keep if statefip==48 | statefip==40 | statefip==22 | statefip==35 | statefip==5
gen treatment = statefip==48


save "tx_bw_acs.dta", replace

restore
preserve
*Weakening output-based, strengthening input-based, comps doing nothing
keep if statefip==23 | statefip==33 | statefip==50
gen treatment = statefip==23


save "me_bw_acs.dta", replace

restore
preserve

* Maintaining output-based and input-based, comps only weakening output-based
keep if statefip==26 | statefip==39 | statefip==18 | statefip==55
gen treatment = statefip==26


save "mi_bw_acs.dta", replace


restore
preserve
* Weakening output-based and input-based, comps only weakening output-based
keep if statefip==13 | statefip==45 | statefip==1 | statefip==47 | statefip==12
gen treatment = statefip==13


save "ga_bw_acs.dta", replace

local ifcondition "if educd_mom!=.&educd_pop!=."

foreach i in tx_bw_acs me_bw_acs mi_bw_acs ga_bw_acs{
	use "`i'.dta", replace
	drop if age<17
	gen hsgrad = educd>61
	gen collenr = educd>64&school==2
	gen collgrad = educd>81
	gen dropout = school==1&educd<=61
	gen female = sex==2
	lab var female "Female"
	gen black = race==2
	lab var black "Black"
	gen nam = race==3
	lab var nam "Native American"
	gen asian = race==4|race==5|race==6
	lab var asian "Asian"
	gen other = race>6
	lab var other "Other Race/Ethnicity"
	
	
	gen twodeg = (educd_mom>81&educd_pop>81) `ifcondition'   // Parents with two college degrees
	lab var twodeg "Parents with Two Degrees"
	gen onedeg = (educd_mom>81|educd_pop>81)&twodeg==0 `ifcondition'   // Parents with one college degree
	lab var onedeg "Parents with One Degree"
	gen twohs = (educd_mom>61&educd_pop>61)&twodeg==0&onedeg==0 `ifcondition'    // Parents with two high school diplomas
	lab var twohs "Parents with Two High School Diplomas"
	gen onehs = (educd_mom>61|educd_pop>61)&twodeg==0&onedeg==0&twohs==0 `ifcondition'    // Parents with one high school diploma
	lab var onehs "Parents with One High School Diploma"
	gen nonehs = twodeg==0&onedeg==0&twohs==0&onehs==0 `ifcondition'   // Parents without high school diplomas
	lab var nonehs "Parents Both Without Diploma"
	
	gen year_to_treat1 = year-2015 if treatment==1
	gen year_to_treat2 = year-2017 if treatment==1
	
		foreach yr of numlist 0/2{
		gen evyr`yr' = year_to_treat2==`yr'
		gen treat_x_evyr`yr'=treatment*evyr`yr'
	}

	foreach yr of numlist 2/8{
		gen evyr_neg`yr' = year_to_treat2 == -`yr'
		gen treat_x_evyr_neg`yr' = treatment*evyr_neg`yr'
	}
	la var hsgrad "High School Graduation Rates"
	la var collenr "College Enrollment Rates"
	la var collgrad "College Graduation Rates"
	la var dropout "High School Dropout Rates"

	
	save "`i'.dta", replace
}

