
Scripts/modules in this package are for correcting *tblastn* alignments.

##### The Problem 

BlAST alignments are based on a evolutionary model. It does not consider the intron and exon structures. The image below explaing the problem.

##### Solution

1. [Shortcut](https://github.com/ypandit/dictyScripts/blob/develop/lib/BLAST/Align/shortcut.pl)
	* Iterate over the featurs by ID
	* For each child feature of a give Parent, check of the length (end - start) < 2500

2. Other (MAKER)

	1. Parameters for BLAST command-line to consider
		* maximum intron length
		* e-value filter
		* simple repeat filtering (called dust filter in NCBI blast and seg filter in WUBLAST)
		* percent identity
		* HSP depth overlap filter (removes low complexity hits). Calculate the number of base pairs in the alignment on the hit then divide by the number of base pairs in the query alignment. If it is greater than 3, throw the hit out.
		* __Run repeat masker over the genome. Removes simple and complex repeats before running BLAST__

	2. Exonerate polishing
		* MAKER uses GI library (function --> `GI::polish_exonerate`)
