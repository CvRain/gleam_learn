import app/web
import gleam/http.{Get, Post}
import gleam/string_tree
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use _req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> home_page(req)
    ["echo", name] -> echo_name(req, name)
    _ -> not_found(req)
  }
}

fn home_page(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  let html = string_tree.from_string("<h1>Home page</h1>")
  wisp.ok()
  |> wisp.html_body(html)
}

fn not_found(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  let html = string_tree.from_string("<h1>Not found</h1>")
  wisp.not_found()
  |> wisp.html_body(html)
}

fn echo_name(req: Request, name: String) -> Response {
  use <- wisp.require_method(req, Get)

  let html = string_tree.from_strings(["<h1>Hello ", name, "</h1>"])
  wisp.ok()
  |> wisp.html_body(html)
}
