Week 5 Temporal analysis
================

## Getting to UFApps

Here are the instructions to get to UFApps - they are the same as last
week.  

Navigate to: <https://info.apps.ufl.edu>

Click on the orange “Login to UFApps” button in the upper right. This
link may also take you to the login page: <https://apps.ufl.edu/>

Log in using your GatorLink.

Click on “Apps” in the top menu bar. Scroll down to RStudio and click on
it to launch it. It may take a minute. Sometimes the connection will not
go through, but if you launch it again it works. If you consistently
can’t get through, reach out to Renata and she will try and figure out
another solution.

You may see a prompt to “set up secure access to your files”. There’s no
need to do this for this course, so go ahead and click Not Now.

## Setup

Select “File”, “New File”, and “RScript” in the top left menu bar. This
will give you a place to copy and paste code.

To run code, either highlight it and click the “Run” button in the top
right of the top left pane, or highlight it and press Ctrl + Enter.

Copy and paste this code to set up. You may get a notification about
copy-pasting stuff into the virtual session. Click OK and continue.

``` r
if(!dir.exists("Documents/EVS3000L")) {
dir.create("Documents/EVS3000L")
}
if(!dir.exists("Documents/EVS3000L/week5")) {
dir.create("Documents/EVS3000L/week5")
}
if(!dir.exists("Documents/EVS3000L/week5/data")) {
dir.create("Documents/EVS3000L/week5/data")
}
setwd("Documents/EVS3000L/week5/")

library(ggplot2)
library(dplyr)
```

## Download data

We will download data on a community of desert rodents located in
southeastern Arizona. This community has been monitored on a monthly
basis for over 40 years.

``` r
download.file("https://raw.githubusercontent.com/diazrenata/EVS3000L-fall2020/master/week5_temporal/data/rodent_data.csv", destfile = "data/rodent_data.csv")

rodent_data <- read.csv("data/rodent_data.csv", stringsAsFactors = F)
```

## Abundance and species richness data

We will look at how two aspects of this community have changed over the
past 40 years: the total number of species present, or species richness,
and the total number of *individuals* present, or total abundance.

**The questions in this section are for you to mull over as you work
through. You do not need to answer them in your submission. When we get
to analyzing specific species, please do answer those questions in your
submission.**

``` r
richness_plot <- ggplot(rodent_data, aes(x = year, y = richness)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ggtitle("Species richness over time")

richness_plot
```

![](week5_assignment_instructions_files/figure-gfm/plot%20abundance%20and%20richness-1.png)<!-- -->

``` r
abundance_plot <- ggplot(rodent_data, aes(x = year, y = total_abundance)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ggtitle("Total number of individuals over time")

abundance_plot
```

![](week5_assignment_instructions_files/figure-gfm/plot%20abundance%20and%20richness-2.png)<!-- -->

**What dynamics do you notice in these two time series?**

  - Do they look like they are increasing, decreasing, or not changing?
  - Are they tightly bounded around a consistent value, or variable? Is
    this consistent over time?
  - Does species richness (diversity) seem to match total abundance?

## Statistical analysis on abundance and species richness

While we can get a general intuition about what our data are saying by
simply looking at the plots, it’s helpful to use a statisical analysis
to test for dynamics that might not be obvious to the human eye, or to
test whether the patterns that we *think* we see are in fact
statistically distinguishable from randomness\! (Humans are very good at
coming up with patterns when presented with data, even if the data is in
fact random noise).

Here, we will use ordinary **linear models** to estimate the slope, or
rate of change, for species richness and total abundance over time. We
will also test whether the slope is **statistically significant**, or if
our model is unable to detect a slope that is statistically different
from 0. Linear models are a common entry point for statistical analysis,
especially of temporal data (although there are, not surprisingly, many
variations that can get considerably more nuanced and more complex\!)

### Species richness

Let’s fit a linear model to estimate how species richness has changed
over time:

