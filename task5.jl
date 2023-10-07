include("library.jl")
robot = Robot("task5.sit", animate=true)
function mark_perimeter!(robot) # маркируем периметр нашего поля и возвращаемся на исходную позицию
    steps_sud = num_steps_along!(robot, Sud)
    steps_west = num_steps_along!(robot, West)
    for side in [Nord, Ost, Sud, West]
        mark_row!(robot, side)
    end
    along!(robot, Ost, steps_west)
    along!(robot, Nord, steps_sud)
end

function find_in_row!(robot, side)
    while !isborder(robot, side) & !isborder(robot, Nord)  
        move!(robot, side)
    end
    return !isborder(robot, Nord)
end

function find_border!(robot)
    side = Ost
    while find_in_row!(robot, side)
        move!(robot, Nord)
        side = inverse(side)
    end
    return !isborder(robot, Nord)
end

function mark_out_perimeter!(robot, sides)
    for side in sides
        while isborder(robot, rightside(side))
            putmarker!(robot)
            move!(robot, side)
        end
        putmarker!(robot)
        move!(robot, rightside(side))
        putmarker!(robot)
    end    
end

function mark_two_perimeters!(robot)
    steps_west_first = num_steps_along!(robot, West)
    steps_sud_second = num_steps_along!(robot, Sud)
    steps_west_third = num_steps_along!(robot, West)
    side = Ost
    mark_perimeter!(robot)
    find_border!(robot)
    if side == West
        while isborder(robot, Nord)
            move!(robot, West)
        end
        move!(robot, Ost)
    end
    mark_out_perimeter!(robot, (West, Nord, Ost, Sud))
    along!(robot, West)
    along!(robot, Sud)
    along!(robot, Ost, steps_west_third)
    along!(robot, Nord, steps_sud_second)
    along!(robot, Ost, steps_west_first)
end
mark_two_perimeters!(robot)