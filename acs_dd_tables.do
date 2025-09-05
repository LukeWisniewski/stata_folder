clear
cap log close

cd "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"

local race_controls "black nam asian other"
local fam_controls = "onedeg twohs onehs nonehs"

local dir1 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"
local dir2 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/output"


foreach a in hsgrad collenr dropout{
	cd "`dir1'"
	use ga_bw_cps.dta, replace
	cd "`dir2'"
	
	areg `a' i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict ga_`a'_trend, dresid
	areg ga_`a'_trend treat_x_evyr* i.female `race_controls' `fam_controls' [aw=perwt], absorb(statefip)
	outreg2 using `a'_detrend_es.tex, label replace keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0)
	
	foreach i in me_bw_cps tx_bw_cps{
		cd "`dir1'"
		use "`i'.dta", replace
		cd "`dir2'"
		
	areg `a' i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict `i'_`a'_trend, dresid
	areg `i'_`a'_trend treat_x_evyr* i.female `race_controls' `fam_controls' [aw=perwt], absorb(statefip)
	outreg2 using `a'_detrend_es.tex, label append keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0)
	}
}


/*
foreach i in ga_bw_cps tx_bw_cps me_bw_cps{
	cd "`dir1'"
	use "`i'.dta", replace
	cd "`dir2'"
	foreach a in hsgrad dropout collenr{
		areg `a' i.female i.post2##i.treatment i.year [aw=perwt], absorb(statefip)
		outreg2 using `i'_`a'.tex, label replace keep(1.post2#1.treatment) addtext(Detrended?,no, Race Controls?, no, Fam. Ed. Controls?, no)
		
		areg `a' i.female i.treatment##i.year if year<=2016 [aw=perwt], absorb(statefip)
		predict `i'_`a'_trend1, dresid
		areg `i'_`a'_trend1 i.female i.post2##i.treatment i.year [aw=perwt], absorb(statefip)
		outreg2 using `i'_`a'.tex, label append keep(1.post2#1.treatment) addtext(Detrended?,yes, Race Controls?, no, Fam. Ed. Controls?, no)
		
		areg `a' i.female i.treatment##i.year `race_controls' if year<=2016 [aw=perwt], absorb(statefip)
		predict `i'_`a'_trend2, dresid
		areg `i'_`a'_trend2 i.female i.post2##i.treatment i.year `race_controls' [aw=perwt], absorb(statefip)
		outreg2 using `i'_`a'.tex, label append keep(1.post2#1.treatment) addtext(Detrended?,yes, Race Controls?, yes, Fam. Ed. Controls?, no)
		
		areg `a' i.female i.treatment##i.year `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
		predict `i'_`a'_trend3, dresid
		areg `i'_`a'_trend3 i.female i.post2##i.treatment i.year `fam_controls' [aw=perwt], absorb(statefip)
		outreg2 using `i'_`a'.tex, label append keep(1.post2#1.treatment) addtext(Detrended?,yes, Race Controls?, no, Fam. Ed. Controls?, yes)
		
		areg `a' i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
		predict `i'_`a'_trend4, dresid
		areg `i'_`a'_trend4 i.female i.post2##i.treatment i.year `race_controls' `fam_controls' [aw=perwt], absorb(statefip)
		outreg2 using `i'_`a'.tex, label append keep(1.post2#1.treatment) addtext(Detrended?,yes, Race Controls?, yes, Fam. Ed. Controls?, yes)
	}
}
*/



global keeplist_dd "lead* lag*"

foreach a in hsgrad collenr dropout{
	cd "`dir1'"
	use ga_bw_cps.dta, replace
	cd "`dir2'"
	
	areg `a' i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict ga_`a'_trend, dresid
	areg ga_`a'_trend i.female i.post2##i.treatment `race_controls' `fam_controls' [aw=perwt], absorb(statefip)
	outreg2 using `a'_detrend_dd.tex, label replace keep(1.post2#1.treatment)
	save temp_ga_`a'.dta, replace
	eventdd ga_`a'_trend i.female `race_controls' `fam_controls' [aw=perwt],method(hdfe, absorb(statefip)) timevar(year_to_treat2) keepdummies
	outreg2 using `a'_detrend_es.tex, label replace keep($keeplist_dd)
	
	foreach i in $keeplist_dd{
		drop `i'
	}
	
	
	foreach i in me_bw_cps tx_bw_cps{
		cd "`dir1'"
		use "`i'.dta", replace
		cd "`dir2'"
		
	areg `a' i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
	predict `i'_`a'_trend, dresid
	areg `i'_`a'_trend i.female i.post2##i.treatment `race_controls' `fam_controls' [aw=perwt], absorb(statefip)
	outreg2 using `a'_detrend_dd.tex, label append keep(1.post2#1.treatment)
	save temp_`i'_`a'.dta, replace
	eventdd `i'_`a'_trend i.female `race_controls' `fam_controls' [aw=perwt], method(hdfe, absorb(statefip)) timevar(year_to_treat2) keepdummies
	outreg2 using `a'_detrend_es.tex, label append keep($keeplist_dd)
	
	foreach i in $keeplist_dd{
		drop `i'
	}
	}
}
*/
