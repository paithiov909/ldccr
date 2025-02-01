#ifndef R_NO_REMAP
#define R_NO_REMAP
#endif

#include <Rcpp.h>
#include "sqids/sqids.hpp"

//' Encode and decode 'Sqids'
//'
//' @param numbers A list of integers.
//' @param salt An integer vector.
//' @param ids A character vector.
//' @returns
//' For `sqids_encode()`, a list of integers.
//' For `sqids_decode()`, a character vector.
//' @rdname sqids_impl
//' @keywords internal
// [[Rcpp::export]]
std::vector<std::string> sqids_encode(
  const std::vector<std::vector<uint64_t>>& numbers,
  const std::vector<uint64_t>& salt
) {
  sqidscxx::Sqids sqids;
  std::vector<std::string> ids;
  for (const auto& number : numbers) {
    auto v = number;
    v.insert(v.end(), salt.begin(), salt.end());
    ids.emplace_back(sqids.encode(v));
  }
  return ids;
}

//' @rdname sqids_impl
//' @keywords internal
// [[Rcpp::export]]
std::vector<std::vector<int64_t>> sqids_decode(
  const std::vector<std::string>& ids
) {
  sqidscxx::Sqids sqids;
  std::vector<std::vector<int64_t>> numbers;
  for (const auto& id : ids) {
    const auto decoded = sqids.decode(id);
    numbers.emplace_back(decoded.begin(), decoded.end());
  }
  return numbers;
}
