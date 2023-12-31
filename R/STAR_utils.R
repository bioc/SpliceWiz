#' STAR wrappers for building reference for STAR, and aligning RNA-sequencing
#'
#' These STAR helper / wrapper functions allow users to (1) create a STAR
#' genome reference (with or without GTF), (2) align one or more RNA-seq
#' samples, and (3) calculate regions of low mappability. STAR references
#' can be created using one-step (genome and GTF), or two-step (genome first,
#' then on-the-fly with injected GTF) approaches.
#'
#' @details
#' **Pre-requisites**
#'
#' `STAR_buildRef()` and `STAR_buildGenome()` require prepared genome
#' and gene annotation reference retrieved using [getResources], which is run
#' internally by [buildRef]
#'
#' `STAR_loadGenomeGTF()` requires the above, and additionally a STAR genome 
#' created using `STAR_buildGenome()` 
#' 
#' `STAR_alignExperiment()`, `STAR_alignReads()`, and `STAR_mappability()`: 
#' requires a `STAR` genome, which can be built using `STAR_buildRef()` or
#' `STAR_buildGenome()` followed by `STAR_loadGenomeGTF()`
#'
#' **Function Description**
#'
#' For `STAR_buildRef`: this function will create a `STAR` genome reference 
#'   using the same genome FASTA and gene annotation GTF used to create
#'   the SpliceWiz reference. Optionally, it will run `STAR_mappability`
#'   if `also_generate_mappability` is set to `TRUE`
#'
#' For `STAR_alignExperiment`: aligns a set of FASTQ or paired FASTQ files
#'   using the given
#'   `STAR` genome using the `STAR` aligner.
#'   A data.frame specifying sample names and corresponding FASTQ files are
#'   required
#'
#' For `STAR_alignReads`: aligns a single or pair of FASTQ files to the given
#'   `STAR` genome using the `STAR` aligner.
#' 
#' For `STAR_buildGenome`: Creates a STAR genome reference, using ONLY the
#'   FASTA file used to create the SpliceWiz reference. This allows users to
#'   create a single STAR reference for use with multiple transcriptome (GTF)
#'   references (on different occasions). Optionally, it will run 
#'   `STAR_mappability` if `also_generate_mappability` is set to `TRUE`
#'
#' For `STAR_loadGenomeGTF`: Creates an "on-the-fly" STAR genome, injecting GTF
#' from the given SpliceWiz `reference_path`, setting `sjdbOverhang` setting,
#' and (optionally) any spike-ins via the `extraFASTA` parameter.
#' This allows users to create a single STAR reference for use with multiple 
#' transcriptome (GTF) references, with different sjdbOverhang settings,
#' and/or spike-ins (on different occasions or for different projects).
#'
#' For `STAR_mappability`: this function will first
#'   will run [generateSyntheticReads], then use the given `STAR` genome to 
#'   align the synthetic reads using `STAR`. The aligned BAM file will then be
#'   processed using [calculateMappability] to calculate the
#'   lowly-mappable genomic regions,
#'   producing the `MappabilityExclusion.bed.gz` output file.
#'
#' @param reference_path The path to the reference.
#'    [getResources] must first be run using this path
#'    as its `reference_path`
#' @param STAR_ref_path (Default - the "STAR" subdirectory under
#'    `reference_path`) The directory containing the STAR reference to be
#'    used or to contain the newly-generated STAR reference
#' @param also_generate_mappability Whether `STAR_buildRef()` and 
#'   `STAR_buildGenome()` also calculate Mappability Exclusion regions.
#' @param map_depth_threshold (Default `4`) The depth of mapped reads
#'   threshold at or below which Mappability exclusion regions are defined. See
#'   [Mappability-methods]. Ignored if `also_generate_mappability = FALSE`
#' @param sjdbOverhang (Default = 100) A STAR setting indicating the length of
#'   the donor / acceptor sequence on each side of the junctions. Ideally equal
#'   to (mate_length - 1). See the STAR aligner manual for details.
#' @param n_threads The number of threads to run the STAR aligner.
#' @param additional_args A character vector of additional arguments to be
#'   parsed into STAR. See examples below.
#' @param Experiment A two or three-column data frame with the columns denoting
#'   sample names, forward-FASTQ and reverse-FASTQ files. This can be
#'   conveniently generated using [findFASTQ]
#' @param BAM_output_path The path under which STAR outputs the aligned BAM
#'   files. In `STAR_alignExperiment()`, STAR will output aligned
#'   BAMS inside subdirectories of this folder, named by sample names. In
#'   `STAR_alignReads()`, STAR will output directly into this path.
#' @param trim_adaptor The sequence of the Illumina adaptor to trim via STAR's
#'   `--clip3pAdapterSeq` option
#' @param two_pass Whether to use two-pass mapping. In
#'   `STAR_alignExperiment()`, STAR first-pass will align every sample
#'   to generate a list of splice junctions but not BAM files. The junctions
#'   are then given to STAR to generate a temporary genome containing
#'   information about novel junctions, thereby improving novel junction
#'   detection. In `STAR_alignReads()`, STAR will use `--twopassMode Basic`
#' @param fastq_1,fastq_2 In STAR_alignReads: character vectors giving the
#'   path(s) of one or more FASTQ (or FASTA) files to be aligned.
#'   If single reads are to be aligned, omit \code{fastq_2}
#' @param memory_mode The parameter to be parsed to \code{--genomeLoad}; either
#'   \code{NoSharedMemory} or \code{LoadAndKeep} are used.
#' @param overwrite (default `FALSE`) If BAM file(s) already exist from a
#'   previous run, whether these would be overwritten.
#' @param sparsity (default `1`) Sets STAR's `--genomeSAsparseD` option. For
#'   human (and mouse) genomes, set this to `2` to allow STAR to perform
#'   genome generation and mapping using < 16 Gb of RAM, albeit with slightly
#'   lower mapping rate (~ 0.1% lower, according to STAR's author). Setting
#'   this to higher values is experimental (and not tested)
#' @param overwrite (default `FALSE`)
#'   For `STAR_buildRef`, `STAR_buildGenome` and `STAR_loadGenomeGTF` - 
#'     if STAR genome already exists, should it be overwritten.
#'   For `STAR_alignExperiment` and `STAR_alignReads` - if BAM file already
#'     exists, should it be overwritten.
#' @param ... Additional arguments to be parsed into
#'   \code{generateSyntheticReads()}. See \link{Mappability-methods}.
#' @examples
#' # 0) Check that STAR is installed and compatible with SpliceWiz
#'
#' STAR_version()
#' \dontrun{
#'
#' # The below workflow illustrates
#' # 1) Getting the reference resource
#' # 2) Building the STAR Reference, including Mappability Exclusion calculation
#' # 3) Building the SpliceWiz Reference, using the Mappability Exclusion file
#' # 4) Aligning (a) one or (b) multiple raw sequencing samples.
#'
#'
#' # 1) Reference generation from Ensembl's FTP links
#'
#' FTP <- "ftp://ftp.ensembl.org/pub/release-94/"
#'
#' getResources(
#'     reference_path = "Reference_FTP",
#'     fasta = paste0(FTP, "fasta/homo_sapiens/dna/",
#'         "Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"),
#'     gtf = paste0(FTP, "gtf/homo_sapiens/",
#'         "Homo_sapiens.GRCh38.94.chr.gtf.gz")
#' )
#'
#' # 2) Generates STAR genome within the SpliceWiz reference. Also generates
#' # mappability exclusion gzipped BED file inside the "Mappability/" sub-folder
#'
#' STAR_buildRef(
#'     reference_path = "Reference_FTP",
#'     STAR_ref_path = file.path("Reference_FTP", "STAR"),
#'     n_threads = 8,
#'     also_generate_mappability = TRUE
#' )
#'
#' # 2a) Generates STAR genome of the example SpliceWiz genome.
#' #     This demonstrates using custom STAR parameters, as the example 
#' #     SpliceWiz genome is ~100k in length, 
#' #     so --genomeSAindexNbases needs to be
#' #     adjusted to be min(14, log2(GenomeLength)/2 - 1)
#'
#' getResources(
#'     reference_path = "Reference_chrZ",
#'     fasta = chrZ_genome(),
#'     gtf = chrZ_gtf()
#' )
#'
#' STAR_buildRef(
#'     reference_path = "Reference_chrZ",
#'     STAR_ref_path = file.path("Reference_chrZ", "STAR"),
#'     n_threads = 8,
#'     additional_args = c("--genomeSAindexNbases", "7"),
#'     also_generate_mappability = TRUE
#' )
#'
#' # 3) Build SpliceWiz reference using the newly-generated 
#' #    Mappability exclusions
#'
#' #' NB: also specifies to use the hg38 nonPolyA resource
#'
#' buildRef(reference_path = "Reference_FTP", genome_type = "hg38")
#'
#' # 4a) Align a single sample using the STAR reference
#'
#' STAR_alignReads(
#'     fastq_1 = "sample1_1.fastq", fastq_2 = "sample1_2.fastq",
#'     STAR_ref_path = file.path("Reference_FTP", "STAR"),
#'     BAM_output_path = "./bams/sample1",
#'     n_threads = 8
#' )
#'
#' # 4b) Align multiple samples, using two-pass alignment
#'
#' Experiment <- data.frame(
#'     sample = c("sample_A", "sample_B"),
#'     forward = file.path("raw_data", c("sample_A", "sample_B"),
#'         c("sample_A_1.fastq", "sample_B_1.fastq")),
#'     reverse = file.path("raw_data", c("sample_A", "sample_B"),
#'         c("sample_A_2.fastq", "sample_B_2.fastq"))
#' )
#'
#' STAR_alignExperiment(
#'     Experiment = Experiment,
#'     STAR_ref_path = file.path("Reference_FTP", "STAR"),
#'     BAM_output_path = "./bams",
#'     n_threads = 8,
#'     two_pass = TRUE
#' )
#'
#' # - Building a STAR genome (only) reference, and injecting GTF as a
#' #   subsequent step
#' #
#' #   This is useful for users who want to create a single STAR genome, for
#' #   experimentation with different GTF files.
#' #   It is important to note that the chromosome names of the genome (FASTA)
#' #   file and the GTF file needs to be identical. Thus, Ensembl and Gencode
#' #   GTF files should not be mixed (unless the chromosome GTF names have
#' #   been fixed)
#'
#' # - also set sparsity = 2 to build human genome so that it will fit in
#' #   16 Gb RAM. NB: this step's RAM usage can be set using the
#' #   `--limitGenomeGenerateRAM` parameter
#'
#' STAR_buildGenome(
#'     reference_path = "Reference_FTP",
#'     STAR_ref_path = file.path("Reference_FTP", "STAR_genomeOnly"),
#'     n_threads = 8, sparsity = 2,
#'     additional_args = c("--limitGenomeGenerateRAM", "16000000000")
#' )
#'
#' # - Injecting a GTF into a genome-only STAR reference
#' #
#' #   This creates an on-the-fly STAR genome, using a GTF file 
#' #   (derived from a SpliceWiz reference) into a new location.
#' #   This allows a single STAR reference to use multiple GTFs
#' #   on different occasions.
#'
#' STAR_new_ref <- STAR_loadGenomeGTF(
#'     reference_path = "Reference_FTP",
#'     STAR_ref_path = file.path("Reference_FTP", "STAR_genomeOnly"),
#'     STARgenome_output = file.path(tempdir(), "STAR"),
#'     n_threads = 4,
#'     sjdbOverhang = 100
#' )
#' 
#' # This new reference can then be used to align your experiment:
#'
#' STAR_alignExperiment(
#'     Experiment = Experiment,
#'     STAR_ref_path = STAR_new_ref,
#'     BAM_output_path = "./bams",
#'     n_threads = 8,
#'     two_pass = TRUE
#' )
#'
#' # Typically, one should `clean up` the on-the-fly STAR reference (as it is
#' #   large!). If it is in a temporary directory, it will be cleaned up
#' #   when the current R session ends; otherwise this needs to be done manually:
#'
#' unlink(file.path(tempdir(), "STAR"), recursive = TRUE)
#'
#' }
#' @name STAR-methods
#' @aliases
#' STAR_buildRef STAR_alignExperiment STAR_alignReads
#' @seealso
#' [Build-Reference-methods] [findSamples] [Mappability-methods]\cr\cr
#' [The latest STAR documentation](https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf)
#' @md
NULL

