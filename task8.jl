include("library.jl")
robot = Robot("task8.sit", animate=true)

function find_marker!(robot, side, steps)
    for _ in 1:steps
        if ismarker(robot)
            return true
        end
        move!(robot, side)
    end
    return false
end

function find_marker!(robot)
    side = Ost
    steps_len = 1
    counter = 0
    while !find_marker!(robot, side, steps_len)
        counter += 1
        side = rightside(side)
        steps_len += (mod(counter, 2) == 0)
    end  
end

find_marker!(robot)