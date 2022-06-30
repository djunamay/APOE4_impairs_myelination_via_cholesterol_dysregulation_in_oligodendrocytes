
library('readxl')

## differential pathway results BP
data = readRDS('../data/other_analyses_outputs/pathway_scores.rds')
go_bp = do.call('rbind', data$GO_BP$fits_all)
# add pathway renaming
path_names_go = as.data.frame(read_excel('../data/supplementary_tables/all_path_names_go_renaming.xlsx', sheet = 'all_path_names_go_renaming'))
all_bp = merge(go_bp, path_names_go, by.x = 'names', by.y = 'name', all.x = T, all.y = T)
all_bp = all_bp[all_bp$P.Value<0.05,]

# add pathways to highlight
highlight = c('negative regulation of T cell receptor signaling pathway (GO:0050860)',
'positive regulation of response to cytokine stimulus (GO:0060760)',
'negative regulation of NIK/NF-kappaB signaling (GO:1901223)',
'positive regulation of tumor necrosis factor-mediated signaling pathway (GO:1903265)',
'I-kappaB kinase/NF-kappaB signaling (GO:0007249)',
'regulation of high voltage-gated calcium channel activity (GO:1901841)',
'regulation of voltage-gated calcium channel activity (GO:1901385)',
'positive regulation of tumor necrosis factor-mediated signaling pathway (GO:1903265)',
'positive regulation of excitatory postsynaptic potential (GO:2000463)',
'regulation of long-term neuronal synaptic plasticity (GO:0048169)',
'I-kappaB kinase/NF-kappaB signaling (GO:0007249)',
'ERK1 and ERK2 cascade (GO:0070371)',
'regulation of early endosome to late endosome transport (GO:2000641)',
'oligosaccharide-lipid intermediate biosynthetic process (GO:0006490)',
'negative regulation of amyloid-beta formation (GO:1902430)',
'DNA damage induced protein phosphorylation (GO:0006975)',
'intrinsic apoptotic signaling pathway in response to DNA damage by p53 class mediator (GO:0042771)',
'chaperone mediated protein folding requiring cofactor (GO:0051085)',
'chaperone-mediated protein complex assembly (GO:0051131)',
'regulation of cholesterol transport (GO:0032374)',
'cholesterol biosynthetic process (GO:0006695)',
'negative regulation of lipid storage (GO:0010888)',
'glycogen biosynthetic process (GO:0005978)',
'acetyl-CoA metabolic process (GO:0006084)')
all_bp$highlight = ifelse(all_bp$names%in%highlight, 'yes', 'no')
write.csv(all_bp, '../data/supplementary_tables/Supplementary_Table_S4.csv')

## differential pathway results APOE
go_apoe = do.call('rbind', data$APOE$fits_all)
# add pathway renaming
path_names_apoe = as.data.frame(read_excel('../data/supplementary_tables/all_path_names_go_renaming.xlsx', sheet = 'apoe_terms'))
all_apoe = merge(go_apoe, path_names_apoe, by.x = 'names', by.y = 'full name', x.all = T, y.all = T)
write.csv(all_apoe, '../data/supplementary_tables/Supplementary_Table_S5.csv')

## differential pathway results lipids
go_lipid = do.call('rbind', data$lipid$fits_all)
# add pathway renaming
path_names_lipids = as.data.frame(read_excel('../data/supplementary_tables/all_path_names_go_renaming.xlsx', sheet = 'lipid_terms'))
all_lipids = merge(go_lipid, path_names_lipids, by.x = 'names', by.y = 'full name', x.all = T, y.all = T)
write.csv(all_lipids, '../data/supplementary_tables/Supplementary_Table_S6.csv')

## CC lipidomics data
cc = read.csv('../data/supplementary_tables/cc_lipidomics_data.csv', check.names = F)
write.csv(cc, '../data/supplementary_tables/Supplementary_Table_S7.csv')

## PFC lipidomics data

## ipsc degs
degs = read.csv('../data/iPSC_data/OPC_DEG_statistics.txt')
write.csv(degs, '../data/supplementary_tables/Supplementary_Table_S12.csv')

