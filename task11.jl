include("library.jl")
robot = Robot("task1112.sit", animate=true)

function find_borders_in_row!(robot, side, borders_count)
    flag = false
    while !isborder(robot, side)
        if isborder(robot, Nord) & !flag
            borders_count += 1
            move!(robot, side)
            flag = true
        else
            move!(robot, side)
        end
        if !isborder(robot, Nord)
            flag = false
        end
    end
    return borders_count
end

function find_borders!(robot)
    waytostart = to_start_position!(robot)
    side = Ost
    borders_count = find_borders_in_row!(robot, side, 0)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        borders_count = find_borders_in_row!(robot, side, borders_count)
    end
    along!(robot, West)
    along!(robot, Sud)
    for i in waytostart
        along!(robot, i[1], i[2])
    end
    return borders_count - 1
end

find_borders!(robot)
