using Genie, Genie.Renderer.Json, Genie.Requests
using HTTP
using JSON

include("../src/GlobalBrain.jl")
using Main.GlobalBrain

Genie.Configuration.config!(
  server_port                     = 8000,
  server_host                     = "0.0.0.0",
)


@info "creating db..."

db = get_score_db(ENV["DATABASE_PATH"])

route("/score", method = POST) do
    message = rawpayload()
    parsed_message = JSON.parse(message)
    vote_events = map(parse_vote_event, parsed_message)

    results = "["
    n = 0

    map(vote_events) do vote_event
        emit_event =
            (score_or_effect) -> begin
                e = as_event(vote_event.vote_event_id, vote_event.vote_event_time, score_or_effect)
                insert_event(db, e)
                json_data = JSON.json(e)
                if n > 0
                  results *= ","
                end
                results *= json_data * "\n"
                n += 1
            end
        process_vote_event(emit_event, db, vote_event)
    end
    results *= "]"

    return results
end

up(async = false)