#' @describeIn STAR-methods Checks whether STAR is installed, and its version
#' @return For `STAR_version()`: The STAR version
#' @export
STAR_version <- function() .validate_STAR_version(type = "message")

#' @describeIn STAR-methods Creates a STAR genome reference, using both FASTA
#'   and GTF files used to create the SpliceWiz reference
#' @return For `STAR_buildRef()`: None
#' @export
STAR_buildRef <- function(
        reference_path,
        STAR_ref_path = file.path(reference_path, "STAR"),
        n_threads = 4,
        overwrite = FALSE,
        sjdbOverhang = 100,
        sparsity = 1,
        also_generate_mappability = FALSE,
        map_depth_threshold = 4,
        additional_args = NULL,
        ...
) {
    .validate_reference_resource(reference_path)
    .validate_STAR_version()
    .validate_path(STAR_ref_path)
    # Unzip reference files
    genome.fa <- .STAR_get_FASTA(reference_path)
    transcripts.gtf <- .STAR_get_GTF(reference_path)
    # Build STAR using defaults
    .log(paste("Building STAR genome from", reference_path), type = "message")

    args <- NULL
    if (!("--runMode" %in% additional_args)) args <- c(
        "--runMode", "genomeGenerate")

    if(dir.exists(STAR_ref_path)) {
        if(
            file.exists(file.path(STAR_ref_path, "genomeParameters.txt")) &&
            !overwrite
        ) {
            .log(paste(
                STAR_ref_path, "already exists.",
                "Set overwrite = TRUE to override"
            ))
        } else if(
            file.exists(file.path(STAR_ref_path, "genomeParameters.txt"))
        ) {
            .log(
                paste(
                    "Overwriting STAR reference in", STAR_ref_path
                ), "message"
            )
            unlink(list.files(STAR_ref_path), recursive = FALSE)
        }
    }

    .validate_path(STAR_ref_path)
    if (!("--genomeDir" %in% additional_args)) args <- c(args,
        "--genomeDir", STAR_ref_path)

    if (!("--genomeFastaFiles" %in% additional_args)) args <- c(args,
        "--genomeFastaFiles", genome.fa)

    if (!("--sjdbGTFfile" %in% additional_args)) args <- c(args,
        "--sjdbGTFfile", transcripts.gtf)

    if (!("--sjdbOverhang" %in% additional_args)) args <- c(args,
        "--sjdbOverhang", sjdbOverhang)

    if (!("--runThreadN" %in% additional_args)) args <- c(args,
        "--runThreadN", .validate_threads(n_threads, as_BPPARAM = FALSE))

    # sanity check sparsity
    if(is.na(as.numeric(sparsity))) sparsity <- 1
    sparsity <- floor(sparsity)
    sparsity <- max(sparsity, 1)
    args <- c(args, "--genomeSAsparseD", sparsity)

    if (!is.null(additional_args) && all(is.character(additional_args))) {
        args <- c(args, additional_args)
    }
    system2(command = "STAR", args = args)

    if (also_generate_mappability) {
        STAR_mappability(
            reference_path = reference_path,
            STAR_ref_path = STAR_ref_path,
            map_depth_threshold = map_depth_threshold,
            n_threads = n_threads,
            ...
        )
    }

    # Clean up
    .STAR_clean_temp_FASTA_GTF(reference_path)
}

