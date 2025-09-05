clear

cap log close

cd "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"

use usa_00003.dta

gen post1=year>=2015
gen post2=year>=2017

preserve

keep if statefip == 25 | statefip == 9
gen treatment = statefip==25
save ma_acs.dta, replace

restore
preserve

keep if statefip == 41| statefip == 6
gen treatment = statefip ==41
save or_acs.dta, replace

restore
preserve
keep if statefip == 42| statefip==34
gen treatment = statefip==42
save pa_acs.dta, replace


restore
preserve
keep if statefip == 51|statefip==37
gen treatment = statefip==37
save nc_acs.dta, replace


local ifcondition "if educd_mom!=.&educd_pop!=."

foreach i in ma or pa nc{
	use "`i'_acs.dta", replace
	drop if age<17
	gen hsgrad = educd>61
	gen collenr = educd>64
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
	gen onehs = (educd_mom>61|educd_pop>61)&twodeg==0&onedeg==0&twohs==0 `ifcondition'    // Parents with one high school diploma
	lab var onehs "Parents with One High School Diploma"
	gen nonehs = twodeg==0&onedeg==0&twohs==0&onehs==0 `ifcondition'   // Parents without high school diplomas
	lab var nonehs "Parents Both Without Diploma"
	
	gen year_to_treat1 = year-2015
	gen year_to_treat2 = year-2017

	
	save "`i'_acs.dta", replace
}
