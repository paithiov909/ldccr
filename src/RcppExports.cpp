// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// sqids_encode
std::vector<std::string> sqids_encode(const std::vector<std::vector<uint64_t>>& numbers, const std::vector<uint64_t>& salt);
RcppExport SEXP _ldccr_sqids_encode(SEXP numbersSEXP, SEXP saltSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<std::vector<uint64_t>>& >::type numbers(numbersSEXP);
    Rcpp::traits::input_parameter< const std::vector<uint64_t>& >::type salt(saltSEXP);
    rcpp_result_gen = Rcpp::wrap(sqids_encode(numbers, salt));
    return rcpp_result_gen;
END_RCPP
}
// sqids_decode
std::vector<std::vector<int64_t>> sqids_decode(const std::vector<std::string>& ids);
RcppExport SEXP _ldccr_sqids_decode(SEXP idsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::vector<std::string>& >::type ids(idsSEXP);
    rcpp_result_gen = Rcpp::wrap(sqids_decode(ids));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_ldccr_sqids_encode", (DL_FUNC) &_ldccr_sqids_encode, 2},
    {"_ldccr_sqids_decode", (DL_FUNC) &_ldccr_sqids_decode, 1},
    {NULL, NULL, 0}
};

RcppExport void R_init_ldccr(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
