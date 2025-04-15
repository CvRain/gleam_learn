import app/web
import gleam/dynamic/decode
import gleam/http.{Get, Post}
import gleam/json
import gleam/result
import gleam/string_tree
import wisp.{type Request, type Response}

pub type Person {
  Person(name: String, age: Int)
}

fn person_decorder() -> decode.Decoder(Person) {
  use name <- decode.field("name", decode.string)
  use age <- decode.field("age", decode.int)
  decode.success(Person(name:, age:))
}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> home_page(req)
    ["echo", name] -> echo_name(req, name)
    ["person"] -> post_person(req)
    ["person", "one"] -> one_person(req)
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

fn post_person(req: Request) -> Response {
  use <- wisp.require_method(req, Post)
  use json <- wisp.require_json(req)

  let result = {
    use person <- result.try(decode.run(json, person_decorder()))

    let object =
      json.object([
        #("name", json.string(person.name)),
        #("age", json.int(person.age)),
        #("saved", json.bool(True)),
      ])
    Ok(json.to_string_tree(object))
  }

  case result {
    Ok(json) -> wisp.json_response(json, 201)
    Error(_) -> wisp.unprocessable_entity()
  }
}

fn one_person(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  let response =
    json.object([#("name", json.string("John")), #("age", json.int(30))])
  wisp.json_response(json.to_string_tree(response), 200)
}