#' @describeIn STAR-methods Aligns multiple sets of FASTQ files, belonging to
#'   multiple samples
#' @return For `STAR_alignExperiment()`: None
#' @export
STAR_alignExperiment <- function(
    Experiment, 
    STAR_ref_path, 
    BAM_output_path,
    n_threads = 4,
    overwrite = FALSE,
    two_pass = FALSE, 
    trim_adaptor = "AGATCGGAAG",
    additional_args = NULL
) {

    .validate_STAR_version()
    STAR_ref_path <- .validate_STAR_reference(STAR_ref_path)
    BAM_output_path <- .validate_path(BAM_output_path)

    # Dissect Experiment:
    if (ncol(Experiment) < 2 || ncol(Experiment) > 3) {
        .log(paste("Experiment must be a 2- or 3- column data frame,",
            "with the columns denoting sample name, fastq file (forward),",
            "and (optionally) fastq file (reverse)"))
    } else if (ncol(Experiment) == 2) {
        colnames(Experiment) <- c("sample", "forward")
        fastq_1 <- Experiment[, "forward"]
        fastq_2 <- NULL
        .validate_STAR_fastq_samples(fastq_1)
        paired <- FALSE
    } else if (ncol(Experiment) == 3) {
        colnames(Experiment) <- c("sample", "forward", "reverse")
        fastq_1 <- Experiment[, "forward"]
        fastq_2 <- Experiment[, "reverse"]
        .validate_STAR_fastq_samples(fastq_1, fastq_2)
        paired <- TRUE
    }
    gzipped <- all(grepl(paste0("\\", ".gz", "$"), fastq_1)) &&
        (!paired || all(grepl(paste0("\\", ".gz", "$"), fastq_2)))
    if (is_valid(trim_adaptor)) .validate_STAR_trim_sequence(trim_adaptor)

    samples <- unique(Experiment[, "sample"])
    SJ.files <- NULL
    two_pass_genome <- NULL
    loaded_ref <- NULL
    for (pass in seq_len(ifelse(two_pass, 2, 1))) {
        if (two_pass && pass == 1) message("STAR - first pass")
        if (two_pass && pass == 2) message("STAR - second pass")
        if (pass == 1) {
            ref <- STAR_ref_path
            system2(command = "STAR", args = c(
                "--genomeLoad", "LoadAndExit", "--genomeDir", ref,
                "--outFileNamePrefix", tempdir()
            ))
            loaded_ref <- ref
        }
        for (i in seq_len(length(samples))) {
            # Generate two-pass genome using spoof reads
            if(pass == 2 && is.null(two_pass_genome) && !is.null(SJ.files)) {
                two_pass_genome <- .STAR_twopassGenome(
                    STAR_ref_path, SJ_files = SJ.files$path,
                    n_threads = n_threads
                )
                system2(command = "STAR", args = c(
                    "--genomeLoad", "LoadAndExit", "--genomeDir", ref,
                    "--outFileNamePrefix", tempdir()
                ))
                loaded_ref <- ref <- two_pass_genome
            }

            sample <- samples[i]
            Expr_sample <- Experiment[Experiment[, "sample"] == sample, ]
            if (!paired) {
                fastq_1 <- Expr_sample[, "forward"]
                fastq_2 <- NULL
            } else {
                fastq_1 <- Expr_sample[, "forward"]
                fastq_2 <- Expr_sample[, "reverse"]
            }
            memory_mode <- "LoadAndKeep"
            if (two_pass && pass == 1) {
                additional_args_use <- c(additional_args,
                    "--outSAMtype", "None")
            } else {
                additional_args_use <- additional_args
            }

            .log(paste("Aligning", sample, "using STAR"), "message")
            STAR_alignReads(
                STAR_ref_path = ref,
                BAM_output_path = file.path(BAM_output_path, sample),
                fastq_1 = fastq_1, fastq_2 = fastq_2,
                trim_adaptor = trim_adaptor,
                memory_mode = memory_mode,
                additional_args = additional_args_use,
                n_threads = n_threads,
                overwrite = overwrite
            )

        } # end of FOR loop

        if (two_pass && pass == 1) {
            SJ.files <- findSamples(BAM_output_path, suffix = ".out.tab")
            if (nrow(SJ.files) == 0) {
                .log(paste("In STAR two-pass,",
                    "no SJ.out.tab files were found"))
            }
        }
        .log(paste("Unloading STAR reference:", loaded_ref), "message")
        system2(command = "STAR", args = c(
            "--genomeLoad", "Remove", "--genomeDir", loaded_ref,
                "--outFileNamePrefix", tempdir()
        ))
        loaded_ref <- NULL
        
        if(pass == 2 && !is.null(two_pass_genome)) {
            unlink(file.path(tempdir(), "STAR_twopass"), recursive = TRUE)
        }
    }
}