``` r
richness_lm <- lm(richness ~ year, data = rodent_data)

summary(richness_lm)
```

    ## 
    ## Call:
    ## lm(formula = richness ~ year, data = rodent_data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -51.978 -21.666  -1.409  21.850  74.327 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)
    ## (Intercept) 1236.8553   889.4375   1.391    0.173
    ## year          -0.5648     0.4448  -1.270    0.212
    ## 
    ## Residual standard error: 30.07 on 36 degrees of freedom
    ## Multiple R-squared:  0.04287,    Adjusted R-squared:  0.01628 
    ## F-statistic: 1.612 on 1 and 36 DF,  p-value: 0.2123

R has told us lots of things about our linear model. We’ll focus on the
**statisical significance**, or p-value, of the model and the
**estimated slope**.

The **p-value** for this model is .212. Conventionally, if the p-value
for a model is greater than .05, we **do not consider the model
statistically significant**. In this case, this means we are not
confident that our data have a slope that is different from 0.

We will still note the estimated slope. It is the “Estimate” for “year”
in the summary output above. For this model, is -.56. However, because
the p-value is much larger than .05, we can’t be sure that the slope
isn’t really 0.

Another way to think of this is that the confidence intervals for the
estimate of slope overlap 0:

``` r
confint(richness_lm)
```

    ##                   2.5 %       97.5 %
    ## (Intercept) -567.007604 3040.7182940
    ## year          -1.466975    0.3373114

So, we cannot say with confidence that species richness is changing
systematically, either up or down.

**Does this match your intuition from looking at the plot?**

### Total abundance

Let’s repeat this analysis, using total abundance.

``` r
abund_lm <-  lm(total_abundance ~ year, data = rodent_data)

summary(abund_lm)
```

    ## 
    ## Call:
    ## lm(formula = total_abundance ~ year, data = rodent_data)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -1365.34  -502.09   -59.11   364.65  2391.77 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)  
    ## (Intercept) -47861.61   22318.85  -2.144   0.0388 *
    ## year            24.70      11.16   2.213   0.0333 *
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 754.5 on 36 degrees of freedom
    ## Multiple R-squared:  0.1198, Adjusted R-squared:  0.09532 
    ## F-statistic: 4.898 on 1 and 36 DF,  p-value: 0.03331

``` r
confint(abund_lm)
```

    ##                    2.5 %      97.5 %
    ## (Intercept) -93126.33617 -2596.87840
    ## year             2.06677    47.34214

In contrast to the species richness model:

  - The p-value for total abundance is .033, which is less than .05\!
  - The confidence intervals for the slope do not overlap 0
  - The estimate for the slope is 24.7

We therefore have greater confidence that our estimated slope reflects a
real signal in the data, and is not random noise. In this case, the
slope is positive, meaning that total abundance has increased over the
course of the time series.

**How does this correspond to your intuition from the plot?**

## Working with a particular species

Now we will look at some of the particular species we have been
monitoring at this site. We will work through an analysis for one
species, and then you will select another species to analyze on your
own.

**Please answer the questions in this section in a Word or text document
and submit them along with your results.** The questions you should
answer are also collected here:

### Banner-tailed kangaroo rats

*Dipodomys spectabilis*, or the banner-tailed kangaroo rat, is one of
our most readily identified study species. It’s the largest kangaroo rat
we find at our site - it’s about the size of a sweet potato, not
counting the tail. It’s called a banner-tailed kangaroo rat because its
tail has a magnificient white tuft that looks like a banner behind it.
It’s an important player in our system, because it eats the seeds of
many of the desert plants, and it is behaviorally dominant to other,
smaller, rodents. Wikipedia has some good images and natural history:
<https://en.wikipedia.org/wiki/Banner-tailed_kangaroo_rat>

Here we will plot how the abundance of *D. spectabilis* has changed over
time:

``` r
bannertail_plot <- ggplot(rodent_data, aes(x = year, y = bannertail)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  ggtitle("Bannertail kangaroo rats over time")

bannertail_plot
```

