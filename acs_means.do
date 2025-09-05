clear
cap log close

cd "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"

local race_controls "black nam asian other"
local fam_controls = "onedeg twohs onehs nonehs"

local dir1 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"
local dir2 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/output"


foreach i in tx_bw_cps ga_bw_cps me_bw_cps{
	use "`i'.dta", replace
	collapse (mean) hsgrad collenr collgrad dropout, by(treatment year)
	la var hsgrad "High School Graduation Rate"
	la var collenr "College Enrollment Rate"
	la var collgrad "College Graduation Rate"
	la var dropout "High School Dropout Rate"
	la var year "Year"
	foreach a in hsgrad collenr dropout{
	graph two (line `a' year if treatment ==1&year<=2017) (line `a' year if treatment==0&year<=2017, lp(dash)), legend(label(1 "Treatment") label(2 "Comparison")) scheme(s1mono)
	gr export `i'_`a'.png, replace as(png) 
	}
}

foreach i in tx_bw_cps ga_bw_cps me_bw_cps{
	use "`i'.dta", replace
	la var hsgrad "High School Graduation Rate"
	la var collenr "College Enrollment Rate"
	la var dropout "High School Dropout Rate"
	
	
		outsum hsgrad dropout collenr if treatment==1&post2==0 using `i'_means.tex, replace ctitle("Pre-2017")
		outsum hsgrad dropout collenr if treatment ==1&post2==1 using `i'_means.tex, append ctitle("Post-2017")
		
		outsum hsgrad dropout collenr if treatment==0 & post2==0 using `i'_means.tex, append ctitle("Pre-2017")
		outsum hsgrad dropout collenr if treatment==0&post2==1 using `i'_means.tex, append ctitle("Post-2017")
	}