#' @describeIn STAR-methods Aligns a single sample (with single or paired FASTQ
#'   or FASTA files)
#' @return For `STAR_alignReads()`: None
#' @export
STAR_alignReads <- function(
        fastq_1 = c("./sample_1.fastq"), 
        fastq_2 = NULL,
        STAR_ref_path, 
        BAM_output_path,
        n_threads = 4,
        overwrite = FALSE,
        two_pass = FALSE,
        trim_adaptor = "AGATCGGAAG",
        memory_mode = "NoSharedMemory",
        additional_args = NULL
) {
    expectedBAM <- file.path(BAM_output_path, "Aligned.out.bam")
    if(!overwrite) {
        if(file.exists(expectedBAM)) {
            .log(paste(
                expectedBAM, 
                "already exists. Set overwrite = TRUE to overwrite"
                ), "warning"
            )
            message("") # for \n
            return()
        }
    } else {
        .log(
            paste(
                "Overwriting", expectedBAM
            ), "message"
        )
        unlink(expectedBAM)
    }

    .validate_STAR_version()
    STAR_ref_path <- .validate_STAR_reference(STAR_ref_path)
    .validate_STAR_fastq_samples(fastq_1, fastq_2)

    paired <- (length(fastq_1) == length(fastq_2))
    gzipped <- all(grepl(paste0("\\", ".gz", "$"), fastq_1)) &&
        (!paired || all(grepl(paste0("\\", ".gz", "$"), fastq_2)))
    if (is_valid(trim_adaptor)) .validate_STAR_trim_sequence(trim_adaptor)

    BAM_output_path <- .validate_path(BAM_output_path)
    # Load STAR reference

    # Remove duplication:
    args <- NULL
    if (!("--genomeLoad" %in% additional_args)) 
        args <- c("--genomeLoad", memory_mode)
    if (!("--runThreadN" %in% additional_args)) 
        args <- c(args,
            "--runThreadN", .validate_threads(n_threads, as_BPPARAM = FALSE))
    if (!("--genomeDir" %in% additional_args)) 
        args <- c(args, "--genomeDir", STAR_ref_path)
    if (!("--outFileNamePrefix" %in% additional_args))
        args <- c(args, "--outFileNamePrefix",
            paste0(BAM_output_path, "/"))

    if (!("--outStd" %in% additional_args)) args <- c(args, "--outStd", "Log")
    if (!("--outBAMcompression" %in% additional_args)) args <- c(args, 
        "--outBAMcompression", "6")

    if (!("--outSAMstrandField" %in% additional_args)) args <- c(args, 
        "--outSAMstrandField", "intronMotif")

    if (!("--outSAMunmapped" %in% additional_args)) 
        args <- c(args, "--outSAMunmapped", "None")

    if (!("--outFilterMultimapNmax" %in% additional_args))
        args <- c(args, "--outFilterMultimapNmax", "1")

    if (!("--outSAMtype" %in% additional_args))
        args <- c(args, "--outSAMtype", "BAM", "Unsorted")

    if (two_pass) args <- c(args, "--twopassMode", "Basic")

    args <- c(args, "--readFilesIn", paste(fastq_1, collapse = ","))

    if (paired) args <- c(args, paste(fastq_2, collapse = ","))
    if (gzipped) args <- c(args, "--readFilesCommand", shQuote("gzip -dc"))
    if (is_valid(trim_adaptor)) {
        if(.validate_STAR_version(silent = TRUE) >= "2.7.8a" && paired) {
            args <- c(args, 
                "--clip3pAdapterSeq", trim_adaptor, trim_adaptor,
                "--clip3pAdapterMMp", "0.1", "0.1"
            )      
        } else {
            args <- c(args, "--clip3pAdapterSeq", trim_adaptor)        
        }
    }

    if (!is.null(additional_args) && all(is.character(additional_args)))
        args <- c(args, additional_args)

    system2(command = "STAR", args = args)
}

