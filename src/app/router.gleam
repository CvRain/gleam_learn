import app/web.{type Context}
import gleam/string_tree
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  wisp.html_response(string_tree.from_string("Hello world!"), 200)
}
