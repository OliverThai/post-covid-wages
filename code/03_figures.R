# Figures and readable tables from Stata estimates. No regressions are fit in R.
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) setwd(args[1])
library(ggplot2)
stopifnot(file.exists("outputs/tables/ANALYSIS_COMPLETE.txt"))
tables <- "outputs/tables"
figures <- "outputs/figures"
read_table <- function(name) read.csv(file.path(tables, paste0(name, ".csv")))
results <- read_table("trend_results")
paths <- read_table("trend_paths")
relative <- read_table("relative_changes")
events <- read_table("event_gaps")
pretests <- read_table("pretrend_tests")
support <- read_table("common_support")
flow <- read_table("sample_flow")

group_label <- function(family, group) {
  labels <- list(
    overall = "All employed earners",
    age = c("Ages 25-34", "Ages 35-44", "Ages 45-54"),
    sex = c("Men", "Women"),
    college = c("Below bachelor's", "Bachelor's or higher"),
    age_college = c("25-34: below bachelor's", "25-34: bachelor's or higher",
      "35-44: below bachelor's", "35-44: bachelor's or higher",
      "45-54: below bachelor's", "45-54: bachelor's or higher")
  )
  mapply(function(f, g) labels[[f]][g], as.character(family), group, USE.NAMES = FALSE)
}
scenario_labels <- c(main = "Fixed 2019 composition", raw_mix = "Changing composition",
  cap99 = "Cap at pre-period P99", income_timing = "ACS income timing adjustment",
  all_earners = "Include earners not employed now", race_fixed = "Also fix race composition",
  omit2021 = "Post trend starts in 2022", late_baseline = "Pre trend starts in 2017")

# Adjustment covers all 18 exploratory post-period relative contrasts together.
relative$p_holm <- NA_real_
post_rows <- relative$metric != "relative_pre_slope"
relative$p_holm[post_rows] <- p.adjust(relative$p[post_rows], method = "holm")
pretests$p_holm <- p.adjust(pretests$p, method = "holm")
relative$label <- group_label(relative$family, relative$group)
relative$reference_label <- group_label(relative$family, relative$reference)
write.csv(relative, file.path(tables, "relative_changes_adjusted.csv"), row.names = FALSE)
write.csv(pretests, file.path(tables, "pretrend_tests_adjusted.csv"), row.names = FALSE)

results$label <- group_label(results$family, results$group)
results$percent <- 100 * expm1(results$estimate)
results$percent_lower <- 100 * expm1(results$lower)
results$percent_upper <- 100 * expm1(results$upper)
main <- subset(results, scenario == "main")
main_slopes <- subset(main, metric %in% c("pre_slope", "post_slope"))
main_slopes$period <- ifelse(main_slopes$metric == "pre_slope", "2016-2019", "2021-2024")
main_slopes$family_label <- factor(main_slopes$family,
  levels = c("overall", "age", "sex", "college", "age_college"),
  labels = c("Overall", "Age", "Sex", "Education", "Age and education"))
write.csv(results, file.path(tables, "interpreted_estimates.csv"), row.names = FALSE)

# Use observed 2019 as a common denominator; this indexes geometric means.
paths$label <- group_label(paths$family, paths$group)
main_paths <- subset(paths, scenario == "main")
baseline <- subset(main_paths, year == 2019, select = c(family, group, observed))
names(baseline)[3] <- "base2019"
main_paths <- merge(main_paths, baseline, by = c("family", "group"))
main_paths$index <- 100 * exp(main_paths$observed - main_paths$base2019)
main_paths$projection <- 100 * exp(main_paths$projected - main_paths$base2019)
main_paths$period <- ifelse(main_paths$year < 2020, "Before", "After")
theme_set(theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(), plot.title = element_text(face = "bold"),
    plot.caption = element_text(hjust = 0, size = 9), legend.position = "bottom"))
