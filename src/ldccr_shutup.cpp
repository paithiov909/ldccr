#include "checker.h"
#include <Rcpp.h>

//' @noRd
//' @keywords internal
// [[Rcpp::export]]
Rcpp::LogicalVector is_uncensored_impl(
    std::vector<std::string> x,
    std::vector<std::string> dict
) {
  shutup::Checker c("jp", nullptr);

  for (const auto& str: dict) {
    c.add(str.c_str());
  }

  int start, count;
  bool f;
  std::vector<bool> ret;
  ret.reserve(x.size());
  for (const auto& str: x) {
    const char* input = str.c_str();
    int ilen = strlen(input);
    f = c.should_filter(input, ilen, &start, &count);
    ret.push_back(f);
  }

  return Rcpp::wrap(ret);
}
