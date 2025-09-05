clear
cap log close

cd "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"

use "seda.dta", replace
cap gen post1=year>=2015
cap gen post2=year>=2017

cap gen year_to_treat1 = year-2015
cap gen year_to_treat2 = year-2017


preserve

* Strengthening Output-based, strengthening input-based, comps weakening both (Check Arkansas)
keep if fips==48 | fips==40 | fips==22 | fips==35 | fips==5
gen treatment = stateabb == "TX"

save "tx_comp.dta", replace

restore
preserve
*Weakening output-based, strengthening input-based, comps doing nothing
keep if fips==23 | fips==33 | fips==50
gen treatment = stateabb == "ME"

save "me_comp.dta", replace

restore
preserve

* Maintaining output-based and input-based, comps only weakening output-based
keep if fips==26 | fips==39 | fips==18 | fips==55
gen treatment = stateabb == "MI"

save "mi_comp.dta", replace


restore
preserve
* Weakening output-based and input-based, comps only weakening output-based
keep if fips==13 | fips==45 | fips==1 | fips==47 | fips==12
gen treatment = stateabb == "GA"

save "ga_comp.dta", replace


foreach i in me_comp mi_comp ga_comp tx_comp{
	use "`i'.dta", clear
	foreach yr of numlist 0/2{
		gen evyr`yr' = year_to_treat2==`yr'
		gen treat_x_evyr`yr'=treatment*evyr`yr'
		la var treat_x_evyr`yr' "t=`yr'"
	}

	foreach yr of numlist 2/8{
		gen evyr_neg`yr' = year_to_treat2 == -`yr'
		gen treat_x_evyr_neg`yr' = treatment*evyr_neg`yr'
		la var treat_x_evyr_neg`yr' "t=-`yr'"
	}
	
	save "`i'.dta", replace
	
	keep if inrange(year, 2009, 2015)
	drop if treatment !=1
	collapse (mean) gcs_mn_all, by(sedalea subject)
	rename gcs_mn_all avg_score
	
	tempfile avg_scores_`i'
	save `avg_scores_`i''
	
	use `avg_scores_`i'', clear
	bysort subject (avg_score): gen rank = _n
	bysort subject: gen percentile = (rank - 1) / (_N - 1) * 100
	save `avg_scores_`i'', replace

	use "`i'.dta", clear
	drop if treatment!=1
	merge m:1 sedalea subject using `avg_scores_`i''
	drop if _merge ==1
	drop _merge
	
	gen low = percentile <= 25
	gen high = percentile >= 75
	
	gen low_to_treat = year-2017 if low==1

	
	save "within_`i'.dta", replace
}


foreach i in me_comp  ga_comp tx_comp{
	use "`i'.dta", clear
	
	forval p=3/8{
		gen grade_score_`p'= gcs_mn_all if grade==`p'
		la var grade_score_`p' "Grade `p'"
	}
	
	outsum grade_score* if treatment==1&post2==0 using `i'_seda_means.tex, replace ctitle("Pre-2017")
	outsum grade_score* if treatment==1&post2==1 using `i'_seda_means.tex, append ctitle("Post-2017")
	outsum grade_score* if treatment==0 & post2==0 using `i'_seda_means.tex, append ctitle("Pre-2017")
	outsum grade_score* if treatment==0&post2==1 using `i'_seda_means.tex, append ctitle("Post-2017")
}



/*
local varlist "tot_asmt_all urban suburb town rural pernam perasn perhsp perblk perwht perfl perrl perecd perell perspeced totenrl diffexpecd_blkwht diffexpecd_hspwht diffexpecd_namwht diffexpecd_asnwht lninc50all lninc50asn lninc50blk lninc50hsp lninc50nam lninc50wht baplusall baplusasn baplusblk baplushsp baplusnam bapluswht povertyall povertyasn povertyblk povertyhsp povertynam povertywht unempall unempasn unempblk unemphsp unempnam unempwht snapall snapasn snapblk snaphsp snapnam snapwht single_momall single_momasn single_momblk single_momhsp single_momnam single_momwht"

local dir1 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"
local dir2 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/output"

foreach i in me_comp mi_comp ga_comp tx_comp{
	cd "`dir1'"
	use "`i'.dta", replace
	cd "`dir2'"
	reghdfe perfl i.post2##i.treatment, absorb(fips year) cluster(sedalea)
	outreg2 using `i'_seda_balance.tex, replace word label keep(1.post2#1.treatment)
	
	foreach varimp in perrl perecd perell perspeced lninc50all lninc50asn lninc50blk lninc50hsp lninc50nam lninc50wht{
	reghdfe `varimp' i.post2##i.treatment, absorb(fips year) cluster(sedalea)
			outreg2 using `i'_seda_balance.tex, append word label keep(1.post2#1.treatment)
	}
		foreach var1 in tot_asmt_all urban suburb town rural totenrl diffexpecd_blkwht diffexpecd_hspwht diffexpecd_namwht diffexpecd_asnwht pernam perasn perhsp perblk perwht baplusall baplusasn baplusblk baplushsp baplusnam bapluswht lninc50all lninc50asn lninc50blk lninc50hsp lninc50nam lninc50wht povertyall povertyasn povertyblk povertyhsp povertynam povertywht unempall unempasn unempblk unemphsp unempnam unempwht snapall snapasn snapblk snaphsp snapnam snapwht single_momall single_momasn single_momblk single_momhsp single_momnam single_momwht{
			reghdfe `var1' i.post2##i.treatment, absorb(fips year) cluster(sedalea)
	}
}
*/
