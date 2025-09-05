clear


cd "/Users/lukewisniewski/Desktop/Recruiting_Info/"

******************************* PLAYER DATA **********************************
use "full_merged.dta", replace

gen policy = NCPAScore*post
la var policy "NIL Policy Exposure (Intensity)"
gen exposed = policy>0
la var exposed "NIL Policy Exposure (Binary)"


foreach i in wpct bowl revenue expenses{
	reghdfe On3 policy, absorb(num_Position Year num_Conference i.Year#i.num_Conference) vce(cluster ID)
	est sto iv_`i'_1s
ivreghdfe `i' (On3=policy), absorb(num_Position Year num_Conference i.Year#i.num_Conference) vce(cluster ID)
est sto iv_`i'_2s
scalar aa_`i'=e(widstat)
estadd scalar KleibergenPaap_Fstat=aa_`i': iv_`i'_2s

forval j=1/3{
	ivreghdfe future_`i'_`j' (On3=policy), absorb(num_Position Year num_Conference i.Year#i.num_Conference) vce(cluster ID)
	est sto iv_`i'_`j'_2s
	scalar aa_`i'_`j'=e(widstat)
	estadd scalar KleibergenPaap_Fstat=aa_`i'_`j': iv_`i'_`j'_2s
}
esttab iv_`i'_1s iv_`i'_2s iv_`i'_1_2s iv_`i'_2_2s iv_`i'_3_2s using `i'_iv_player.tex, se(%3.2f) b(2) keep(policy On3 _cons) label booktabs scalars("widstat Kleibergen-Paap F-stat") star(* 0.1 ** 0.05 *** 0.01) r2 cells(b(star fmt(4)) se(par fmt(4))) collabels(none) title("IV regression: `i'") nomtitles mgroups("First stage" "Current `i'" "`i' (t+1)" "`i' (t+2)" "`i' (t+3)", pattern(1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) replace

	reghdfe On3 i.num_Conference, absorb(num_Position Year) vce(cluster ID)
	est sto conf_`i'_1s
	ivreghdfe `i' (On3=i.num_Conference), absorb(num_Position Year) vce(cluster ID)
	est sto conf_`i'_2s
	scalar ff_`i'=e(widstat)
	estadd scalar KleibergenPaap_Fstat=ff_`i':conf_`i'_2s
	forval j=1/3{
		ivreghdfe future_`i'_`j' (On3=i.num_Conference), absorb(num_Position Year) vce(cluster ID)
		est sto conf_`i'_`j'_2s
		scalar ff_`i'_`j'=e(widstat)
		estadd scalar KleibergenPaap_Fstat=ff_`i'_`j': conf_`i'_`j'_2s
	}
	esttab conf_`i'_1s conf_`i'_2s conf_`i'_1_2s conf_`i'_2_2s conf_`i'_3_2s using `i'_conf_player.tex, se(%3.2f) b(2) keep(?.num_Conference On3 _cons) label booktabs scalars("widstat Kleibergen-Paap F-stat") star(* 0.1 ** 0.05 *** 0.01) r2 cells(b(star fmt(4)) se(par fmt(4))) collabels(none) title("IV regression: `i'") nomtitles mgroups("First stage" "Current `i'" "`i' (t+1)" "`i' (t+2)" "`i' (t+3)", pattern(1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) replace
	
	reghdfe On3 exposed, absorb(num_Position Year num_Conference i.Year#i.num_Conference) vce(cluster ID)
	est sto iv_binary_`i'_1s
	ivreghdfe `i' (On3=exposed), absorb(num_Position Year num_Conference i.Year#i.num_Conference) vce(cluster ID)
	est sto iv_binary_`i'_2s
	scalar jj_`i' = e(widstat)
	estadd scalar KleibergenPaap_FStat=jj_`i': iv_binary_`i'_2s
	forval j=1/3{
	ivreghdfe future_`i'_`j' (On3=exposed), absorb(num_Position Year num_Conference i.Year#i.num_Conference) vce(cluster ID)
	est sto iv_binary_`i'_`j'_2s
	scalar jj_`i'_`j'=e(widstat)
	estadd scalar KleibergenPaap_Fstat=jj_`i'_`j': iv_binary_`i'_`j'_2s
}
	esttab iv_binary_`i'_1s iv_binary_`i'_2s iv_binary_`i'_1_2s iv_binary_`i'_2_2s iv_binary_`i'_3_2s using `i'_binary_iv_player.tex, se(%3.2f) b(2) keep(exposed On3 _cons) label booktabs scalars("widstat Kleibergen-Paap F-stat") star(* 0.1 ** 0.05 *** 0.01) r2 cells(b(star fmt(4)) se(par fmt(4))) collabels(none) title("IV regression: `i'") nomtitles mgroups("First stage" "Current `i'" "`i' (t+1)" "`i' (t+2)" "`i' (t+3)", pattern(1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) replace
}

*********************************** TEAM DATA ********************************
use "full_composite.dta", replace

gen policy = NCPAScore*post
la var policy "NIL Policy Exposure (Intensity)"
gen exposed = policy>0
la var exposed "NIL Policy Exposure (Binary)"


foreach i in wpct bowl revenue expenses{
	reghdfe recruiting_ranking policy, absorb(Year num_Conference i.Year#i.num_Conference) cluster(ID)
	est sto iv_team_`i'_1s
	reghdfe recruiting_ranking policy, absorb(Year num_Conference i.Year#i.num_Conference)
	est sto temp_`i'_1s
	ivreghdfe `i' (recruiting_ranking=policy), absorb(Year num_Conference i.Year#i.num_Conference) cluster(ID)
	est sto iv_team_`i'_2s
	scalar bb_`i' = e(widstat)
	estadd scalar KleibergenPaap_FStat=bb_`i': iv_team_`i'_2s
	ivreghdfe `i' (recruiting_ranking=policy), absorb(Year num_Conference i.Year#i.num_Conference)
	est sto temp_`i'
	scalar ab_`i' = e(widstat)
	estadd scalar CraggDonald_FStat=ab_`i': iv_team_`i'_2s
	forval j=1/3{
		ivreghdfe future_`i'_`j' (recruiting_ranking=policy), absorb(Year num_Conference i.Year#i.num_Conference) cluster(ID)
		est sto iv_team_`i'_`j'_2s
		scalar bb_`i'_`j' = e(widstat)
		estadd scalar KleibergenPaap_FStat=bb_`i'_`j': iv_team_`i'_`j'_2s
		ivreghdfe future_`i'_`j' (recruiting_ranking=policy), absorb(Year num_Conference i.Year#i.num_Conference)
		est sto temp_`i'_`j'
		scalar ab_`i'_`j' = e(widstat)
		estadd scalar CraggDonald_FStat=ab_`i'_`j': iv_team_`i'_`j'_2s
		
}
esttab iv_team_`i'_1s iv_team_`i'_2s iv_team_`i'_1_2s iv_team_`i'_2_2s iv_team_`i'_3_2s using `i'_iv_team.tex, se(%3.2f) b(2) label booktabs scalars("widstat Kleibergen-Paap F-stat") star(* 0.1 ** 0.05 *** 0.01) r2 cells(b(star fmt(4)) se(par fmt(4))) collabels(none) title("IV regression: `i'") nomtitles mgroups("First stage" "Current `i'" "`i' (t+1)" "`i' (t+2)" "`i' (t+3)", pattern(1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) replace

esttab temp_`i'_1s temp_`i' temp_`i'_1 temp_`i'_2 temp_`i'_3 using `i'_iv_team_cd.tex, se(%3.2f) b(2) label booktabs scalars("widstat Cragg-Donald F-stat") star(* 0.1 ** 0.05 *** 0.01) r2 cells(b(star fmt(4)) se(par fmt(4))) collabels(none) title("IV regression: `i'") nomtitles mgroups("First stage" "Current `i'" "`i' (t+1)" "`i' (t+2)" "`i' (t+3)", pattern(1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) replace

	reghdfe recruiting_ranking i.num_Conference, absorb(Year) vce(cluster ID)
	est sto conf_team_`i'_1s
	ivreghdfe `i' (recruiting_ranking=i.num_Conference), absorb(Year) vce(cluster ID)
	est sto conf_team_`i'_2s
	scalar gg_`i'=e(widstat)
	estadd scalar KleibergenPaap_Fstat=gg_`i':conf_team_`i'_2s
	forval j=1/3{
		ivreghdfe future_`i'_`j' (recruiting_ranking=i.num_Conference), absorb(Year) vce(cluster ID)
		est sto conf_team_`i'_`j'_2s
		scalar gg_`i'_`j'=e(widstat)
		estadd scalar KleibergenPaap_Fstat=gg_`i'_`j': conf_team_`i'_`j'_2s
	}
	esttab conf_team_`i'_1s conf_team_`i'_2s conf_team_`i'_1_2s conf_team_`i'_2_2s conf_team_`i'_3_2s using `i'_conf_team.tex, se(%3.2f) b(2) label booktabs scalars("widstat Kleibergen-Paap F-stat") star(* 0.1 ** 0.05 *** 0.01) r2 cells(b(star fmt(4)) se(par fmt(4))) collabels(none) title("IV regression: `i'") nomtitles mgroups("First stage" "Current `i'" "`i' (t+1)" "`i' (t+2)" "`i' (t+3)", pattern(1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) replace
	
	reghdfe recruiting_ranking exposed, absorb(Year num_Conference i.Year#i.num_Conference) cluster(ID)
	est sto iv_binaryteam_`i'_1s
	ivreghdfe `i' (recruiting_ranking=exposed), absorb(Year num_Conference i.Year#i.num_Conference) cluster(ID)
	est sto iv_binaryteam_`i'_2s
	scalar ll_`i' = e(widstat)
	estadd scalar KleibergenPaap_FStat=ll_`i': iv_binaryteam_`i'_2s
	forval j=1/3{
	ivreghdfe future_`i'_`j' (recruiting_ranking=exposed), absorb(Year num_Conference i.Year#i.num_Conference) cluster(ID)
	est sto iv_binaryteam_`i'_`j'_2s
	scalar ll_`i'_`j'=e(widstat)
	estadd scalar KleibergenPaap_Fstat=ll_`i'_`j': iv_binaryteam_`i'_`j'_2s
}
	esttab iv_binaryteam_`i'_1s iv_binaryteam_`i'_2s iv_binaryteam_`i'_1_2s iv_binaryteam_`i'_2_2s iv_binaryteam_`i'_3_2s using `i'_binary_iv_team.tex, se(%3.2f) b(2) label booktabs scalars("widstat Kleibergen-Paap F-stat") star(* 0.1 ** 0.05 *** 0.01) r2 cells(b(star fmt(4)) se(par fmt(4))) collabels(none) title("IV regression: `i'") nomtitles mgroups("First stage" "Current `i'" "`i' (t+1)" "`i' (t+2)" "`i' (t+3)", pattern(1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) replace
	}

