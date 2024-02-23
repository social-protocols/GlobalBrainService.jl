compile:
    julia --project compile.jl

runbin:
    ./build/bin/ScheduledScoring $DATABASE_PATH $VOTE_EVENTS_PATH

run:
    tail -f $VOTE_EVENTS_PATH | julia --project -- scripts/run.jl $DATABASE_PATH - $SCORE_EVENTS_PATH

dev:
    julia --eval "using Pkg; Pkg.develop(path = pwd())"

sqlite:
    sqlite3 $DATABASE_PATH

reset-db:
    rm -f $DATABASE_PATH
    sqlite3 $DATABASE_PATH < sql/tables.sql
    sqlite3 $DATABASE_PATH < sql/views.sql
    sqlite3 $DATABASE_PATH < sql/triggers.sql
#    sqlite3 $DATABASE_PATH < sql/import-vote-events.sql

import-vote-events:
    sqlite3 $DATABASE_PATH < sql/import-vote-events.sql
