clear

cd "/Users/lukewisniewski/Desktop/Recruiting_Info/"

use "full_composite.dta", replace

gen policy = NCPAScore*post
gen exposed = policy>0
gen treatedexposed = NCPAScore>0
gen treatyear = Year>2020

tabstat recruiting_ranking wpct bowl revenue expenses combinedstar, by(exposed)

sort exposed
* summary statistics by group
eststo clear
by exposed: eststo: quietly estpost summarize ///
    recruiting_ranking wpct bowl revenue expenses combinedstar
esttab, cells("mean sd") label nodepvar   


eststo nopolicy: quietly estpost summarize ///
    recruiting_ranking wpct bowl revenue expenses combinedstar if treatyear == 0
eststo policy: quietly estpost summarize ///
    recruiting_ranking wpct bowl revenue expenses combinedstar if treatyear == 1
eststo diff: estpost ttest ///
    recruiting_ranking wpct bowl revenue expenses combinedstar, by(treatyear)

esttab nopolicy policy diff using summstats.tex, ///
cells("mean(pattern(1 1 0) fmt(2)) sd(pattern(1 1 0)) b(star pattern(0 0 1) fmt(2)) t(pattern(0 0 1) par fmt(2))") ///
label replace