years <- c(2016:2019, 2021:2024)
save_plot <- function(name, plot, width = 9, height = 6) {
  ggsave(file.path(figures, name), plot, width = width, height = height, dpi = 180, bg = "white")
}
overall <- subset(main_paths, family == "overall")
p <- ggplot(overall, aes(year, index)) +
  geom_vline(xintercept = 2020, linetype = "dotted", color = "grey45") +
  geom_line(aes(y = projection, color = "Pre-period trend projected forward"), linetype = "dashed") +
  geom_line(aes(group = period, color = "Observed")) + geom_point(size = 2) +
  scale_color_manual(values = c("Observed" = "#007C83",
    "Pre-period trend projected forward" = "#A34628")) +
  scale_x_continuous(breaks = years) +
  labs(title = "Did real earnings keep up with their earlier trend?", x = NULL,
    y = "Geometric mean earnings index (observed 2019 = 100)", color = NULL,
    caption = "Fixed 2019 age, sex, degree and state composition. No 2020 observation.\nFour pre-period years support a linear projection, not a causal counterfactual.")
save_plot("01_earnings_vs_prior_trend.png", p)

p <- ggplot(subset(main_slopes, family != "age_college"),
    aes(x = percent, y = label, color = period)) +
  geom_linerange(aes(xmin = percent_lower, xmax = percent_upper),
    position = position_dodge(width = .55), orientation = "y") +
  geom_point(position = position_dodge(width = .55), size = 2.5) +
  facet_wrap(~family_label, scales = "free_y", ncol = 2) +
  scale_color_manual(values = c("2016-2019" = "#A34628", "2021-2024" = "#007C83")) +
  labs(title = "Growth rates before and after COVID", x = "Fitted annual growth (%)",
    y = NULL, color = "Period",
    caption = "Growth of geometric mean real annual earnings, not individual raises.\n95% intervals cluster by state; common national shocks and projection uncertainty remain.")
save_plot("02_growth_rates.png", p, height = 7)

gaps <- subset(main, metric == "gap2024" & family != "age_college")
p <- ggplot(gaps, aes(percent, reorder(label, percent))) +
  geom_vline(xintercept = 0, color = "grey50", linetype = "dotted") +
  geom_linerange(aes(xmin = percent_lower, xmax = percent_upper), orientation = "y") +
  geom_point(color = "#007C83", size = 2.5) +
  labs(title = "2024 fitted earnings relative to the earlier trend",
    x = "Difference from projected pre-period trend (%)", y = NULL,
    caption = "Negative values mean below the projection, not below 2019 earnings.\nModel-based 95% intervals cluster by state; these are not causal effects of COVID.")
save_plot("03_departure_from_trend.png", p)

events <- subset(events, family != "age_college")
events$comparison <- paste(group_label(events$family, events$group), "vs",
  group_label(events$family, events$reference))
events$period <- ifelse(events$year < 2020, "Before", "After")
p <- ggplot(events, aes(year, 100*estimate)) +
  geom_hline(yintercept = 0, color = "grey65") +
  geom_vline(xintercept = 2020, linetype = "dotted", color = "grey45") +
  geom_errorbar(aes(ymin = 100*lower, ymax = 100*upper), width = .15) +
  geom_line(aes(group = period), color = "#007C83") + geom_point(size = 1.7) +
  facet_wrap(~comparison, ncol = 2) + scale_x_continuous(breaks = c(2016,2019,2021,2024)) +
  labs(title = "Were group differences already changing before COVID?",
    x = NULL, y = "Change in earnings gap since 2019 (log points x 100)",
    caption = "State-group and state-year fixed effects; state-clustered 95% intervals.\n2019 is the reference year. Earlier differences challenge a simple parallel-trends interpretation.")
save_plot("04_relative_yearly_gaps.png", p, height = 7)

sensitivity <- subset(results, family == "overall" & metric == "gap2024")
sensitivity$setting <- unname(scenario_labels[sensitivity$scenario])
p <- ggplot(sensitivity, aes(percent, reorder(setting, percent))) +
  geom_vline(xintercept = 0, linetype = "dotted", color = "grey45") +
  geom_linerange(aes(xmin = percent_lower, xmax = percent_upper), orientation = "y") +
  geom_point(color = "#A34628", size = 2.5) +
  labs(title = "How sensitive is the departure from trend?",
    x = "2024 fitted earnings relative to projected trend (%)", y = NULL,
    caption = "Specifications change composition, earnings treatment, sample or trend window.\nIntervals condition on the model; they do not capture all uncertainty about the counterfactual.")
save_plot("05_sensitivity.png", p)

