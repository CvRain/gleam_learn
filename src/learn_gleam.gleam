import app/router
import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  let secret_key = wisp.random_string(64)

  let assert Ok(_) =
    wisp_mist.handler(router.handle_request, secret_key)
    |> mist.new
    |> mist.port(4000)
    |> mist.start_http

  process.sleep_forever()
}
