# Learning from Real World Data about Combinatorial Treatment Selection for COVID-19
# Overview
Here, we provide an analysis pipeline for the best combinatorial treatment selection in combination therapy:
1. Apply missing indicator method to handle missing values in the data;
2. Apply virtual multiple matching to adjust for possible confounding across multiple treatment groups (SMOTE is applied with the presence of class imbalance);
3. Conduct permutation test of overall treatment efficacy (i.e., sharp null hypothesis testing);
4. Determine patient stratification strategy with identified effect modifiers in a data-driven manner;
5. Perform multiple comparisons with the best to select the best drug combination strategy within each subgroup.

# Functions
