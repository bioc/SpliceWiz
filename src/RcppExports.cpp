// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// idxstats_pbam
int idxstats_pbam(std::string bam_file, int n_threads_to_use);
RcppExport SEXP _SpliceWiz_idxstats_pbam(SEXP bam_fileSEXP, SEXP n_threads_to_useSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type bam_file(bam_fileSEXP);
    Rcpp::traits::input_parameter< int >::type n_threads_to_use(n_threads_to_useSEXP);
    rcpp_result_gen = Rcpp::wrap(idxstats_pbam(bam_file, n_threads_to_use));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_SpliceWiz_idxstats_pbam", (DL_FUNC) &_SpliceWiz_idxstats_pbam, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_SpliceWiz(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
