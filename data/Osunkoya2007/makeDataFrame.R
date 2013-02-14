#Define a  function for that constructs dataframe for this study

makeDataFrame<-function(raw, studyName){
  raw$species[raw$species=="Horsfiel_polysph"]  <-  "Horsfieldia polyspherulaa"
  raw$species[raw$species=="Knema_ashiton"]     <-  "Knema ashitoniia"
  raw$species[raw$species=="Litsea_ferrugi"]    <-  "Litsea ferrugiinea"  	
  raw$species[raw$species=="Payena_unknown"]    <-  "Payena sp"		
  raw$species[raw$species=="Shorea_parvifol"]   <-  "Shorea parvifolia"		
  raw$species[raw$species=="Syz_sp_2"]          <-  "Syzygium sp."		
  raw$species[raw$species=="syzy_caudatumn"]    <-  "Syzygium caudatum"		
  raw$species[raw$species=="Dacryo_apicul"]     <-  "Dacryodes apiculatae"		
  raw$species[raw$species=="Dill_excelsa"]      <-  "Dillenia excelsa"		
  raw$species[raw$species=="Diosp_borneensis"]  <-  "Diospyros borneensis"		
  raw$species[raw$species=="Mal_sp_1"]          <-  "Mallotus sp."		
  raw$species[raw$species=="Noescor_kingi"]     <-  "Noescortechinia kingii"		
  raw$species[raw$species=="Ap_elemeri"]        <-  "Aporusa elemeri"		
  raw$species[raw$species=="Apo_grandi"]        <-  "Aporusa grandistipula"		
  raw$species[raw$species=="Apo_nitida"]        <-  "Aporusa subcaudata"		
  raw$species[raw$species=="Chionan_curvic"]    <-  "Chionanthus spicatusi"		
  raw$species[raw$species=="Ford_sp_3"]         <-  "Fordia sp."		
  raw$species[raw$species=="Ford_splendid"]     <-  "Fordia splendidissima"		
  raw$species[raw$species=="Ixora_grandif"]     <-  "Ixora grandifolia"		
  raw$species[raw$species=="Mal_ecaustus"]      <-  "Mallotus eucaustus"		
  raw$species[raw$species=="Mal_wrayei"]        <-  "Mallotus wreyi"		
  raw$species[raw$species=="Urophyl_arboret"]   <-  "Urophyllum arboreum"		
  data   <-  cbind(dataset=studyName, species=raw$species, grouping=paste(raw$Tree_no, raw$growth_form., sep="; "), raw[,c(7:12)], latitude=4.5, longitude=115.1667, map=5080, mat=30, growingCondition="FW", vegetation="TropRF", pft="EA", stringsAsFactors=FALSE)
}
