import app/web
import gleam/string_tree
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use _req <- web.middleware(req)

  let body = string_tree.from_string("Hello world")

  wisp.html_response(body, 200)
}
