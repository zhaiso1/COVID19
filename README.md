# Learning from Real World Data about Combinatorial Treatment Selection for COVID-19
# Overview
Here, we provide an analysis pipeline for the best combinatorial treatment selection in combination therapy:

-- apply missing indicator method to handle missing values in the data;

-- apply virtual multiple matching to adjust for possible confounding across multiple treatment groups (SMOTE is applied with the presence of class imbalance);

-- conduct permutation test of overall treatment efficacy (i.e., sharp null hypothesis testing);

[4] determine patient stratification strategy with identified effect modifiers in a data-driven manner;

[5] perform multiple comparisons with the best to select the best drug combination strategy within each subgroup.
