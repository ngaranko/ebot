-module(ebot_tasks_controller, [Req, SessionId]).
-compile(export_all).

index('GET', [], Context) ->
    Tasks = boss_db:find(task, []),
    {json, [{status, "ok"}, {tasks, Tasks}]}.
