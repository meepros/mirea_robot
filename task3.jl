include("library.jl")
robot = Robot(animate=true)
along!(robot, (Nord, Ost), 4) # пусть робот начинает с этой клетки
function mark_all!(robot) # маркируем все клетки поля и возвращаемся в исходную позицию
    steps_sud = num_steps_along!(robot, Sud)
    steps_west = num_steps_along!(robot, West)
    side = Ost
    mark_row!(robot, side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        mark_row!(robot, side)
    end
    along!(robot, West)
    along!(robot, Sud)
    along!(robot, Ost, steps_west)
    along!(robot, Nord, steps_sud)
end
mark_all!(robot)