p <- ggplot(subset(main_paths, family == "age_college"), aes(year, index)) +
  geom_vline(xintercept = 2020, linetype = "dotted", color = "grey45") +
  geom_line(aes(y = projection), color = "#A34628", linetype = "dashed") +
  geom_line(aes(group = period), color = "#007C83") + geom_point(size = 1.3) +
  facet_wrap(~label, ncol = 2) + scale_x_continuous(breaks = c(2016,2019,2021,2024)) +
  labs(title = "Age and degree status: observed earnings and earlier trends",
    x = NULL, y = "Geometric mean earnings index (2019 = 100)",
    caption = "Teal: observed; dashed rust: pre-period projection. Bachelor's status does not identify recent graduates.\nThese are repeated cross sections, not individual career paths.")
save_plot("06_age_and_degree.png", p, height = 8)

# Regenerates numerical report; the root research summary is an interpreted snapshot.
fmt <- function(x) sprintf("%.2f", x)
report <- c("# Reproducible results", "",
  "Generated from Stata tables. Main scenario fixes 2019 single-year age, sex, degree and state composition.",
  "Inference is conditional on a linear model and state clustering, not a causal COVID design.", "",
  "| Group | Pre annual growth (%) | Post annual growth (%) | Slope change (log pp/year) | 2024 departure (%) |",
  "|---|---:|---:|---:|---:|")
keys <- unique(main[, c("family", "group", "label")])
for (i in seq_len(nrow(keys))) {
  d <- subset(main, family == keys$family[i] & group == keys$group[i])
  val <- function(metric, column) d[d$metric == metric, column]
  report <- c(report, paste0("| ", keys$label[i], " | ",
    fmt(val("pre_slope", "percent")), " | ", fmt(val("post_slope", "percent")), " | ",
    fmt(100*val("slope_change", "estimate")), " | ", fmt(val("gap2024", "percent")), " |"))
}
report <- c(report, "", "## Sensitivity: overall earnings", "",
  "| Specification | Pre annual growth (%) | Post annual growth (%) | 2024 departure (%) |",
  "|---|---:|---:|---:|")
for (s in names(scenario_labels)) {
  d <- subset(results, family == "overall" & scenario == s)
  val <- function(m) d$percent[d$metric == m]
  report <- c(report, paste0("| ", scenario_labels[s], " | ", fmt(val("pre_slope")),
    " | ", fmt(val("post_slope")), " | ", fmt(val("gap2024")), " |"))
}
report <- c(report, "", "## Sample and inference", "",
  paste("Employed positive-earner records:", format(sum(flow$observations[
    flow$stage == "main_employed_positive_earners"]), scientific = FALSE, big.mark = ",")),
  paste("Minimum fixed-cell population coverage (main):",
    sprintf("%.3f%%", 100*min(with(subset(support, scenario == "main"), retained_weight/total_weight)))),
  paste("Minimum fixed-cell population coverage (race sensitivity):",
    sprintf("%.3f%%", 100*min(with(subset(support, scenario == "race_fixed"), retained_weight/total_weight)))),
  "",
  "Relative changes use state-year effects to absorb common local shocks. The 18 post-period relative contrasts receive Holm adjustment together. Pretrend tests are adjusted separately across nine comparisons.",
  "The growth-rate change is 100 times the log slope change, not the exact difference between the two exponentiated annual rates.",
  "State-clustered intervals do not account for unrestricted common national shocks or full ACS replicate-weight variance. Baseline composition weights are treated as fixed.",
  "The post trend is measured within 2021-2024 (2022-2024 in omit2021). It does not include the unobserved 2020 transition.",
  "A negative fitted 2024 departure does not prove that COVID caused a loss or that the extrapolated trend would have continued.")
writeLines(report, file.path(tables, "research_results.md"))
inputs <- c("data/raw/usa_00001.dta", "run_project.do", "code/00_setup.do",
  "code/01_build_data.do", "code/02_analysis.do", "code/03_figures.R")
checksums <- tools::md5sum(inputs)
manifest <- c(paste("Completed at:", format(Sys.time(), tz = "UTC", usetz = TRUE)),
  "Input and code MD5 checksums (integrity checks, not anonymization):",
  paste(names(checksums), unname(checksums)), "", capture.output(sessionInfo()))
writeLines(manifest, file.path(tables, "run_manifest.txt"))
writeLines("Figures and numerical report completed.", file.path(figures, "FIGURES_COMPLETE.txt"))
message("Saved six revised figures and research_results.md")
