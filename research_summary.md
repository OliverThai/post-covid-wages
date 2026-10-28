# Wage Growth After COVID

This project asks whether real earnings grew faster after COVID than before. Real earnings account for inflation, so they reflect purchasing power. I initially expected earnings to fall after COVID. After reviewing the results, I focused on whether growth differed from earlier patterns.

For example, younger workers may have already had faster earnings growth before the pandemic. Their faster growth afterward does not necessarily mean they benefited more from COVID. I compare 2016 to 2019 with 2021 to 2024 to see whether those patterns changed.

## Data and method

The data comes from the Census Bureau's American Community Survey, accessed through IPUMS. The main sample includes about 7.1 million records of employed people ages 25 to 54 with positive wage income. These are different people each year, not the same workers followed over time. There are no observations for 2020 or 2025 in this extract.

I adjust earnings to 2024 dollars using the Consumer Price Index, which measures changes in consumer prices. Earnings cover the previous 12 months, not hourly pay. Someone can earn more by working more hours or weeks without receiving a higher pay rate. [IPUMS income definition](https://usa.ipums.org/usa-action/variables/INCWAGE)

Stata handles the data and regressions, while R makes the figures. Survey weights account for how many people each respondent represents. I also keep the mix of ages, sexes, degree status and states the same as in 2019. This helps separate earnings growth from changes in who appears in the sample.

The regressions estimate annual growth before and after COVID, accounting for lasting earnings differences between states. They use log earnings to compare proportional changes, so the reported rates are not growth rates of the simple average dollar income. Separate comparisons between groups also account for changes shared within the same state and year.

## Results

| Group | Annual growth, 2016 to 2019 | Annual growth, 2021 to 2024 |
|---|---:|---:|
| All workers in the main sample | 1.04% | 0.79% |
| Ages 25 to 34 | 1.57% | 1.46% |
| Ages 35 to 44 | 0.86% | 0.51% |
| Ages 45 to 54 | 0.62% | 0.31% |
| Men | 0.98% | 0.56% |
| Women | 1.11% | 1.05% |
| Without a bachelor's degree | 1.30% | 0.98% |
| Bachelor's degree or higher | 0.66% | 0.51% |

Younger workers had faster growth in both periods, but their estimated annual growth slowed from 1.57% to 1.46%. Their stronger growth after COVID largely continued an earlier pattern. It does not show that individual young workers received larger raises because of COVID.

Age and education together show a different picture. Among workers ages 25 to 34 with at least a bachelor's degree, estimated growth increased from 1.03% to 1.50%. For workers of the same age without a bachelor's degree, it fell from 1.96% to 1.44%. An age comparison alone would hide this difference. However, degree holders are not necessarily recent graduates, and the data does not explain what caused the change.

Women's growth changed little, while men's slowed more. Workers without bachelor's degrees grew faster than degree holders in both periods. I also checked the statistical evidence, accounting for the greater chance of finding an apparent difference when making many comparisons. None of the 18 comparisons of changes after COVID was statistically significant after that adjustment. This does not prove the groups changed equally, but it limits how strongly I can interpret their differences.

Overall growth was positive during 2021 to 2024. However, the model places 2024 earnings about 4.8% below where they would have been if the earlier trend had continued. That is a gap from a projection, not a 4.8% decline from 2019. Earnings can recover without catching up to their earlier path.

## Limits and checks

I tested eight versions of the analysis, changing the years, treatment of high incomes, and which workers were included or how they were weighted. Estimated 2024 earnings remained below the projected earlier trend in every version, with gaps of about 2.8% to 5.6%.

The speed of recovery was less stable. Starting in 2022 instead of 2021 raised estimated annual growth from 0.79% to 1.49%. An alternative adjustment for when respondents received their income lowered it to about 0.14%. The choice of years and income adjustment therefore matters.

Only four years before COVID are available. Using 2016 to 2018 to predict 2019 already produces some error, and differences between groups were also changing before the pandemic. The earlier trend is therefore a comparison point, not a guaranteed prediction.

The project cannot separate COVID from everything else that happened during these years. There is no group completely unaffected by the pandemic. The main sample excludes people without jobs or wage income, so it misses part of the cost of losing work. National inflation figures do not capture local living costs, and the survey limits detail on very high incomes. The uncertainty shown in the figures does not cover every possible error in projecting a national trend.

## Conclusion

Faster earnings growth after COVID often continued an earlier pattern. Younger degree holders show a difference worth investigating, but the evidence does not establish why it happened. Overall earnings grew during the recovery while remaining below the projected earlier trend. These findings describe changes in earnings, not a proven earnings loss caused by COVID.

The [full results](outputs/tables/research_results.md) and [optional method details](README.md#method-details) provide the calculations and checks.
