clear


cd "/Users/lukewisniewski/Desktop/Recruiting_Info/"

use "full_merged.dta", replace

reg On3 i.num_Position i.num_Conference##i.Year c.NCPAScore##i.post

foreach i in wpct wins bowl future_wpct_1 future_wpct_2 future_wpct_3 future_bowl_1 future_bowl_2 future_bowl_3{
	qui reg `i' c.On3##i.num_Position c.NCPAScore##i.post, cluster(ID)
	qui reg `i' c.On3##i.num_Position i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)
	qui reg `i' c.On3##i.num_Position i.num_Conference##i.Year treat_x_evyr*, cluster(ID)
	*reghdfe `i' c.On3##i.num_Position treat_x_evyr*, absorb(num_Conference Year) cluster(ID)
	qui reg `i' c.On3##i.num_Position i.num_Conference##i.Year if Year<=2019, cluster(ID)
	predict `i'_resid, residual
	egen mean_`i'_resid = mean(`i'_resid), by(num_State)
	gen `i'_trend = `i'_resid - mean_`i'_resid
	reg `i'_trend c.On3##i.num_Position i.num_Conference##i.Year treat_x_evyr*, cluster(ID)
	*eventdd `i' c.On3##i.num_Position i.num_Conference##i.Year c.NCPAScore, method(ols, cluster(ID)) timevar(year_to_treat) leads(2) lags(1) accum graph_op(subtitle("`i'")) level(90)
}

foreach i in expenses revenue future_revenue_1 future_revenue_2 future_revenue_3 future_expenses_1 future_expenses_2 future_expenses_3{
	qui reg `i' wins bowl c.NCPAScore##i.post, cluster(ID)
	qui reg `i' wins bowl i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)
	qui reg `i' wins bowl i.num_Conference##i.Year treat_x_evyr*, cluster(ID)
	
	qui reg `i' wins bowl i.num_Conference##i.Year if Year<=2019, cluster(ID)
	predict `i'_resid, residual
	egen mean_`i'_resid = mean(`i'_resid), by(num_State)
	gen `i'_trend = `i'_resid - mean_`i'_resid
	reg `i'_trend wins bowl i.num_Conference##i.Year treat_x_evyr*, cluster(ID)
	*reghdfe `i' wins bowl treat_x_evyr*, absorb(num_Conference Year) cluster(ID)
	*eventdd `i' wins bowl i.num_Conference##i.Year c.NCPAScore, method(ols, cluster(ID)) timevar(year_to_treat) graph_op(subtitle("`i'")) level(90)
}


/*
reg wins c.On3##i.num_Position i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)

reg wpct c.On3##i.num_Position i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)

reg bowl c.On3##i.num_Position i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)


reg revenue wins bowl i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)

*/

use "full_composite.dta", replace
/*
foreach i in wpct wins revenue expenses bowl recruiting_ranking{
	reg `i' i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)
}

reg revenue wins bowl i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)
*/

qui reg recruiting_ranking i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)
qui reg recruiting_ranking c.NCPAScore##i.post, cluster(ID)

foreach i in wpct wins bowl future_wpct_1 future_wpct_2 future_wpct_3 future_bowl_1 future_bowl_2 future_bowl_3{
	qui reg `i' recruiting_ranking c.NCPAScore##i.post, cluster(ID)
	qui reg `i' recruiting_ranking i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)
	qui reg `i' recruiting_ranking i.num_Conference##i.Year treat_x_evyr*, cluster(ID)
	*reghdfe `i' recruiting_ranking treat_x_evyr*, absorb(num_Conference Year) cluster(ID)
	
	qui reg `i' recruiting_ranking i.num_Conference##i.Year if Year<=2019, cluster(ID)
	predict `i'_resid, residual
	egen mean_`i'_resid = mean(`i'_resid), by(num_State)
	gen `i'_trend = `i'_resid - mean_`i'_resid
	reg `i'_trend recruiting_ranking i.num_Conference##i.Year treat_x_evyr*, cluster(ID)
	}

foreach i in expenses revenue future_revenue_1 future_revenue_2 future_revenue_3 future_expenses_1 future_expenses_2 future_expenses_3{
	qui reg `i' wins bowl c.NCPAScore##i.post, cluster(ID)
	qui reg `i' wins bowl i.num_Conference##i.Year c.NCPAScore##i.post, cluster(ID)
	qui reg `i' wins bowl i.num_Conference##i.Year treat_x_evyr*, cluster(ID)
	*reghdfe `i' wins bowl treat_x_evyr*, absorb(num_Conference Year) cluster(ID)
	
	qui reg `i' wins bowl i.num_Conference##i.Year if Year<=2019, cluster(ID)
	predict `i'_resid, residual
	egen mean_`i'_resid = mean(`i'_resid), by(num_State)
	gen `i'_trend = `i'_resid - mean_`i'_resid
	reg `i'_trend wins bowl i.num_Conference##i.Year treat_x_evyr*, cluster(ID)
}

