# Dockerfile for Diversity and Differential Abundance Analysis
FROM rocker/r-ver:4.1.0

# Install R packages
RUN R -e "install.packages(c('vegan', 'ggplot2', 'DESeq2', 'edgeR'), repos='http://cran.rstudio.com/')"

# Copy analysis scripts
COPY diversity_analysis.R /scripts/diversity_analysis.R
COPY differential_abundance_analysis.R /scripts/differential_abundance_analysis.R

# Set the entrypoint (will be overridden in WDL)
ENTRYPOINT ["Rscript"]
