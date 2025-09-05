clear
cap log close

cd "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"

local race_controls "black nam asian other"
local fam_controls = "onedeg twohs onehs nonehs"

local dir1 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"
local dir2 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/output"
set scheme stsj


foreach i in me_bw_cps tx_bw_cps ga_bw_cps{
	cd "`dir1'"
	use "`i'.dta", replace
	cd "`dir2'"
	
	areg hsgrad i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict `i'_hsgrad_trend, dresid
	la var `i'_hsgrad_trend "Detrended High School Graduation Rate"
	
	eventdd `i'_hsgrad_trend i.female `race_controls' `fam_controls' [aw=perwt], method(hdfe, absorb(statefip)) timevar(year_to_treat2) graph_op(ylabel(-0.04(0.02)0.10) xtitle(Year Relative to 2017 State Policy Enactments) legend(off))
	gr export `i'_dd_hsgrad.png, replace as(png)
	
	areg collenr i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict `i'_collenr_trend, dresid
	la var `i'_collenr_trend "Detrended College Enrollment Rate"
	
	eventdd `i'_collenr_trend i.female `race_controls' `fam_controls' [aw=perwt], method(hdfe, absorb(statefip)) timevar(year_to_treat2) graph_op(ylabel(-0.10(0.02)0.10) xtitle(Year Relative to 2017 State Policy Enactments) legend(off))
	gr export `i'_dd_collenr.png, replace as(png)
	
	
	areg dropout i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict `i'_dropout_trend, dresid
	la var `i'_dropout_trend "Detrended High School Dropout Rate"
	
	
	eventdd `i'_dropout_trend i.female `race_controls' `fam_controls' [aw=perwt], method(hdfe, absorb(statefip)) timevar(year_to_treat2) graph_op(ylabel(-0.06(0.02)0.06) xtitle(Year Relative to 2017 State Policy Enactments) legend(off))
	gr export `i'_dd_dropout.png, replace as(png)
	
}

foreach i in me_bw_cps tx_bw_cps ga_bw_cps{
	cd "`dir1'"
	use "`i'.dta", replace
	cd "`dir2'"
	
	foreach a in hsgrad collenr dropout{
		
		areg `a' i.female i.treatment##i.year if year<=2016 [aw=perwt], absorb(statefip)
		predict `i'_`a'_trend1, dresid
		areg `i'_`a'_trend treat_x_evyr* i.female [aw=perwt], absorb(statefip)
		outreg2 using `i'_`a'_es.tex, label replace keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0) addtext(Race Controls,no, Family Ed. Controls, no)
		
		areg `a' i.female i.treatment##i.year `race_controls' if year<=2016 [aw=perwt], absorb(statefip)
		predict `i'_`a'_trend2, dresid		
		areg `i'_`a'_trend2 treat_x_evyr* i.female `race_controls' [aw=perwt], absorb(statefip)
		outreg2 using `i'_`a'_es.tex, label append keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0) addtext(Race Controls,Yes, Family Ed. Controls, no)
		
		areg `a' i.female i.treatment##i.year `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
		predict `i'_`a'_trend3, dresid
		areg `i'_`a'_trend3 treat_x_evyr* i.female `fam_controls' [aw=perwt], absorb(statefip)
		outreg2 using `i'_`a'_es.tex, label append keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0) addtext(Race Controls,no, Family Ed. Controls, Yes)
		
		areg `a' i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
		predict `i'_`a'_trend4, dresid
		areg `i'_`a'_trend4 treat_x_evyr* i.female `race_controls' `fam_controls' [aw=perwt], absorb(statefip)
		outreg2 using `i'_`a'_es.tex, label append keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0) addtext(Race Controls,Yes, Family Ed. Controls, Yes)	
	}
}