**What dynamics stand out to you**? Changes in abundance over time?
Steadiness, or variability?

Let’s fit a linear model to get a more quantitative description of how
bannertail abundance has changed over time:

``` r
bannertail_lm <- lm(bannertail ~ year, data = rodent_data)

summary(bannertail_lm)

confint(bannertail_lm)
```

From these results, answer these questions as part of your submission:

  - What is the slope estimate for the bannertails?
  - Is this model statistically significant? (p value \< .05, or the
    confidence intervals for the slope estimate **not** overlapping 0)
  - Does this fit with your intuition from the plot?
  - If you got these results for a species you were monitoring, what
    would you think? What questions or studies would it prompt you to
    look into further?

### Choose your own species

Now you will do the same analysis as we’ve done for species richness,
abundance, and bannertail kangaroo rats with a species of your choosing
from our site. Here are your options:

  - Merriam’s kangaroo rat, *Dipodomys merriami*. Merriam’s are smaller
    than bannertails - about the size (and shape) of two ping-pong balls
    stuck together and covered in fur. They also lack the banner-tail,
    although they do have tail tufts. Wikipedia:
    <https://en.wikipedia.org/wiki/Merriam%27s_kangaroo_rat>
  - Desert pocket mouse, *Chaetodipus penicillatus*. While the kangaroo
    rats hop around on their back two legs, like little kangaroos, the
    pocket mice are quadripedal - more like your sterotypical mouse.
    Like kangaroo rats, they have cheek pouches that they use to carry
    seeds back to their underground burrows. *C. penicillatus* is the
    smallest of the species included here. They vary in size from a
    little bigger than a tube of Chapstick to closer to two tubes of
    Chapstick. Wikipedia:
    <https://en.wikipedia.org/wiki/Desert_pocket_mouse>
  - Bailey’s pocket mouse, *Chaetodipus baileyi*. Bailey’s appear very
    similar to desert pocket mice, but about 2/3 larger. Wikipedia:
    <https://en.wikipedia.org/wiki/Bailey%27s_pocket_mouse>

To run the analysis using your chosen species, replace `bannertail` in
the following lines of code with `merriami`, `pocketmouse`, or `baileys`
depending on which species you’d like to use.

First, plot how your species has changed over time:

``` r
my_species_plot <- ggplot(rodent_data, aes(x = year, y = bannertail)) + # Replace bannertail with your species
  geom_point() +
  geom_line() +
  theme_bw() +
  ggtitle("My species' abundance over time")

my_species_plot
```

What do the dynamics for your species *look like* to you? Would you
describe them as increasing, decreasing, random, or something else?

Now fit a linear model to quantitively describe the dynamics:

``` r
my_species_lm <- lm(bannertail ~ year, data = rodent_data) # Replace bannertail with your species

summary(my_species_lm)

confint(my_species_lm)
```

  - Is this model statistically significant?
  - If it is, what is the slope estimate? Is this species increasing or
    decreasing over time?
  - Does this species’ dynamics match or differ from the bannertail
    kangaroo rats?
  - If you were monitoring this species, what questions would these
    results inspire?

## Reflection questions

  - How do the dynamics of individual species correspond to the overall
    dynamics of species richness and total abundance?
  - In your opinion, do the linear models tend to match your sense of
    the dynamics you see from the plots? Are there patterns you see that
    the models don’t seem to capture?
  - What questions do these results inspire?
  - What additional data or information could you imagine gathering that
    would help you better understand these results?

## Results to submit

Save your plots and results with this code:

``` r
jpeg('species_dynamics.jpg')
plot(my_species_plot)
dev.off()

saveRDS(my_species_lm, file = "species_lm.Rds")
```

Submit `species_dynamics.jpg` and `species_lm.Rds` to eLearning via file
upload, along with a Word or text document with your answers to the
questions. To help you keep track of the questions, the ones you should
answer in your submission are listed here:
