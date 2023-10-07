include("library.jl")
robot = Robot("task6b.sit", animate=true);

function mark_perimeter!(robot) # маркируем периметр нашего поля и возвращаемся на исходную позицию
    steps_sud = num_steps_along!(robot, Sud)
    steps_west = num_steps_along!(robot, West)
    for side in [Nord, Ost, Sud, West]
        mark_row!(robot, side)
    end
    along!(robot, Ost, steps_west)
    along!(robot, Nord, steps_sud)
end

function mark_border_perimeter!(robot)
    A = to_start_position!(robot)
    mark_perimeter!(robot)
    for i in A
        along!(robot, i[1], i[2])
    end
end

mark_border_perimeter!(robot)