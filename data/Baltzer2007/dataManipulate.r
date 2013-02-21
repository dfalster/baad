names(raw)[names(raw) == "Plant.functional.type"]    <-  "pft"
names(raw)[names(raw) == "Growing.condition"]        <-  "growingCondition"
raw$species=raw$species