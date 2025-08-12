library(seqinr)
library(bold)

fasta_file <- "raw_data/known_set.fasta"
fasta_data <- read.fasta(file = fasta_file, as.string = TRUE, forceDNAtolower = FALSE)
seqs <- sapply(fasta_data, function(x) toupper(getSequence(x, as.string = TRUE)))
ids <- names(fasta_data)

res <- bold_identify(sequences = seqs, db = "COX1_SPECIES")
# res is your list returned by bold_identify()
# Keep: seq name, ID, taxonomicidentification, similarity (max per seq)

# res is the named list you showed (one data frame per sequence)

best_per_taxon <- do.call(rbind, lapply(names(res), function(nm) {
  df <- res[[nm]]
  if (is.null(df) || nrow(df) == 0) {
    return(data.frame(
      seq_name = nm, ID = NA, taxonomicidentification = NA, similarity = NA,
      stringsAsFactors = FALSE
    ))
  }
  # Coerce similarity safely (handles "0.9984" or "99.84")
  sim <- suppressWarnings(as.numeric(gsub(",", ".", df$similarity)))
  if (mean(sim, na.rm = TRUE) > 1.1) sim <- sim/100
  df$sim_num <- sim

  # Order by similarity desc so dedup keeps the max per taxon
  df <- df[order(-df$sim_num), ]

  # Keep the first row per unique taxon (i.e., the max similarity for that taxon)
  keep_cols <- intersect(c("ID","taxonomicidentification","similarity"), names(df))
  best <- df[!duplicated(df$taxonomicidentification), keep_cols, drop = FALSE]

  # Add the sequence name
  best$seq_name <- nm
  # Reorder columns
  best <- best[, c("seq_name","ID","taxonomicidentification","similarity"), drop = FALSE]
  best
}))


# Save as CSV without quotes
write.table(
  best_per_taxon,
  file = "bold_best_per_taxon_per_seq.csv",
  sep = ",",
  row.names = FALSE,
  quote = FALSE
)


