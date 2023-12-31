% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllClasses.R, R/NxtSE-methods.R
\docType{class}
\name{NxtSE-class}
\alias{NxtSE-class}
\alias{NxtSE-methods}
\alias{up_inc}
\alias{up_inc,NxtSE-method}
\alias{up_inc<-}
\alias{up_inc<-,NxtSE-method}
\alias{down_inc}
\alias{down_inc,NxtSE-method}
\alias{down_inc<-}
\alias{down_inc<-,NxtSE-method}
\alias{up_exc}
\alias{up_exc,NxtSE-method}
\alias{up_exc<-}
\alias{up_exc<-,NxtSE-method}
\alias{down_exc}
\alias{down_exc,NxtSE-method}
\alias{down_exc<-}
\alias{down_exc<-,NxtSE-method}
\alias{covfile}
\alias{covfile,NxtSE-method}
\alias{covfile<-}
\alias{covfile<-,NxtSE-method}
\alias{sampleQC}
\alias{sampleQC,NxtSE-method}
\alias{sampleQC<-}
\alias{sampleQC<-,NxtSE-method}
\alias{ref}
\alias{ref,NxtSE-method}
\alias{sourcePath}
\alias{sourcePath,NxtSE-method}
\alias{row_gr}
\alias{row_gr,NxtSE-method}
\alias{junc_PSI}
\alias{junc_PSI,NxtSE-method}
\alias{junc_counts}
\alias{junc_counts,NxtSE-method}
\alias{junc_counts_uns}
\alias{junc_counts_uns,NxtSE-method}
\alias{junc_gr}
\alias{junc_gr,NxtSE-method}
\alias{update_NxtSE}
\alias{update_NxtSE,NxtSE-method}
\alias{realize_NxtSE}
\alias{realize_NxtSE,NxtSE-method}
\alias{coerce,SummarizedExperiment,NxtSE-method}
\alias{NxtSE}
\alias{[,NxtSE,ANY,ANY,ANY-method}
\alias{[<-,NxtSE,ANY,ANY,NxtSE-method}
\alias{cbind,NxtSE-method}
\alias{rbind,NxtSE-method}
\title{The NxtSE class}
\usage{
NxtSE(...)

\S4method{up_inc}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{down_inc}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{up_exc}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{down_exc}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{covfile}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{sampleQC}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{sourcePath}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{row_gr}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{ref}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{junc_PSI}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{junc_counts}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{junc_counts_uns}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{junc_gr}{NxtSE}(x, withDimnames = TRUE, ...)

\S4method{update_NxtSE}{NxtSE}(x, ...)

\S4method{realize_NxtSE}{NxtSE}(x, includeJunctions = FALSE, withDimnames = TRUE, ...)

\S4method{up_inc}{NxtSE}(x, withDimnames = TRUE) <- value

\S4method{down_inc}{NxtSE}(x, withDimnames = TRUE) <- value

\S4method{up_exc}{NxtSE}(x, withDimnames = TRUE) <- value

\S4method{down_exc}{NxtSE}(x, withDimnames = TRUE) <- value

\S4method{covfile}{NxtSE}(x, withDimnames = TRUE) <- value

\S4method{sampleQC}{NxtSE}(x, withDimnames = TRUE) <- value

\S4method{[}{NxtSE,ANY,ANY,ANY}(x, i, j, ..., drop = TRUE)

\S4method{[}{NxtSE,ANY,ANY,NxtSE}(x, i, j, ...) <- value

\S4method{cbind}{NxtSE}(..., deparse.level = 1)

\S4method{rbind}{NxtSE}(..., deparse.level = 1)
}
\arguments{
\item{...}{In NxtSE(), additional arguments to be passed onto
SummarizedExperiment()}

\item{x}{A NxtSE object}

\item{withDimnames}{(default TRUE) Whether exported assays should be
supplied with row and column names of the NxtSE object.
See \linkS4class{SummarizedExperiment}}

\item{includeJunctions}{When realizing a NxtSE object, include whether
junction counts and PSIs should be realized into memory. Not recommended
for general use, as they are only used for coverage plots.}

\item{value}{The value to replace. Must be a matrix for the
up_inc<-, down_inc<-, up_exc<- and down_exc<- replacers,
and a character vector for covfile<-}

\item{i, j}{Row and column subscripts to subset a NxtSE object.}

\item{drop}{A logical(1), ignored by these methods.}

\item{deparse.level}{See \link[base:cbind]{base::cbind} for a description of this argument.}
}
\value{
See Functions section (below) for details
}
\description{
The NxtSE class inherits from the \linkS4class{SummarizedExperiment}
class and is constructed using \link{makeSE}. NxtSE extends SummarizedExperiment
by housing additional assays pertaining to IR and splice junction counts.
}
\section{Functions}{
\itemize{
\item \code{NxtSE()}: Constructor function for NxtSE; akin to
SummarizedExperiment(...)

\item \code{up_inc(NxtSE)}: Gets upstream included events (SE/MXE), or
upstream exon-intron spanning reads (IR)

\item \code{down_inc(NxtSE)}: Gets downstream included events (SE/MXE), or
downstream exon-intron spanning reads (IR)

\item \code{up_exc(NxtSE)}: Gets upstream excluded events (MXE only)

\item \code{down_exc(NxtSE)}: Gets downstream excluded events (MXE only)

\item \code{covfile(NxtSE)}: Gets a named vector with
the paths to the corresponding COV files

\item \code{sampleQC(NxtSE)}: Gets a data frame with the QC parameters
of the samples

\item \code{sourcePath(NxtSE)}: Retrieves the directory path containing the source
data for this NxtSE object.

\item \code{row_gr(NxtSE)}: Retrieves a GRanges object representing the genomic
spans of the ASEs (EventRegion as GRanges)

\item \code{ref(NxtSE)}: Retrieves a list of annotation data associated
with this NxtSE object; primarily used in plotCoverage()

\item \code{junc_PSI(NxtSE)}: Getter for junction PSI DelayedMatrix;
primarily used in plotCoverage()

\item \code{junc_counts(NxtSE)}: Getter for junction counts DelayedMatrix;
primarily used in plotCoverage()

\item \code{junc_counts_uns(NxtSE)}: Getter for (unstranded) junction counts
DelayedMatrix; primarily used in plotCoverage()

\item \code{junc_gr(NxtSE)}: Getter for junction GenomicRanges coordinates;
primarily used in plotCoverage()

\item \code{update_NxtSE(NxtSE)}: Updates NxtSE object to the latest version.

\item \code{realize_NxtSE(NxtSE)}: Converts all DelayedMatrix assays as matrices
(i.e. performs all delayed calculation and loads resulting object
to RAM)

\item \code{up_inc(NxtSE) <- value}: Sets upstream included events (SE/MXE), or
upstream exon-intron spanning reads (IR)

\item \code{down_inc(NxtSE) <- value}: Sets downstream included events (SE/MXE), or
downstream exon-intron spanning reads (IR)

\item \code{up_exc(NxtSE) <- value}: Sets upstream excluded events (MXE only)

\item \code{down_exc(NxtSE) <- value}: Sets downstream excluded events (MXE only)

\item \code{covfile(NxtSE) <- value}: Sets the paths to the corresponding COV files

\item \code{sampleQC(NxtSE) <- value}: Sets the values in the data frame containing
sample QC

\item \code{x[i}: Subsets a NxtSE object

\item \code{`[`(x = NxtSE, i = ANY, j = ANY) <- value}: Sets a subsetted NxtSE object

\item \code{cbind(NxtSE)}: Combines two NxtSE objects (by samples - columns)

\item \code{rbind(NxtSE)}: Combines two NxtSE objects (by AS/IR events - rows)

}}
\examples{

# Run the full pipeline to generate a NxtSE object:

buildRef(
    reference_path = file.path(tempdir(), "Reference"),
    fasta = chrZ_genome(), 
    gtf = chrZ_gtf()
)

bams <- SpliceWiz_example_bams()
processBAM(bams$path, bams$sample,
  reference_path = file.path(tempdir(), "Reference"),
  output_path = file.path(tempdir(), "SpliceWiz_Output")
)

expr <- findSpliceWizOutput(file.path(tempdir(), "SpliceWiz_Output"))
collateData(expr, 
  reference_path = file.path(tempdir(), "Reference"),
  output_path = file.path(tempdir(), "Collated_output")
)

se <- makeSE(collate_path = file.path(tempdir(), "Collated_output"))

# Coerce NxtSE -> SummarizedExperiment
se_raw <- as(se, "SummarizedExperiment")

# Coerce SummarizedExperiment -> NxtSE
se_NxtSE <- as(se_raw, "NxtSE")
identical(se, se_NxtSE) # Returns TRUE

# Update NxtSE object to the latest version
# - useful if an NxtSE object made with old SpliceWiz version
# - was stored as an RDS obejct

se <- update_NxtSE(se)

# Get directory path of NxtSE (i.e., collate_path)
sourcePath(se)

# Get Main Assay Counts
assay(se, "Included") # Junction (or IR depth) counts for included isoform
assay(se, "Excluded") # Junction (or IR depth) counts for excluded isoform

# Get Auxiliary Counts (for filter use only)
assay(se, "Coverage") # Participation ratio (intron coverage for IR/RI)
assay(se, "minDepth") # SpliceOver junction counts (Intron Depths for IR/RI)
assay(se, "Depth")    # Sum of intron depth and SpliceOver (used for
                      # coverage normalization factor

# Get Junction reads of SE / MXE and spans-reads of IR events
up_inc(se)   # Upstream included junction counts (IR/MXE/SE/RI)
down_inc(se) # Downstream included junction counts (IR/MXE/SE/RI)
up_exc(se)   # Upstream excluded junction counts (MXE only)
down_exc(se) # Downstream excluded junction counts (MXE only)

# Get Junction counts
junc_counts(se) # stranded (if RNA-seq is auto-detected as stranded)
junc_counts_uns(se) # unstranded (sum of junction reads from both strand)
junc_PSI(se) # PSI of junction (as proportion of SpliceOver metric)

# Get Junction GRanges object
junc_gr(se)

# Get EventRegion as GRanges object
row_gr(se)

# Get list of available coverage files
covfile(se)

# Get sample QC information
sampleQC(se)

# Get resource data (used internally for plotCoverage())
cov_data <- ref(se)
names(cov_data)

# Subset functions
se_by_samples <- se[,1:3]
se_by_events <- se[1:10,]
se_by_rowData <- subset(se, EventType == "IR")

# Cbind (bind event_identical NxtSE by samples)
se_by_samples_1 <- se[,1:3]
se_by_samples_2 <- se[,4:6]
se_cbind <- cbind(se_by_samples_1, se_by_samples_2)
identical(se, se_cbind) # should return TRUE

# Rbind (bind sample_identical NxtSE by events)
se_IR <- subset(se, EventType == "IR")
se_SE <- subset(se, EventType == "SE")
se_IRSE <- rbind(se_IR, se_SE)
identical(se_IRSE, subset(se, EventType \%in\% c("IR", "SE"))) # TRUE

# Convert HDF5-based NxtSE to in-memory se
# makeSE() creates a HDF5-based NxtSE object where all assay data is stored
# as an h5 file instead of in-memory. All operations are performed as
# delayed operations as per DelayedArray package.
# To realize the NxtSE object as an in-memory object, use:

se_real <- realize_NxtSE(se)
identical(se, se_real) # should return FALSE

# To check the difference, run:
class(up_inc(se))
class(up_inc(se_real))

}