.validate_STAR_version <- function(type = "error", silent = FALSE) {
    if (!(Sys.info()["sysname"] %in% c("Linux", "Darwin"))) {
        .log("STAR is only supported on Linux or MacOS", type = type)
        return(NULL)
    }
    # Super-safe checking if STAR is available
    which_star <- NULL
    tryCatch({
        which_star <- system2("which", "STAR", stdout = TRUE)
    }, error = function(e) {
        which_star <- NULL
    }, warning = function(e) {
        which_star <- NULL
    })
    if (is.null(which_star)) {
        .log("STAR is not installed", type = type)
        return(NULL)
    }
    star_version <- NULL
    tryCatch({
        star_version <- system2("STAR", "--version", stdout = TRUE)
    }, error = function(e) {
        star_version <- NULL
    })
    if (is.null(star_version)) {
        .log("STAR is not installed", type = type)
    }
    if (!is.null(star_version) && star_version < "2.5.0") {
        .log(paste("STAR version < 2.5.0 is not supported;",
            "current version:", star_version), type = type)
    }
    if (!is.null(star_version) && star_version >= "2.5.0" && !silent) {
        .log(paste("STAR version", star_version), type = "message")
    }
    return(star_version)
}

.validate_STAR_reference <- function(STAR_ref_path) {
    if (!file.exists(file.path(STAR_ref_path, "genomeParameters.txt")))
        .log(paste(
            STAR_ref_path, "does not appear to be a valid STAR reference"))
    return(normalizePath(STAR_ref_path))
}

