// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// SpliceWizMain_hts
int SpliceWizMain_hts(std::string bam_file, std::string reference_file, std::string output_file, bool verbose, int n_threads, int read_pool);
RcppExport SEXP _SpliceWiz_SpliceWizMain_hts(SEXP bam_fileSEXP, SEXP reference_fileSEXP, SEXP output_fileSEXP, SEXP verboseSEXP, SEXP n_threadsSEXP, SEXP read_poolSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type bam_file(bam_fileSEXP);
    Rcpp::traits::input_parameter< std::string >::type reference_file(reference_fileSEXP);
    Rcpp::traits::input_parameter< std::string >::type output_file(output_fileSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< int >::type n_threads(n_threadsSEXP);
    Rcpp::traits::input_parameter< int >::type read_pool(read_poolSEXP);
    rcpp_result_gen = Rcpp::wrap(SpliceWizMain_hts(bam_file, reference_file, output_file, verbose, n_threads, read_pool));
    return rcpp_result_gen;
END_RCPP
}
// c_BAM2COV_hts
int c_BAM2COV_hts(std::string bam_file, std::string output_file, bool verbose, int n_threads, int read_pool);
RcppExport SEXP _SpliceWiz_c_BAM2COV_hts(SEXP bam_fileSEXP, SEXP output_fileSEXP, SEXP verboseSEXP, SEXP n_threadsSEXP, SEXP read_poolSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type bam_file(bam_fileSEXP);
    Rcpp::traits::input_parameter< std::string >::type output_file(output_fileSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< int >::type n_threads(n_threadsSEXP);
    Rcpp::traits::input_parameter< int >::type read_pool(read_poolSEXP);
    rcpp_result_gen = Rcpp::wrap(c_BAM2COV_hts(bam_file, output_file, verbose, n_threads, read_pool));
    return rcpp_result_gen;
END_RCPP
}
// c_doNothing_hts
int c_doNothing_hts(std::string bam_file, bool verbose, int n_threads, int read_pool);
RcppExport SEXP _SpliceWiz_c_doNothing_hts(SEXP bam_fileSEXP, SEXP verboseSEXP, SEXP n_threadsSEXP, SEXP read_poolSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type bam_file(bam_fileSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< int >::type n_threads(n_threadsSEXP);
    Rcpp::traits::input_parameter< int >::type read_pool(read_poolSEXP);
    rcpp_result_gen = Rcpp::wrap(c_doNothing_hts(bam_file, verbose, n_threads, read_pool));
    return rcpp_result_gen;
END_RCPP
}
// Has_OpenMP
int Has_OpenMP();
RcppExport SEXP _SpliceWiz_Has_OpenMP() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(Has_OpenMP());
    return rcpp_result_gen;
END_RCPP
}
// Test_OpenMP_For
int Test_OpenMP_For();
RcppExport SEXP _SpliceWiz_Test_OpenMP_For() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(Test_OpenMP_For());
    return rcpp_result_gen;
END_RCPP
}
// c_Check_Cov
bool c_Check_Cov(std::string s_in);
RcppExport SEXP _SpliceWiz_c_Check_Cov(SEXP s_inSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type s_in(s_inSEXP);
    rcpp_result_gen = Rcpp::wrap(c_Check_Cov(s_in));
    return rcpp_result_gen;
END_RCPP
}
// c_RLE_From_Cov
List c_RLE_From_Cov(std::string s_in, std::string seqname, int start, int end, int strand);
RcppExport SEXP _SpliceWiz_c_RLE_From_Cov(SEXP s_inSEXP, SEXP seqnameSEXP, SEXP startSEXP, SEXP endSEXP, SEXP strandSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type s_in(s_inSEXP);
    Rcpp::traits::input_parameter< std::string >::type seqname(seqnameSEXP);
    Rcpp::traits::input_parameter< int >::type start(startSEXP);
    Rcpp::traits::input_parameter< int >::type end(endSEXP);
    Rcpp::traits::input_parameter< int >::type strand(strandSEXP);
    rcpp_result_gen = Rcpp::wrap(c_RLE_From_Cov(s_in, seqname, start, end, strand));
    return rcpp_result_gen;
END_RCPP
}
// c_Cov_Seqnames
StringVector c_Cov_Seqnames(std::string s_in);
RcppExport SEXP _SpliceWiz_c_Cov_Seqnames(SEXP s_inSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type s_in(s_inSEXP);
    rcpp_result_gen = Rcpp::wrap(c_Cov_Seqnames(s_in));
    return rcpp_result_gen;
END_RCPP
}
// c_RLEList_From_Cov
List c_RLEList_From_Cov(std::string s_in, int strand);
RcppExport SEXP _SpliceWiz_c_RLEList_From_Cov(SEXP s_inSEXP, SEXP strandSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type s_in(s_inSEXP);
    Rcpp::traits::input_parameter< int >::type strand(strandSEXP);
    rcpp_result_gen = Rcpp::wrap(c_RLEList_From_Cov(s_in, strand));
    return rcpp_result_gen;
END_RCPP
}
// c_gunzip_DF
List c_gunzip_DF(std::string s_in, StringVector s_header_begin);
RcppExport SEXP _SpliceWiz_c_gunzip_DF(SEXP s_inSEXP, SEXP s_header_beginSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type s_in(s_inSEXP);
    Rcpp::traits::input_parameter< StringVector >::type s_header_begin(s_header_beginSEXP);
    rcpp_result_gen = Rcpp::wrap(c_gunzip_DF(s_in, s_header_begin));
    return rcpp_result_gen;
END_RCPP
}
// c_gunzip
int c_gunzip(std::string s_in, std::string s_out);
RcppExport SEXP _SpliceWiz_c_gunzip(SEXP s_inSEXP, SEXP s_outSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type s_in(s_inSEXP);
    Rcpp::traits::input_parameter< std::string >::type s_out(s_outSEXP);
    rcpp_result_gen = Rcpp::wrap(c_gunzip(s_in, s_out));
    return rcpp_result_gen;
END_RCPP
}
// SpliceWizMain
int SpliceWizMain(std::string bam_file, std::string reference_file, std::string output_file, bool verbose, int n_threads, bool multiRead);
RcppExport SEXP _SpliceWiz_SpliceWizMain(SEXP bam_fileSEXP, SEXP reference_fileSEXP, SEXP output_fileSEXP, SEXP verboseSEXP, SEXP n_threadsSEXP, SEXP multiReadSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type bam_file(bam_fileSEXP);
    Rcpp::traits::input_parameter< std::string >::type reference_file(reference_fileSEXP);
    Rcpp::traits::input_parameter< std::string >::type output_file(output_fileSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< int >::type n_threads(n_threadsSEXP);
    Rcpp::traits::input_parameter< bool >::type multiRead(multiReadSEXP);
    rcpp_result_gen = Rcpp::wrap(SpliceWizMain(bam_file, reference_file, output_file, verbose, n_threads, multiRead));
    return rcpp_result_gen;
END_RCPP
}
// SpliceWizMain_multi
int SpliceWizMain_multi(std::string reference_file, StringVector bam_files, StringVector output_files, int max_threads, bool verbose, bool multiRead);
RcppExport SEXP _SpliceWiz_SpliceWizMain_multi(SEXP reference_fileSEXP, SEXP bam_filesSEXP, SEXP output_filesSEXP, SEXP max_threadsSEXP, SEXP verboseSEXP, SEXP multiReadSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type reference_file(reference_fileSEXP);
    Rcpp::traits::input_parameter< StringVector >::type bam_files(bam_filesSEXP);
    Rcpp::traits::input_parameter< StringVector >::type output_files(output_filesSEXP);
    Rcpp::traits::input_parameter< int >::type max_threads(max_threadsSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< bool >::type multiRead(multiReadSEXP);
    rcpp_result_gen = Rcpp::wrap(SpliceWizMain_multi(reference_file, bam_files, output_files, max_threads, verbose, multiRead));
    return rcpp_result_gen;
END_RCPP
}
// c_GenerateMappabilityReads
int c_GenerateMappabilityReads(std::string genome_file, std::string out_fa, int read_len, int read_stride, int error_pos);
RcppExport SEXP _SpliceWiz_c_GenerateMappabilityReads(SEXP genome_fileSEXP, SEXP out_faSEXP, SEXP read_lenSEXP, SEXP read_strideSEXP, SEXP error_posSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type genome_file(genome_fileSEXP);
    Rcpp::traits::input_parameter< std::string >::type out_fa(out_faSEXP);
    Rcpp::traits::input_parameter< int >::type read_len(read_lenSEXP);
    Rcpp::traits::input_parameter< int >::type read_stride(read_strideSEXP);
    Rcpp::traits::input_parameter< int >::type error_pos(error_posSEXP);
    rcpp_result_gen = Rcpp::wrap(c_GenerateMappabilityReads(genome_file, out_fa, read_len, read_stride, error_pos));
    return rcpp_result_gen;
END_RCPP
}
// c_GenerateMappabilityRegions
int c_GenerateMappabilityRegions(std::string bam_file, std::string output_file, int threshold, int includeCov, bool verbose, int n_threads);
RcppExport SEXP _SpliceWiz_c_GenerateMappabilityRegions(SEXP bam_fileSEXP, SEXP output_fileSEXP, SEXP thresholdSEXP, SEXP includeCovSEXP, SEXP verboseSEXP, SEXP n_threadsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type bam_file(bam_fileSEXP);
    Rcpp::traits::input_parameter< std::string >::type output_file(output_fileSEXP);
    Rcpp::traits::input_parameter< int >::type threshold(thresholdSEXP);
    Rcpp::traits::input_parameter< int >::type includeCov(includeCovSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< int >::type n_threads(n_threadsSEXP);
    rcpp_result_gen = Rcpp::wrap(c_GenerateMappabilityRegions(bam_file, output_file, threshold, includeCov, verbose, n_threads));
    return rcpp_result_gen;
END_RCPP
}
// c_BAM2COV
int c_BAM2COV(std::string bam_file, std::string output_file, bool verbose, int n_threads, bool multiRead);
RcppExport SEXP _SpliceWiz_c_BAM2COV(SEXP bam_fileSEXP, SEXP output_fileSEXP, SEXP verboseSEXP, SEXP n_threadsSEXP, SEXP multiReadSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type bam_file(bam_fileSEXP);
    Rcpp::traits::input_parameter< std::string >::type output_file(output_fileSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    Rcpp::traits::input_parameter< int >::type n_threads(n_threadsSEXP);
    Rcpp::traits::input_parameter< bool >::type multiRead(multiReadSEXP);
    rcpp_result_gen = Rcpp::wrap(c_BAM2COV(bam_file, output_file, verbose, n_threads, multiRead));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_SpliceWiz_SpliceWizMain_hts", (DL_FUNC) &_SpliceWiz_SpliceWizMain_hts, 6},
    {"_SpliceWiz_c_BAM2COV_hts", (DL_FUNC) &_SpliceWiz_c_BAM2COV_hts, 5},
    {"_SpliceWiz_c_doNothing_hts", (DL_FUNC) &_SpliceWiz_c_doNothing_hts, 4},
    {"_SpliceWiz_Has_OpenMP", (DL_FUNC) &_SpliceWiz_Has_OpenMP, 0},
    {"_SpliceWiz_Test_OpenMP_For", (DL_FUNC) &_SpliceWiz_Test_OpenMP_For, 0},
    {"_SpliceWiz_c_Check_Cov", (DL_FUNC) &_SpliceWiz_c_Check_Cov, 1},
    {"_SpliceWiz_c_RLE_From_Cov", (DL_FUNC) &_SpliceWiz_c_RLE_From_Cov, 5},
    {"_SpliceWiz_c_Cov_Seqnames", (DL_FUNC) &_SpliceWiz_c_Cov_Seqnames, 1},
    {"_SpliceWiz_c_RLEList_From_Cov", (DL_FUNC) &_SpliceWiz_c_RLEList_From_Cov, 2},
    {"_SpliceWiz_c_gunzip_DF", (DL_FUNC) &_SpliceWiz_c_gunzip_DF, 2},
    {"_SpliceWiz_c_gunzip", (DL_FUNC) &_SpliceWiz_c_gunzip, 2},
    {"_SpliceWiz_SpliceWizMain", (DL_FUNC) &_SpliceWiz_SpliceWizMain, 6},
    {"_SpliceWiz_SpliceWizMain_multi", (DL_FUNC) &_SpliceWiz_SpliceWizMain_multi, 6},
    {"_SpliceWiz_c_GenerateMappabilityReads", (DL_FUNC) &_SpliceWiz_c_GenerateMappabilityReads, 5},
    {"_SpliceWiz_c_GenerateMappabilityRegions", (DL_FUNC) &_SpliceWiz_c_GenerateMappabilityRegions, 6},
    {"_SpliceWiz_c_BAM2COV", (DL_FUNC) &_SpliceWiz_c_BAM2COV, 5},
    {NULL, NULL, 0}
};

RcppExport void R_init_SpliceWiz(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
