% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/File_finders.R
\name{findSamples}
\alias{findSamples}
\alias{findFASTQ}
\alias{findBAMS}
\alias{findSpliceWizOutput}
\title{Convenience Function to (recursively) find all files in a folder.}
\usage{
findSamples(sample_path, suffix = ".txt.gz", level = 0)

findFASTQ(
  sample_path,
  paired = TRUE,
  fastq_suffix = c(".fastq", ".fq", ".fastq.gz", ".fq.gz"),
  level = 0
)

findBAMS(sample_path, level = 0)

findSpliceWizOutput(sample_path, level = 0)
}
\arguments{
\item{sample_path}{The path in which to recursively search for files
that match the given \code{suffix}}

\item{suffix}{A vector of or or more strings that specifies the file suffix
(e.g. '.bam' denotes BAM files, whereas ".txt.gz" denotes gzipped txt
files).}

\item{level}{Whether sample names can be found in the file names themselves
(level = 0), or their parent directory (level = 1). Potentially parent
of parent directory (level = 2). Support max level <= 3 (for sanity).}

\item{paired}{Whether to expect single FASTQ files (of the format
"sample.fastq"), or
paired files (of the format "sample_1.fastq", "sample_2.fastq")}

\item{fastq_suffix}{The name of the FASTQ suffix. Options are:
".fastq", ".fastq.gz", ".fq", or ".fq.gz"}
}
\value{
A multi-column data frame with the first column containing
the sample name, and subsequent columns being the file paths with suffix
as determined by \code{suffix}.
}
\description{
Often, files e.g. raw sequencing FASTQ files, alignment BAM files,
or \link{processBAM} output files, are stored in a single folder under some
directory structure.
They can be grouped by being in common directory or having common names.
Often, their sample names can be gleaned by these common names or the names
of the folders in which they are contained.
This function (recursively) finds all files and
extracts sample names assuming either the files are named by sample names
(\code{level = 0}), or that their names can be derived from the
parent folder (\code{level = 1}). Higher \code{level} also work (e.g. \code{level = 2})
mean the parent folder of the parent folder of the file is named by sample
names. See details section below.
}
\details{
Paired FASTQ files are assumed to be named using the suffix \verb{_1} and \verb{_2}
after their common names; e.g. \code{sample_1.fastq}, \code{sample_2.fastq}. Alternate
FASTQ suffixes for \code{findFASTQ()} include ".fq", ".fastq.gz", and ".fq.gz".

In BAM files, often the parent directory denotes their sample names. In this
case, use \code{level = 1} to automatically annotate the sample names using
\code{findBAMS()}.

\link{processBAM} outputs two files per BAM processed. These are named by the
given sample names. The text output is named "sample1.txt.gz", and the COV
file is named "sample1.cov", where \code{sample1} is the name of the sample. These
files can be organised / tabulated using the function \code{findSpliceWizOutput}.
The generic function \code{findSamples} will organise the \link{processBAM} text output
files but exclude the COV files. Use the latter as the \code{Experiment} in
\link{collateData} if one decides to collate an experiment without linked COV
files, for portability reasons.
}
\section{Functions}{
\itemize{
\item \code{findSamples()}: Finds all files with the given suffix pattern.
Annotates sample names based on file or parent folder names.

\item \code{findFASTQ()}: Use findSamples() to return all FASTQ files
in a given folder

\item \code{findBAMS()}: Use findSamples() to return all BAM files in a
given folder

\item \code{findSpliceWizOutput()}: Use findSamples() to return all processBAM output
files in a given folder, including COV files

}}
\examples{
# Retrieve all BAM files in a given folder, named by sample names
bam_path <- tempdir()
example_bams(path = bam_path)
df.bams <- findSamples(sample_path = bam_path,
  suffix = ".bam", level = 0)
# equivalent to:
df.bams <- findBAMS(bam_path, level = 0)

# Retrieve all processBAM() output files in a given folder,
# named by sample names

expr <- findSpliceWizOutput(file.path(tempdir(), "SpliceWiz_Output"))
\dontrun{

# Find FASTQ files in a directory, named by sample names
# where files are in the form:
# - "./sample_folder/sample1.fastq"
# - "./sample_folder/sample2.fastq"

findFASTQ("./sample_folder", paired = FALSE, fastq_suffix = ".fastq")

# Find paired gzipped FASTQ files in a directory, named by parent directory
# where files are in the form:
# - "./sample_folder/sample1/raw_1.fq.gz"
# - "./sample_folder/sample1/raw_2.fq.gz"
# - "./sample_folder/sample2/raw_1.fq.gz"
# - "./sample_folder/sample2/raw_2.fq.gz"

findFASTQ("./sample_folder", paired = TRUE, fastq_suffix = ".fq.gz")
}

}