.validate_OTF_STAR_reference <- function(STAR_ref_path) {
    if (!file.exists(file.path(STAR_ref_path, "genomeParameters.txt"))) {
        .log(paste(STAR_ref_path, 
            "does not appear to be a valid STAR reference"))    
    } else {
        .log(paste(STAR_ref_path, "on-the-fly STAR genome created"), "message")
    }
    return(normalizePath(STAR_ref_path))
}

# Creates a temporary FASTA file from locally-stored TwoBit
.STAR_get_FASTA <- function(reference_path) {
    genome.fa <- file.path(reference_path, "resource", "genome.fa")
    if (!file.exists(genome.fa)) {
        genome.fa <- paste0(genome.fa, ".temp")
        genome.2bit <- file.path(reference_path, "resource", "genome.2bit")
        if (!file.exists(genome.2bit)) {
            .log(paste(genome.2bit, "not found"))
        }
        .log("Extracting temp genome FASTA from TwoBit file", "message")
        tmp <- rtracklayer::import(TwoBitFile(genome.2bit))
        rtracklayer::export(
            tmp,
            genome.fa, "fasta"
        )
        rm(tmp)
        gc()
    }
    return(genome.fa)
}

# Creates a temporary unzipped GTF for STAR
.STAR_get_GTF <- function(reference_path) {
    transcripts.gtf <- file.path(reference_path, "resource", "transcripts.gtf")
    if (!file.exists(transcripts.gtf)) {
        if (!file.exists(paste0(transcripts.gtf, ".gz"))) {
            .log(paste(paste0(transcripts.gtf, ".gz"), "not found"))
        }
        .log("Extracting temp Annotation GTF from GZ file", "message")
        R.utils::gunzip(paste0(transcripts.gtf, ".gz"), remove = FALSE,
            overwrite = TRUE)
        file.rename(transcripts.gtf, paste0(transcripts.gtf, ".temp"))
        transcripts.gtf <- paste0(transcripts.gtf, ".temp")
    }
    return(transcripts.gtf)
}

.STAR_clean_temp_FASTA_GTF <- function(reference_path) {
    .log("Cleaning temp genome / gene annotation files", "message")
    genome.fa <- file.path(reference_path, "resource", "genome.fa.temp")
    transcripts.gtf <- file.path(reference_path,
        "resource", "transcripts.gtf.temp")
    if (file.exists(genome.fa)) file.remove(genome.fa)
    if (file.exists(transcripts.gtf)) file.remove(transcripts.gtf)
}

.validate_STAR_fastq_samples <- function(fastq_1, fastq_2) {
    if (!is_valid(fastq_2)) {
        # assume single
        if (!all(file.exists(fastq_1))) {
            .log("Some fastq files were not found")
        }
    } else {
        if (length(fastq_2) != length(fastq_1)) {
            .log(paste("There must be equal numbers of",
                "forward and reverse fastq samples"))
        }
        if (!all(file.exists(fastq_1)) || !all(file.exists(fastq_2))) {
            .log("Some fastq files were not found")
        }
    }
    paired <- (length(fastq_1) == length(fastq_2))
    gzipped <- all(grepl(paste0("\\", ".gz", "$"), fastq_1)) &&
        (!paired || all(grepl(paste0("\\", ".gz", "$"), fastq_2)))
    if (!gzipped &&
        (
            any(grepl(paste0("\\", ".gz", "$"), fastq_1)) ||
            (paired && any(grepl(paste0("\\", ".gz", "$"), fastq_2)))
        )
    ) {
        .log(paste("A mixture of gzipped and uncompressed",
            "fastq files found.", "You must supply either all",
            "gzipped or all uncompressed fastq files"))
    }
}

.validate_STAR_trim_sequence <- function(sequence) {
    if (length(sequence) != 1) {
        .log("Multiple adaptor sequences are not supported")
    }
    tryCatch({
        ACGT_sum <- sum(Biostrings::letterFrequency(
            Biostrings::DNAString(sequence),
            letters = "AGCT", OR = 0))
    }, error = function(e) ACGT_sum <- 0)
    if (nchar(sequence) != ACGT_sum) {
        .log("Adaptor sequence can only contain A, C, G or T")
    }
}

# New approach to STAR utilities
#
# Functions
# - STAR_buildGenome: builds transcriptome-agnostic genome STAR reference
# - STAR_loadGenome: loads STAR genome into shared memory
#   - adding extra features as required, including:
#     - transcriptome GTF file
#     - sjdbOverhang settings
#     - any spike-ins (as FASTA files)
# - STAR_alignReads: aligns single or paired FASTQ reads using either
#     a given STAR genome, or the loaded STAR genome
# - STAR_alignExperiment: pipeline for STAR analysis with multiple samples

