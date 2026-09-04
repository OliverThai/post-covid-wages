# 03_figures.R
# This file makes figures from the CSV files created in Stata.

args <- commandArgs(trailingOnly = TRUE)

if (length(args) > 0) {
  project <- args[1]
} else {
  project <- getwd()
}

setwd(project)

library(ggplot2)

overall <- read.csv("data/processed/overall_trends_for_r.csv")
remote <- read.csv("data/processed/remote_trends_for_r.csv")
race <- read.csv("data/processed/race_trends_for_r.csv")
age <- read.csv("data/processed/age_trends_for_r.csv")
gender <- read.csv("data/processed/gender_trends_for_r.csv")
college <- read.csv("data/processed/college_trends_for_r.csv")
industry <- read.csv("data/processed/industry_trends_for_r.csv")
state <- read.csv("data/processed/state_trends_for_r.csv")
ineq <- read.csv("data/processed/inequality_trends_for_r.csv")

state_names <- data.frame(
  stateicp = c(1, 2, 3, 4, 5, 6, 11, 12, 13, 14,
    21, 22, 23, 24, 25, 31, 32, 33, 34, 35,
    36, 37, 40, 41, 42, 43, 44, 45, 46, 47,
    48, 49, 51, 52, 53, 54, 56, 61, 62, 63,
    64, 65, 66, 67, 68, 71, 72, 73, 81, 82,
    83, 98),
  state_name = c("Connecticut", "Maine", "Massachusetts", "New Hampshire",
    "Rhode Island", "Vermont", "Delaware", "New Jersey", "New York",
    "Pennsylvania", "Illinois", "Indiana", "Michigan", "Ohio", "Wisconsin",
    "Iowa", "Kansas", "Minnesota", "Missouri", "Nebraska", "North Dakota",
    "South Dakota", "Virginia", "Alabama", "Arkansas", "Florida", "Georgia",
    "Louisiana", "Mississippi", "North Carolina", "South Carolina", "Texas",
    "Kentucky", "Maryland", "Oklahoma", "Tennessee", "West Virginia",
    "Arizona", "Colorado", "Idaho", "Montana", "Nevada", "New Mexico",
    "Utah", "Wyoming", "California", "Oregon", "Washington", "Alaska",
    "Hawaii", "Puerto Rico", "District of Columbia")
)

state <- merge(state, state_names, by = "stateicp")

overall$group <- "All workers"

remote$group <- ifelse(remote$remote_workable == 1,
  "More suited to remote work",
  "Less suited to remote work"
)

race$group <- ifelse(race$race == 1, "White",
  ifelse(race$race == 2, "Black",
    ifelse(race$race == 3, "American Indian",
      ifelse(race$race %in% c(4, 5, 6), "Asian/Pacific Islander",
        ifelse(race$race %in% c(8, 9), "Multiracial", "Other race")
      )
    )
  )
)

age$group <- ifelse(age$age_group == 1, "25-34",
  ifelse(age$age_group == 2, "35-44", "45-54")
)

gender$group <- ifelse(gender$sex == 1, "Men", "Women")

college$group <- ifelse(college$college == 1,
  "College degree",
  "No college degree"
)

p1 <- ggplot(overall, aes(x = year, y = real_annual_wage)) +
  geom_line(color = "#2563eb", linewidth = 1.1) +
  geom_point(color = "#2563eb", size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Post COVID Purchasing Power Wages",
    x = "Year",
    y = "Average annual wage income in 2024 dollars"
  ) +
  theme_minimal()

ggsave("outputs/figures/overall_wage_growth.png", p1, width = 8, height = 5, dpi = 300)

p2 <- ggplot(remote, aes(x = year, y = log_real_wage, color = group)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Post COVID Purchasing Power Wages by Remote Work Feasibility",
    x = "Year",
    y = "Average log real annual wage income",
    color = ""
  ) +
  theme_minimal()

ggsave("outputs/figures/log_wage_trends.png", p2, width = 8, height = 5, dpi = 300)

industry$period <- ifelse(industry$year > 2020, "After COVID", "Before COVID")
industry_avg <- aggregate(real_annual_wage ~ ind + period, data = industry, FUN = mean)

industry_pre <- subset(industry_avg, period == "Before COVID")
industry_post <- subset(industry_avg, period == "After COVID")

names(industry_pre)[3] <- "pre_real_wage"
names(industry_post)[3] <- "post_real_wage"

industry_growth <- merge(
  industry_pre[, c("ind", "pre_real_wage")],
  industry_post[, c("ind", "post_real_wage")],
  by = "ind"
)

