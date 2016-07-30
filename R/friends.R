#' get_friends
#'
#' Requests information from Twitter's REST API
#' regarding a user's friend network (i.e., accounts followed
#' by a user). To request information on followers of accounts
#'
#' @param user Screen name or user id of target user.
#' @param token OAuth token (1.0 or 2.0)
#' @param page Default \code{page = -1} specifies first page
#'   of json results. Other pages specified via cursor values
#'   supplied by Twitter API response object.
#' @param stringify logical, indicating whether to return user
#'   ids as strings (some ids are too long to be read as numeric).
#'   Defaults to \code{TRUE}
#' @seealso See \url{https://dev.twitter.com/overview/documentation}
#'   for more information on using Twitter's API.
#' @return friends User ids for everyone a user follows.
#' @export
get_friends <- function(user, token = NULL, page = "-1",
                        stringify = TRUE) {

  params <- list(
    id_type = user,
    cursor = page,
    stringify = stringify)

  names(params)[1] <- .id_type(user)

  url <- make_url(restapi = TRUE, "friends/ids", params)

  if (is.null(token)) {
    token <- get_tokens()
    token <- fetch_tokens(token, "friends/ids")
  }

  resp <- TWIT(get = TRUE, url, token)

  fds <- from_js(resp)

  if (is.null(fds["ids"])) {
    return(list(ids = NA))
  }

  fds["ids"]
}