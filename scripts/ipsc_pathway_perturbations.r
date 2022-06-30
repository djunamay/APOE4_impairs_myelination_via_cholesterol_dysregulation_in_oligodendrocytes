########## iPSC analysis related to extended data figure 8 #############
##########################################################################

# required packages
library(GSVA)
library(limma)
library(tidyr)
library(reshape2)
library(ggplot2)
source('../functions/pathway_analyses.r')

out_APOE4 = read.table('../data/iPSC_data/OPC_DEG_statistics.txt',  header = T)
pathways = readRDS('../data/other_analyses_outputs/pathways.rds')

# look at the cholesterol biosynthesis signature
data = readRDS('../data/other_analyses_outputs/cholesterol_analysis.rds')
biosynth_genes = data[['union_cholest_biosynth']]$genes

out = list()
out[['cholest_bio']] = biosynth_genes
out[['ATF6']] = c('HSP90B1', 'CALR', 'HSPA5', 'MBTPS1', 'ATF6')

curr = out_APOE4
curr = curr[!duplicated(curr$gene_id),]
rownames(curr) = curr$gene_id

l = list()
for(i in names(out)){
    df = na.omit(curr[out[[i]],])
    df$score = df$log2.fold_change.#) * -log10(df$q_value)
    df$grp = i
    l[[i]] = df[df$q_value<0.05,]
}

for(f in names(l)){
    x = l[[f]]$score
    names(x) = rownames(l[[f]])
    pdf(paste0('../plots/Extended_8/', f,'.pdf'), width = 3, height = 5)
    print(barplot(x[order(x)], las = 1, horiz = T))
    dev.off()
}

# also show myelin genes
genes = c('PLP1','OPALIN','PLLP','MYRF','MAG','MOG')
df = curr[genes,]
df$score = sign(df$log2.fold_change.) * -log10(df$q_value)
x = df$score
names(x) = rownames(df)

pdf('../plots/Extended_8/myelin_ipsc.pdf', width = 3, height = 3)
print(barplot(x[order(x)], las = 1, horiz = T))
dev.off()

# show lipid/cholesterol-related pathway enrichment
all_paths = pathways$pathways$all
norm_counts =  read.table('../data/iPSC_data/FPKM_table_OPC.txt', header = TRUE)
rownames(norm_counts) = norm_counts$gene
norm_counts$gene = NULL
rownames(out_APOE4) = out_APOE4$gene
shared = intersect(rownames(out_APOE4), rownames(norm_counts))
norm_counts = norm_counts[shared,]
rownames(norm_counts) = out_APOE4[shared,'gene']

# get the metadata
var = as.data.frame(ifelse(startsWith(colnames(norm_counts), 'E3'), 0, 1))
colnames(var) = c('APOE')

# show other key genes of interest
df = na.omit(norm_counts[c('SOAT1', 'SOAT2', 'CYP46A1'),])
df$gene = rownames(df)
x = melt(df)
x$variable = ifelse(startsWith(as.character(x$variable), 'E3'), 'APOE3', 'APOE4')
pdf('../plots/Extended_8/SOAT1_CYP_boxplots_ipsc.pdf', width = 3, height = 4)
ggplot(x, aes(x=variable, y=value, col = variable)) +
      geom_boxplot(width = .5) + geom_jitter() + facet_wrap(. ~ gene,  scales="free_y", nrow = 2) + theme_classic()
dev.off()
print('done.')


write.csv(out_APOE4[out_APOE4$gene%in%c('SOAT1', 'CYP46A1'),], '../data/other_analyses_outputs/SOAT1_CYP_stats_ipsc.csv')