## ipsc counts
# out_APOE4 = read.table('../data/iPSC_data/apoe3_v_apoe4_degs.csv', sep = ',', header = T)
# norm_counts = read.csv('../data/iPSC_data/ipsc_bulk_no_drug.csv')
# rownames(norm_counts) = norm_counts$X
# norm_counts$X = NULL
# rownames(out_APOE4) = out_APOE4$X
# out_APOE4 = out_APOE4[!duplicated(out_APOE4$res.gene_name),]
# shared = intersect(rownames(out_APOE4), rownames(norm_counts))
# norm_counts = norm_counts[shared,]
# rownames(norm_counts) = out_APOE4[shared,'res.gene_name']
#
# meta1 = read.table('../data/iPSC_data/ipsc_metadata.csv', sep = ',', header = F)
# var = as.character(meta1$V2)
# colnames(norm_counts) = var
norm_counts = read.csv('../data/iPSC_data/FPKM_table_OPC.txt')
write.csv(norm_counts,'../data/supplementary_tables/Supplementary_Table_S10.csv')

## pseudo bulk degs
degs = read.csv('../data/other_analyses_outputs/pseudo_bulk_degs_single_cell_all_celltypes.csv')
write.csv(degs, '../data/supplementary_tables/Supplementary_Table_S15.csv')

## wilcox degs for oligodendrocytes
out_all = as.data.frame(readRDS('../data/differentially_expressed_genes_data/oli_wilcox_results.rds'))
out_all$grp = 'APOE34 & APOE44 vs APOE33 (AD and nonAD)'
oli_ad = as.data.frame(readRDS('../data/differentially_expressed_genes_data/oli_wilcox_results_AD.rds'))
oli_ad$grp = 'APOE34 vs APOE33 (AD only)'
oli_nonad = as.data.frame(readRDS('../data/differentially_expressed_genes_data/oli_wilcox_results_noAD.rds'))
oli_nonad$grp = 'APOE34 vs APOE33 (nonAD only)'
all_data = rbind(out_all, oli_ad, oli_nonad)
write.csv(all_data, '../data/supplementary_tables/Supplementary_Table_S13.csv')

## nebula degs for oligodendrocytes
data = readRDS('../data/other_analyses_outputs/nebula_oli_degs.rds')
write.csv(data, '../data/supplementary_tables/Supplementary_Table_S14.csv')

# sc metadata
meta = read.csv('../data/single_cell_data/metadata_by_individual.csv')
names = c('X','age_death', 'amyloid', 'braaksc', 'ceradsc', 'cogdx', 'msex', 'nft', 'pmi', 'apoe_genotype')
write.csv(meta[,names], '../data/supplementary_tables/Supplementary_Table_S1.csv')

# expressed genes
expressed = readRDS('../data/single_cell_data/expressed_genes_per_celltype.rds')
out = list()
for(i in names(expressed)){
  df = as.data.frame(expressed[[i]])
  df$celltype = i
  colnames(df) = c('expressed_gene', 'celltype')
  out[[i]] = df
}
out = do.call('rbind', out)
write.csv(out, '../data/supplementary_tables/Supplementary_Table_S2.csv')

# averages
av = readRDS('../data/single_cell_data/individual_level_averages_per_celltype.rds')
out = list()
for(i in names(av)){
  df = as.data.frame(av[[i]])
  df$celltype = i
  out[[i]] = df
}
out = do.call('rbind', out)
write.csv(out, '../data/supplementary_tables/Supplementary_Table_S3.csv')

### pfc lipidomic data
df = read.csv('../data/other_analyses_outputs/pfc_lipidomics_data.csv')
write.csv(df, '../data/supplementary_tables/Supplementary_Table_S8a.csv')

data_subset = read.csv('../data/other_analyses_outputs/pfc_lipidomics_data_metadata.csv')
write.csv(data_subset, '../data/supplementary_tables/Supplementary_Table_S8b.csv')
