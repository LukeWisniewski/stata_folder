
clear
cap log close

cd "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"

local school_controls "tot_asmt_all pernam perasn perhsp perblk perwht perfl perrl perecd perell perspeced totenrl perfrl urban suburb town rural urbanicity"

local diversity_controls "diffexpecd_blkwht diffexpecd_hspwht diffexpecd_namwht diffexpecd_asnwht hswhtblk hswhthsp hsflnfl hsecdnec rswhtblk rswhthsp rsflnfl rsecdnec"

local family_controls "baplusall baplusasn baplusblk baplushsp baplusnam bapluswht single_momall single_momasn single_momblk single_momhsp single_momnam single_momwht"

local fin_controls "lninc50all lninc50asn lninc50blk lninc50hsp lninc50nam lninc50wht povertyall povertyasn povertyblk povertyhsp povertynam povertywht unempall unempasn unempblk unemphsp unempnam unempwht snapall snapasn snapblk snaphsp snapnam snapwht sesall sesasn sesblk seshsp sesnam seswht"

local simp_controls "tot_asmt_all pernam perasn perhsp perblk perwht perfl perrl perecd perell perspeced urban suburb town baplusall single_momall lninc50all povertyall unempall snapall"

local dir1 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/Data"
local dir2 "/Users/lukewisniewski/Desktop/Econ 67 Personal Paper/output"

foreach i in tx_comp ga_comp me_comp{
	cd "`dir1'"
	use "`i'.dta", replace
	cd "`dir2'"

	
	areg gcs_mn_all i.year##i.treatment##i.grade if year<=2016, absorb(fips) cluster(sedalea)
	predict `i'_trend1, dresid
	areg `i'_trend1 treat_x_evyr* i.grade, absorb(fips) cluster(sedalea)
	outreg2 using `i'_seda_es.tex, label replace keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0) addtext(Regional Controls, no, Equity Controls, no, Pooled Controls, no)
	
	areg gcs_mn_all i.year##i.treatment##i.grade `school_controls' if year<=2016, absorb(fips) cluster(sedalea)
	predict `i'_trend2, dresid
	areg `i'_trend2 treat_x_evyr* i.grade `school_controls', absorb(fips) cluster(sedalea)
	outreg2 using `i'_seda_es.tex, label append keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0) addtext(Regional Controls, Yes, Equity Controls, no, Pooled Controls, no)
	
	areg gcs_mn_all i.year##i.treatment##i.grade `diversity_controls' if year<=2016, absorb(fips) cluster(sedalea)
	predict `i'_trend3, dresid
	areg `i'_trend3 treat_x_evyr* i.grade `diversity_controls', absorb(fips) cluster(sedalea)
	outreg2 using `i'_seda_es.tex, label append keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0) addtext(Regional Controls, no, Equity Controls, Yes, Pooled Controls, no)
	
	
	areg gcs_mn_all i.year##i.treatment##i.grade `simp_controls' if year<=2016, absorb(fips) cluster(sedalea)
	predict `i'_trend6, dresid
	areg `i'_trend6 treat_x_evyr* i.grade `simp_controls', absorb(fips) cluster(sedalea)
	outreg2 using `i'_seda_es.tex, label append keep(treat_x_evyr*) sortvar(treat_x_evyr2 treat_x_evyr1 treat_x_evyr0) addtext(Regional Controls, no, Equity Controls, no, Pooled Controls, Yes)
	
}










