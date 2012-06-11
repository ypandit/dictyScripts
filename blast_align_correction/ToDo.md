
### Correcting BLAST (*tblastn*) alignment:

(*from MAKER mailing list*)

1. Parameters for BLAST command-line to consider
	* maximum intron length
	* e-value filter
	* simple repeat filtering (called dust filter in NCBI blast and seg filter in WUBLAST)
	* percent identity
	* HSP depth overlap filter (removes low complexity hits). Calculate the number of base pairs in the alignment on the hit then divide by the number of base pairs in the query alignment. If it is greater than 3, throw the hit out.

	* __Run repeat masker over the genome. Removes simple and complex repeats before running BLAST__

2. Exonerate polishing
	* MAKER uses GI library (function --> GI::polish_exonerate)

