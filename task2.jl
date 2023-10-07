include("library.jl")
robot = Robot(animate=true)
along!(robot, (Nord, Ost), 4) # пусть робот начинает с этой клетки
function mark_perimeter!(robot) # маркируем периметр нашего поля и возвращаемся на исходную позицию
    steps_sud = num_steps_along!(robot, Sud)
    steps_west = num_steps_along!(robot, West)
    for side in [Nord, Ost, Sud, West]
        mark_row!(robot, side)
    end
    along!(robot, Ost, steps_west)
    along!(robot, Nord, steps_sud)
end
mark_perimeter!(robot)