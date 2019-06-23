## ----setup, include = FALSE----------------------------------------------
library(hR)
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----workforceHistory----------------------------------------------------
data("workforceHistory")

# Reduce to DATE <= today to exclude future-dated records
dt = workforceHistory[DATE<=Sys.Date()]

# Reduce to max DATE and SEQ per person
dt = dt[dt[,.I[which.max(DATE)],by=.(EMPLID)]$V1]
dt = dt[dt[,.I[which.max(SEQ)],by=.(EMPLID,DATE)]$V1]

# Only consider workers who are currently active
# This provides a reliable 'headcount' data set that reflects today's active workforce
dt = dt[STATUS=="Active"]

# Exclude the CEO because she does not have a supervisor
CEO = dt[TITLE=="CEO",EMPLID]
dt = dt[EMPLID!=CEO]

## ----hierarchyLong-------------------------------------------------------
# Use the hierarchyLong() function to produce an elongated hierarchy data.table
hLong = hierarchyLong(dt$EMPLID,dt$SUPVID)
print(hLong)

# Who reports up through Susan? (direct and indirect reports)
hLong[Supervisor==CEO]

## ----hierarchyWide-------------------------------------------------------
hWide = hierarchyWide(dt$EMPLID,dt$SUPVID)
print(hWide)

# Who reports up through Pablo? (direct and indirect reports)
hWide[Supv2==199827]

