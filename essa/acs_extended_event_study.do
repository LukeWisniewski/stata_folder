clear
cap log close

cd "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"

local race_controls "black nam asian other"
local fam_controls = "onedeg twohs onehs nonehs"

local dir1 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"
local dir2 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/output"
set scheme stsj



foreach i in tx_bw_acs ga_bw_acs me_bw_acs{
	cd "`dir1'"
	use "`i'.dta", replace
	cd "`dir2'"
	
	
	areg hsgrad i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict `i'_hsgrad_trend, dresid
	la var `i'_hsgrad_trend "Detrended High School Graduation Rate"
	
	eventdd `i'_hsgrad_trend i.female `race_controls' `fam_controls' [aw=perwt], method(hdfe, absorb(statefip)) timevar(year_to_treat2) graph_op(ylabel(-0.04(0.02)0.10) xtitle(Year Relative to 2017 State Policy Enactments) xlabel(-8(2)6) legend(off))
	gr export `i'_dd_hsgrad_extended.png, replace as(png)
	
	areg collenr i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict `i'_collenr_trend, dresid
	la var `i'_collenr_trend "Detrended College Enrollment Rate"
	
	eventdd `i'_collenr_trend i.female `race_controls' `fam_controls' [aw=perwt], method(hdfe, absorb(statefip)) timevar(year_to_treat2) graph_op(ylabel(-0.10(0.02)0.10) xtitle(Year Relative to 2017 State Policy Enactments) xlabel(-8(2)6) legend(off))
	gr export `i'_dd_collenr_extended.png, replace as(png)
	
	
	areg dropout i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict `i'_dropout_trend, dresid
	la var `i'_dropout_trend "Detrended High School Dropout Rate"
	
	
	eventdd `i'_dropout_trend i.female `race_controls' `fam_controls' [aw=perwt], method(hdfe, absorb(statefip)) timevar(year_to_treat2) graph_op(ylabel(-0.06(0.02)0.06) xtitle(Year Relative to 2017 State Policy Enactments) xlabel(-8(2)6) legend(off))
	gr export `i'_dd_dropout_extended.png, replace as(png)
}