#' @describeIn STAR-methods Creates a STAR genome reference, using ONLY the
#'   FASTA file used to create the SpliceWiz reference
#' @return For `STAR_buildGenome()`: None
#' @export
STAR_buildGenome <- function(
    reference_path,
    STAR_ref_path = file.path(reference_path, "STAR"),
    n_threads = 4,
    overwrite = FALSE,
    sparsity = 1,
    also_generate_mappability = FALSE,
    map_depth_threshold = 4,
    additional_args = NULL,
    ...
) {
    .validate_reference_resource(reference_path)
    .validate_STAR_version()

    genome.fa <- .STAR_get_FASTA(reference_path)

    .log(paste("Building STAR genome from", reference_path), type = "message")

    args <- NULL
    if (!("--runMode" %in% additional_args)) args <- c(
        "--runMode", "genomeGenerate")

    if(dir.exists(STAR_ref_path)) {
        if(
            file.exists(file.path(STAR_ref_path, "genomeParameters.txt")) &&
            !overwrite
        ) {
            .log(paste(
                STAR_ref_path, "already exists.",
                "Set overwrite = TRUE to override"
            ))
        } else if(
            file.exists(file.path(STAR_ref_path, "genomeParameters.txt"))
        ) {
            .log(
                paste(
                    "Overwriting STAR reference in", STAR_ref_path
                ), "message"
            )
            unlink(list.files(STAR_ref_path), recursive = FALSE)
        }
    }

    .validate_path(STAR_ref_path)
    if (!("--genomeDir" %in% additional_args)) args <- c(args,
        "--genomeDir", STAR_ref_path)


    if (!("--genomeFastaFiles" %in% additional_args)) args <- c(args,
        "--genomeFastaFiles", genome.fa)

    if (!("--runThreadN" %in% additional_args)) args <- c(args,
        "--runThreadN", .validate_threads(n_threads, as_BPPARAM = FALSE))

    # sanity check sparsity
    if(is.na(as.numeric(sparsity))) sparsity <- 1
    sparsity <- floor(sparsity)
    sparsity <- max(sparsity, 1)
    
    args <- c(args, "--genomeSAsparseD", sparsity)

    if (!is.null(additional_args) && all(is.character(additional_args))) {
        args <- c(args, additional_args)
    }
    system2(command = "STAR", args = args)

    # Perform STAR_mappability by inserting GTF from SpliceWiz reference
    if (also_generate_mappability) {
        tmpGenome <- STAR_loadGenomeGTF(
            STAR_ref_path,
            reference_path = reference_path,
            sjdbOverhang = 100,
            STARgenome_output = file.path(tempdir(), "STARmap"),
            overwrite = TRUE
        )
        
        STAR_mappability(
            reference_path = reference_path,
            STAR_ref_path = tmpGenome,
            map_depth_threshold = map_depth_threshold,
            n_threads = n_threads,
            ...
        )
        
        unlink(file.path(tempdir(), "STARmap"), recursive = TRUE)
    }

    # Clean up
    .STAR_clean_temp_FASTA_GTF(reference_path)
}


#' @describeIn STAR-methods Creates an "on-the-fly" STAR genome, injecting GTF
#' from the given SpliceWiz `reference_path`, setting `sjdbOverhang` setting,
#' and (optionally) any spike-ins as `extraFASTA`
#' @param extraFASTA (default `""`) One or more FASTA files containing spike-in
#'   genome sequences (e.g. ERCC, Sequins), as required.
#' @param STARgenome_output The output path of the created on-the-fly genome
#' @return For `STAR_loadGenomeGTF()`:
#'   The path of the on-the-fly STAR genome, typically in the subdirectory
#'   "_STARgenome" within the given `STARgenome_output` directory
#' @export
STAR_loadGenomeGTF <- function(
    reference_path,
    STAR_ref_path,
    STARgenome_output = file.path(tempdir(), "STAR"),
    n_threads = 4,
    overwrite = FALSE,
    sjdbOverhang = 100,
    extraFASTA = "",
    additional_args = NULL
) {
    .validate_reference_resource(reference_path)
    .validate_STAR_version()
    .validate_STAR_reference(STAR_ref_path)

    # Prepare GTF
    transcripts.gtf <- .STAR_get_GTF(reference_path)

    .log(paste(
        "Loading STAR genome from", STAR_ref_path, "with injected GTF"),
        type = "message"
    )

    args <- NULL

    if (!("--genomeDir" %in% additional_args)) args <- c(args,
        "--genomeDir", STAR_ref_path)

    if (!("--genomeFastaFiles" %in% additional_args)) {
        if(all(file.exists(extraFASTA))) {
            args <- c(args, "--genomeFastaFiles", extraFASTA)
        } else if(length(extraFASTA) != 1 || extraFASTA != "") {
            .log(paste("Some files in extraFASTA do not exist... aborting"))
        }
    }

    if (!("--sjdbGTFfile" %in% additional_args)) args <- c(args,
        "--sjdbGTFfile", transcripts.gtf)

    if (!("--sjdbOverhang" %in% additional_args)) {
        # sanity check overhangs
        if(is.na(as.numeric(sjdbOverhang))) sjdbOverhang <- 100
        sjdbOverhang <- floor(sjdbOverhang)
        sjdbOverhang <- max(sjdbOverhang, 25)
        args <- c(args, "--sjdbOverhang", sjdbOverhang)
    }

    if (!("--runThreadN" %in% additional_args)) args <- c(args,
        "--runThreadN", .validate_threads(n_threads, as_BPPARAM = FALSE))

    nch <- nchar(STARgenome_output)
    if(substr(STARgenome_output, nch,nch) == "/")
        STARgenome_output <- substr(STARgenome_output, 1, nch-1)
    # create output directory (destroy old STAR ref if already exists)
    if(dir.exists(STARgenome_output)) {
        if(
            file.exists(file.path(STARgenome_output, "genomeParameters.txt")) &&
            !overwrite
        ) {
            .log(paste(
                STARgenome_output, "already exists.",
                "Set overwrite = TRUE to override"
            ))
        } else if(
            file.exists(file.path(STARgenome_output, "genomeParameters.txt"))
        ) {
            # Likely location of STAR ref, remove before generating STAR ref
            unlink(STARgenome_output, recursive = FALSE)
        }
    }
    .validate_path(STARgenome_output)    
    args <- c(args, "--outFileNamePrefix", paste0(STARgenome_output,"/"))

    if (!is.null(additional_args) && all(is.character(additional_args))) {
        args <- c(args, additional_args)
    }

    args <- c(args, "--sjdbInsertSave", "All")
    args <- c(args, "--readFilesIn", 
        system.file(
            "extdata/spoof_1.fq",
            package = "SpliceWiz"
        ),
        system.file(
            "extdata/spoof_1.fq",
            package = "SpliceWiz"
        )
    )

    system2(command = "STAR", args = args)
   
    .STAR_clean_temp_FASTA_GTF(reference_path)

    return(.validate_OTF_STAR_reference(
        file.path(STARgenome_output, "_STARgenome")
    ))
}

