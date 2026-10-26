# Independent aggregation checks, model identities, and coverage checks.
library(haven)
library(data.table)
read_table <- function(name) fread(file.path("outputs/tables", paste0(name, ".csv")))
results <- read_table("trend_results")
paths <- read_table("trend_paths")
stopifnot(all(is.finite(results$estimate)), all(results$lower <= results$estimate),
  all(results$upper >= results$estimate), all(results$df == 50))
wide <- dcast(results, scenario + family + group ~ metric, value.var = "estimate")
stopifnot(max(abs(wide$post_slope-wide$pre_slope-wide$slope_change))<1e-7,
  max(abs(wide$gap2024-wide$gap2021-3*wide$slope_change))<1e-7)

cells <- as.data.table(read_dta("data/processed/earnings_cells.dta"))
flow <- read_table("sample_flow")
stopifnot(sum(cells[employed==1,n]) ==
  sum(flow[stage=="main_employed_positive_earners",observations]))
keys <- c("stateicp","age","sex","college","age_group","age_college")
base <- cells[employed==1,lapply(.SD,sum), by=c("year",keys),
  .SDcols=c("weight","weighted_log","weighted_real","weighted_nominal")]
base[,complete := .N==8, by=keys]
base <- base[complete==TRUE]
weights <- base[year==2019,c(keys,"weight"),with=FALSE]
setnames(weights,"weight","baseline_weight")
base <- merge(base,weights,by=keys)
for (family_name in c("overall","age","sex","college","age_college")) {
  base[,group := 1L]
  if (family_name=="age") base[,group := age_group]
  if (family_name=="sex") base[,group := sex]
  if (family_name=="college") base[,group := college+1L]
  if (family_name=="age_college") base[,group := age_college]
  expected <- base[,.(expected_log=sum(weighted_log/weight*baseline_weight)/sum(baseline_weight),
    expected_real=sum(weighted_real/weight*baseline_weight)/sum(baseline_weight)),by=.(year,group)]
  actual <- paths[scenario=="main" & family==family_name]
  joined <- merge(actual,expected,by=c("year","group"))
  stopifnot(nrow(joined)==nrow(actual),
    max(abs(joined$observed-joined$expected_log))<1e-5,
    max(abs(joined$real_mean-joined$expected_real))<.02)
}
quantiles <- read_table("weighted_quantiles")
stopifnot(all(quantiles$p10<=quantiles$p50),all(quantiles$p50<=quantiles$p90))
support <- read_table("common_support")
stopifnot(all(support$retained_weight<=support$total_weight+1),
  all(support$retained_weight>0), all(support$total_n>=support$retained_n))
events <- read_table("event_gaps")
stopifnot(all(events[year==2019,estimate]==0),all(events[year==2019,se]==0))
coverage <- read_table("employment_and_income_coverage")
stopifnot(all(coverage$employed>=0 & coverage$employed<=1),
  all(coverage$positive_income>=0 & coverage$positive_income<=1))
relative <- read_table("relative_changes_adjusted")
stopifnot(all(relative[!is.na(p_holm),p_holm>=p-1e-10]))
pngs <- list.files("outputs/figures",pattern="^[0-9].*png$",full.names=TRUE)
stopifnot(length(pngs)==6,all(file.info(pngs)$size>10000))
writeLines("Aggregation, model identities, coverage and outputs validated.",
  "outputs/tables/VALIDATION_PASSED.txt")
cat("All output validation checks passed.\n")
