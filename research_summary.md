# Earnings Growth After COVID Relative to Earlier Trends

## Research question

Did real annual earnings grow faster after COVID than they had beforehand? Comparing groups only after COVID can be misleading. Younger workers may have had faster earnings growth than older workers even before the pandemic. The relevant question is whether that difference changed.

This revision therefore compares growth during 2016-2019 with growth during 2021-2024. It also asks where earnings stood in 2024 relative to a continuation of each group's earlier trend. The analysis is exploratory. These questions were developed while reviewing weaknesses in the earlier project, not specified before any results were observed.

## Data and approach

The data comes from the American Community Survey through IPUMS. The main sample includes 7,057,956 observations of employed people ages 25-54 with positive wage and salary income. The sample does not depend on matching occupations to a remote-work score, and high earners are not removed from the main analysis. Missing-income codes are excluded explicitly.

Earnings are adjusted to 2024 dollars using annual national CPI-U. They measure pretax wage and salary income over the preceding 12 months, not hourly pay or earnings from a fixed calendar year. Higher earnings may reflect changes in working hours as well as pay. The data contains different people each year and does not measure individual promotions or career progression. [IPUMS income documentation](https://usa.ipums.org/usa-action/variables/INCWAGE)

To limit changes caused by the mix of respondents, the main series holds the joint distribution of exact age, sex, bachelor's degree status and state at its 2019 composition. All of these main-sample cells are observed in every included year. A separate specification also fixes broad race composition; it covers at least 98.2% of the eligible weighted population in each year.

The outcome is average log real annual earnings. Reported growth rates describe the geometric mean, obtained by exponentiating the average log, rather than the arithmetic dollar mean. For each group, the model estimates a linear trend before COVID, a level difference in 2021, and a change in growth thereafter. State effects account for persistent differences in earnings levels across states.

I also compare changes between groups while including state-year effects. This removes shocks shared by groups within the same state and year, but does not remove shocks that affect groups differently. The figures include uncertainty intervals clustered by state. These intervals do not capture every source of uncertainty about a national shock or a projected trend.

## Results

| Group | Annual growth, 2016-2019 | Annual growth, 2021-2024 |
|---|---:|---:|
| All employed earners | 1.04% | 0.79% |
| Ages 25-34 | 1.57% | 1.46% |
| Ages 35-44 | 0.86% | 0.51% |
| Ages 45-54 | 0.62% | 0.31% |
| Men | 0.98% | 0.56% |
| Women | 1.11% | 1.05% |
| Below bachelor's degree | 1.30% | 0.98% |
| Bachelor's degree or higher | 0.66% | 0.51% |

Younger workers had faster growth than older workers in both periods. Their estimated growth rate did not accelerate after COVID. This changes the earlier interpretation: stronger post-period growth among younger workers is not, by itself, evidence of an unusual benefit from the pandemic.

The age-by-degree comparison adds a useful distinction. Among people ages 25-34 with at least a bachelor's degree, estimated annual growth rose from 1.03% to 1.50%. Among people of the same age without a bachelor's degree, it fell from 1.96% to 1.44%. The data identifies degree holders, not recent graduates, and these are different samples of people across years. The apparent acceleration for younger degree holders remains exploratory; its relative comparison with older degree holders does not survive the adjustment for multiple tests.

Women's estimated annual growth changed little, while men's growth slowed more. Workers without bachelor's degrees continued to grow faster than degree holders, but they had already been growing faster before COVID. These point estimates describe differences worth investigating, not proven effects of sex, education, or COVID. None of the 18 post-period relative contrasts meets a 5% threshold after Holm adjustment across those comparisons.

The main fitted 2024 earnings level was about 4.83% below a continuation of the 2016-2019 trend. That does not mean earnings fell 4.83% from 2019. It means they were below a particular projected path. A recovery can produce positive annual growth while still leaving earnings below an earlier trend.

## How much depends on the choices?

The estimated overall 2024 shortfall remains negative across all eight specifications, ranging from about 2.81% to 5.60%. These checks change composition adjustment, the upper-income treatment, employment restrictions, income timing, or the years used for the trend.

The estimated post-period growth rate is less stable. Excluding 2021 raises it from 0.79% to 1.49%, consistent with a stronger rebound after 2022. Applying the alternative ACS income timing adjustment reduces it to about 0.14%. The project therefore should not present a single growth rate as independent of the chosen period or income convention. IPUMS notes that the extra timing adjustment is itself imperfect and does not recommend it as a universal correction. [IPUMS timing guidance](https://usa.ipums.org/usa/acsincadj.shtml)

The earlier trends are not perfectly stable either. A model fitted to 2016-2018 underpredicts 2019 overall mean log earnings by about 0.64%. The group-year diagnostics also show earlier changes in the age and degree gaps. These checks make the projected path a useful benchmark, but not a known account of what would have happened without COVID.

## What can be said about causality?

The data does not provide an untreated group for the pandemic as a whole. State-year effects help account for shared local conditions in relative comparisons, but cannot separate COVID from every other change that affected groups differently. Four pre-period observations are not enough to establish a reliable long-run counterfactual.

A causal extension would require a more specific treatment and a defensible source of variation, such as a clearly defined policy change with suitable comparison areas. That would be a different research design requiring additional data and checks. This project does not relabel a trend projection as a causal estimate.

Other limitations remain. Restricting the main sample to employed positive earners leaves out people who lost employment or had no wage income. National CPI does not adjust for local living costs. Public income records are topcoded, and the data does not fully separate working time from pay. Composition adjustment covers observed characteristics, not every difference between workers. State-clustered intervals treat the 2019 composition weights as fixed and do not implement the full ACS replicate-weight variance design.

## Conclusion

The revised analysis shows why post-COVID growth should be compared with earlier growth. Younger workers' faster earnings growth largely continued an existing pattern. Younger degree holders show a different descriptive pattern, but the relative evidence is not strong enough to claim a causal advantage.

The most consistent result across the tested specifications is that fitted 2024 real earnings remained below the continuation of the earlier trend, even as earnings recovered. The size of that gap and the speed of recovery depend on the assumptions. This makes the project useful as a transparent description of earnings trends and their sensitivity, rather than a claim that COVID caused a precisely measured loss.

The [generated results report](outputs/tables/research_results.md), [research design](research_design.md), and accompanying figures provide the estimates, checks, and assumptions behind these conclusions. They replace the earlier remote-work and simple before/after findings.
