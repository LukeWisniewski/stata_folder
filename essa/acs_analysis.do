clear
cap log close

cd "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"

local race_controls "black nam asian other"
local fam_controls = "onedeg twohs onehs nonehs"

/*
foreach i in tx_bw_cps me_bw_cps mi_bw_cps ga_bw_cps{
	use "`i'.dta", replace
	forval j = 1/2{
		foreach a in hsgrad collenr collgrad dropout{
			reg `a' i.post`j'##i.treatment i.year [aw=perwt], robust
			logit `a' i.post`j'##i.treatment i.year [pweight = perwt], robust
			
			reg `a' i.post`j'##i.treatment i.year i.female [aw=perwt], robust
			logit `a' i.post`j'##i.treatment i.year i.female [pweight=perwt], robust
			
			reg `a' i.post`j'##i.treatment i.year i.female `race_controls' [aw=perwt], robust
			logit `a' i.post`j'##i.treatment i.year i.female `race_controls' [pweight=perwt], robust
			
			reg `a' i.post`j'##i.treatment i.year i.female `fam_controls' [aw=perwt], robust
			logit `a' i.post`j'##i.treatment i.year i.female `fam_controls' [pweight=perwt], robust
			
			reg `a' i.post`j'##i.treatment i.year i.female `race_controls' `fam_controls' [aw=perwt], robust
			logit `a' i.post`j'##i.treatment i.year i.female `race_controls' `fam_controls' [pweight=perwt], robust
		}
	}
}
*/

local race_controls "black nam asian other"
local fam_controls = "onedeg twohs onehs nonehs"

/*
foreach i in tx_bw_cps me_bw_cps mi_bw_cps ga_bw_cps{
	use "`i'.dta", replace
	foreach a in hsgrad collenr collgrad dropout{
		eventdd `a' i.female i.statefip `race_controls' `fam_controls' [aw=perwt], method(ols, robust) timevar(year_to_treat2) graph_op(subtitle("`i' `a'") legend(off))
	}
}
*/

foreach i in tx_bw_cps mi_bw_cps ga_bw_cps me_bw_cps{
	use "`i'.dta", replace
	foreach yr of numlist 0/2{
		gen evyr`yr' = year_to_treat2==`yr'
		gen treat_x_evyr`yr'=treatment*evyr`yr'
	}

	foreach yr of numlist 2/8{
		gen evyr_neg`yr' = year_to_treat2 == -`yr'
		gen treat_x_evyr_neg`yr' = treatment*evyr_neg`yr'
	}
	
	foreach a in hsgrad collenr collgrad dropout{
		areg `a' i.female i.treatment##i.year `race_controls' `fam_controls' if year<=2016 [aw=perwt], absorb(statefip)
		predict `i'_`a'_trend, dresid
		areg `i'_`a'_trend i.female i.post2##i.treatment i.year `race_controls' `fam_controls' [aw=perwt], absorb(statefip)
		areg `i'_`a'_trend treat_x_evyr* i.female i.year `race_controls' `fam_controls' [aw=perwt], absorb(statefip)
		eventdd `i'_`a'_trend i.female `race_controls' `fam_controls' [aw=perwt], method(hdfe, absorb(statefip)) timevar(year_to_treat2) graph_op(subtitle("`i' `a'") legend(off))
	}
}



