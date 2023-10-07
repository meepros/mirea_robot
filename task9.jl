include("library.jl")
robot = Robot(animate=true)
along!(robot, (Nord, Ost), 4)
function HSR.putmarker!(robot, steps)
    if mod(steps, 2) == 0
        putmarker!(robot)
    end
end   

function mark_row_chess!(robot, side, steps)
    putmarker!(robot, steps)
    while !isborder(robot, side)
        move!(robot, side)
        steps += 1
        putmarker!(robot, steps)
    end
    return steps
end
function mark_chess!(robot)
    to_west = num_steps_along!(robot, West)
    to_sud = num_steps_along!(robot, Sud)
    steps = to_west + to_sud
    side = Ost
    steps = mark_row_chess!(robot, side, steps)
    side = inverse(side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        steps += 1
        steps = mark_row_chess!(robot, side, steps)
        side = inverse(side)
    end
    along!(robot, West)
    along!(robot, Sud)
    along!(robot, Ost, to_west)
    along!(robot, Nord, to_sud)
end 
mark_chess!(robot)