#' @describeIn STAR-methods Calculates lowly-mappable genomic regions using STAR
#' @return For `STAR_mappability()`: None
#' @export
STAR_mappability <- function(
        reference_path,
        STAR_ref_path = file.path(reference_path, "STAR"),
        map_depth_threshold = 4,
        n_threads = 4,
        ...
) {
    .validate_reference_resource(reference_path)
    .validate_STAR_version()
    STAR_ref_path <- .validate_STAR_reference(STAR_ref_path)
    mappability_reads_fasta <- file.path(
        reference_path, "Mappability", "Reads.fa")
    generateSyntheticReads(reference_path, ...)

    .log(paste("Aligning genome fragments back to the genome, from:",
        mappability_reads_fasta), type = "message")
    aligned_bam <- file.path(reference_path, "Mappability",
        "Aligned.out.bam")
    STAR_alignReads(
        fastq_1 = mappability_reads_fasta,
        fastq_2 = NULL,
        STAR_ref_path = STAR_ref_path,
        BAM_output_path = dirname(aligned_bam),
        n_threads = n_threads,
        trim_adaptor = "",
        additional_args = c(
            "--outSAMstrandField", "None",
            "--outSAMattributes", "None"
        )
    )
    if (file.exists(aligned_bam)) {
        # Cleaan up fasta
        if (file.exists(mappability_reads_fasta))
            file.remove(mappability_reads_fasta)

        .log(paste("Calculating Mappability from:", aligned_bam),
            type = "message")
        calculateMappability(
            reference_path = reference_path,
            aligned_bam = aligned_bam,
            threshold = map_depth_threshold,
            n_threads = n_threads
        )
    } else {
        .log("STAR failed to align mappability reads", "warning")
    }
    if (file.exists(file.path(reference_path, "Mappability",
            "MappabilityExclusion.bed.gz"))) {
        message("Mappability Exclusion calculations complete")
        # Clean up BAM
        if (file.exists(aligned_bam)) file.remove(aligned_bam)
    } else {
        .log("Mappability Exclusion calculations not performed", "warning")
    }
}

.STAR_twopassGenome <- function(
    STAR_ref_path,
    STARgenome_output = file.path(tempdir(), "STAR_twopass"),
    SJ_files = "",
    n_threads = 4,
    overwrite = TRUE
) {
    .validate_STAR_version()
    .validate_STAR_reference(STAR_ref_path)

    .log("Loading STAR two-pass genome", type = "message")
    args <- c("--genomeDir", STAR_ref_path)

    args <- c(args, "--sjdbFileChrStartEnd",
        paste(SJ_files, collapse = " "),
        "--sjdbInsertSave", "All"
    )

    args <- c(args, "--runThreadN", 
        .validate_threads(n_threads, as_BPPARAM = FALSE))

    nch <- nchar(STARgenome_output)
    if(substr(STARgenome_output, nch,nch) == "/")
        STARgenome_output <- substr(STARgenome_output, 1, nch-1)
    # create output directory (destroy old STAR ref if already exists)
    if(dir.exists(STARgenome_output)) {
        if(
            file.exists(file.path(STARgenome_output, "genomeParameters.txt")) &&
            !overwrite
        ) {
            .log(paste(
                STARgenome_output, "already exists.",
                "Set overwrite = TRUE to override"
            ))
        } else if(
            file.exists(file.path(STARgenome_output, "genomeParameters.txt"))
        ) {
            # Likely location of STAR ref, remove before generating STAR ref
            unlink(STARgenome_output, recursive = FALSE)
        }
    }
    .validate_path(STARgenome_output)    
    args <- c(args, "--outFileNamePrefix", paste0(STARgenome_output,"/"))

    args <- c(args, "--readFilesIn", 
        system.file(
            "extdata/spoof_1.fq",
            package = "SpliceWiz"
        ),
        system.file(
            "extdata/spoof_1.fq",
            package = "SpliceWiz"
        )
    )

    system2(command = "STAR", args = args)

    return(.validate_OTF_STAR_reference(
        file.path(STARgenome_output, "_STARgenome")
    ))
}
