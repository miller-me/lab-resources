#################### Importing packages ####################
# Use install.packages("<package-name>") if you don't have them in your library
# Ex: install.packages("tidyr")
library(tidyr)
library(dplyr)
library(ggplot2)

# Follow the instructions for how to format your goseq results BEFORE loading them in this script #
#################### Reading results and creating dataframe for plotting ####################

# Edit the table file to your FORMATTED sGOseq enriched results (see Step 5: GO Analysis on GitHub)
data <- read.table("<formatted-goseq-results>.txt", header=TRUE)
# Taking the top 25 results only - edit this number if you want more or fewer plotted
plotting_data <- data[1:25,]
# Taking the -log10 of the false discovery rate (NOT pvalue)
# This is so the values are, e.g., 10 instead of 1e-10 or 0.0000000001
plotting_data$log10FDR <- -log10(plotting_data[,5])

#################### Creating bar chart using ggplot2 ####################
# This tells ggplot2 to use plotting_data, make the x-axis the log10FDR column,
# and format the y-axis to be in descending order of log10FDR with column colors by ontology (BP, CC, or MF),
# with other formatting including axis labels. For more info, see the ggplot2 documentation
plot <- ggplot(data = plotting_data, aes(x=log10FDR, y = reorder(term, log10FDR), fill = ontology)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_brewer(name="Ontology", palette="Dark2") +
  xlab("-log10(FDR)") + ylab("Term") +
  ggtitle("Top 25 Enriched GO Terms") + theme_bw()
# Save your plot as a png
ggsave("Top_25_GO.png")

#################### Excluding categories ####################
# Sometimes one GO category, often CC, can obscure the ones you're more interested in, namely BP and MF.
# In this example, I am excluding the cellular component (CC) category.
# This leaves just BP and MF to be plotted, with the same format as above.
# You can change 'CC' to 'BP' or 'MF' if needed.
# Taking only the rows that aren't CC (!= is "does not equal")
data_noCC <- data[data$ontology != 'CC',]
# Again only taking the top 25
data_noCC_plot <- data_noCC[1:25,]
# -log10 transforming FDR
data_noCC_plot$log10FDR <- -log10(data_noCC_plot[,5])
# Creating a new ggplot with the same formatting as above
plot <- ggplot(data = data_noCC_plot, aes(x=log10FDR, y = reorder(term, log10FDR), fill = ontology)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_brewer(name="Ontology", palette="Dark2") +
  xlab("-log10(FDR)") + ylab("Term") +
  ggtitle("Top 25 Enriched BP, MF Terms") + theme_bw()
# Saving plot as a png
ggsave("Top_25_GO_noCC.png")

#################### Including categories ####################
# It is possible to do the following by excluding two categories above,
# but to make it easier here's how you select just one. 
data_category <- data[data$ontology == 'BP',]
# Selecting top 25
category_plot <- data_category[1:25,]
# -log10 transforming FDR
category_plot$log10FDR <- -log10(category_plot[,5])
# Creating a new ggplot with the same formatting as above
# Change the ggtitle to the category you included
plot <- ggplot(data = category_plot, aes(x=log10FDR, y = reorder(term, log10FDR), fill = ontology)) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_brewer(name="Ontology", palette="Dark2") +
  xlab("-log10(FDR)") + ylab("Term") +
  ggtitle("Top 25 Enriched <category> Terms") + theme_bw()
# Saving plot as a png - edit the <category> to be what you included: CC, BP, or MF
ggsave("Top_25_GO_<category>.png")

#################### Done ####################
citation("ggplot2")
sessionInfo()