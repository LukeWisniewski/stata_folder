clear
cap log close

local dir1 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"
local dir2 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/output"


foreach i in tx_bw_cps mi_bw_cps ga_bw_cps me_bw_cps{
	cd "`dir1'"
	use "`i'.dta", replace
	cd "`dir2'"
	areg female i.post2##i.treatment i.year [aw=perwt], absorb(statefip)
	outreg2 using `i'_balance.tex, replace word label keep(1.post2#1.treatment)
	foreach var1 in black nam asian other onedeg twohs onehs nonehs{
		areg `var1' i.post2##i.treatment i.year [aw=perwt], absorb(statefip)
		outreg2 using `i'_balance.tex, append word label keep(1.post2#1.treatment)
	}
}


foreach i in tx_bw_cps mi_bw_cps ga_bw_cps me_bw_cps{
	cd "`dir1'"
	use "`i'.dta", replace
	cd "`dir2'"
	outsum hsgrad if treatment==1&post2==0 [aw=perwt] using `i'_mean.tex, replace ctitle("Treated")
	outsum hsgrad if treatment==0&post2==0 [aw=perwt] using `i'_mean.tex, append ctitle("Control")
	foreach a in collenr collgrad dropout{
		outsum `a' if treatment==1&post2==0 [aw=perwt] using `i'_mean.tex, append ctitle("Treated")
		outsum `a' if treatment==0&post2==0 [aw=perwt] using `i'_mean.tex, append ctitle("Control")
	}
}