industry_growth$wage_growth <- industry_growth$post_real_wage - industry_growth$pre_real_wage
industry_growth <- industry_growth[order(-industry_growth$wage_growth), ]
top_industry <- head(industry_growth, 10)
top_industry$ind <- as.character(top_industry$ind)

write.csv(top_industry, "outputs/tables/top_industry_growth.csv", row.names = FALSE)

p8 <- ggplot(top_industry, aes(x = reorder(ind, wage_growth), y = wage_growth)) +
  geom_col(fill = "#2563eb") +
  coord_flip() +
  labs(
    title = "Industries With the Biggest Post COVID Purchasing Power Growth",
    x = "Industry code",
    y = "Real wage income growth after COVID"
  ) +
  theme_minimal()

ggsave("outputs/figures/top_industry_growth.png", p8, width = 8, height = 5, dpi = 300)

state_level <- subset(state, year > 2020)
state_level <- aggregate(real_annual_wage ~ stateicp + state_name, data = state_level, FUN = mean)
names(state_level)[3] <- "post_covid_wage"
state_level <- state_level[order(-state_level$post_covid_wage), ]
top_state_level <- head(state_level, 15)

write.csv(top_state_level, "outputs/tables/top_state_wage_levels.csv", row.names = FALSE)

p10 <- ggplot(top_state_level, aes(x = reorder(state_name, post_covid_wage), y = post_covid_wage)) +
  geom_col(fill = "#7c3aed") +
  coord_flip() +
  labs(
    title = "States With the Highest Purchasing Power Wages After COVID",
    x = "State",
    y = "Average annual wage income in 2024 dollars"
  ) +
  theme_minimal()

ggsave("outputs/figures/state_wage_levels.png", p10, width = 8, height = 5, dpi = 300)

p12_data <- data.frame(
  year = c(ineq$year, ineq$year, ineq$year),
  wage = c(ineq$wage_p10, ineq$wage_p50, ineq$wage_p90),
  group = c(
    rep("P10: lower wage workers", nrow(ineq)),
    rep("P50: median workers", nrow(ineq)),
    rep("P90: higher wage workers", nrow(ineq))
  )
)

p12 <- ggplot(p12_data, aes(x = year, y = wage, color = group)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2) +
  geom_vline(xintercept = 2020, linetype = "dashed", color = "gray40") +
  labs(
    title = "Lower, Median, and Higher Purchasing Power Wage Trends",
    x = "Year",
    y = "Annual wage income in 2024 dollars",
    color = ""
  ) +
  theme_minimal()

ggsave("outputs/figures/p10_p50_p90_trends.png", p12, width = 8, height = 5, dpi = 300)

gender_small <- gender[, c("year", "real_annual_wage", "group")]
gender_small$type <- "Gender"

college_small <- college[, c("year", "real_annual_wage", "group")]
college_small$type <- "Education"

age_small <- age[, c("year", "real_annual_wage", "group")]
age_small$type <- "Age"

race_small <- race[, c("year", "real_annual_wage", "group")]
race_small$type <- "Race"

group_data <- rbind(gender_small, college_small, age_small, race_small)
group_data$period <- ifelse(group_data$year > 2020, "After COVID", "Before COVID")

group_avg <- aggregate(real_annual_wage ~ type + group + period, data = group_data, FUN = mean)

group_pre <- subset(group_avg, period == "Before COVID")
group_post <- subset(group_avg, period == "After COVID")

names(group_pre)[4] <- "pre_real_wage"
names(group_post)[4] <- "post_real_wage"

group_growth <- merge(
  group_pre[, c("type", "group", "pre_real_wage")],
  group_post[, c("type", "group", "post_real_wage")],
  by = c("type", "group")
)

group_growth$percent_growth <- 100 * (group_growth$post_real_wage - group_growth$pre_real_wage) / group_growth$pre_real_wage

write.csv(group_growth, "outputs/tables/percent_growth_by_group.csv", row.names = FALSE)

p13 <- ggplot(group_growth, aes(x = reorder(group, percent_growth), y = percent_growth)) +
  geom_col(fill = "#2563eb") +
  coord_flip() +
  facet_wrap(~type, scales = "free_y") +
  labs(
    title = "Post COVID Purchasing Power Wage Growth by Group",
    x = "",
    y = "Percent growth in 2024 dollars"
  ) +
  theme_minimal()

ggsave("outputs/figures/percent_growth_by_group.png", p13, width = 10, height = 7, dpi = 300)

message("Saved figures to outputs/figures/")
