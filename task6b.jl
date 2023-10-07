include("library.jl")
robot = Robot("task6b.sit", animate=true);

function mark4points!(robot)
    waytostart = to_start_position!(robot)
    position = [0, 0]
    for i in waytostart
        if i[1] == Ost
            position[1] += i[2]
        else
            position[2] += i[2]
        end
    end
    for side in [Nord, Ost, Sud, West]
        along!(robot, side, abs(position[2-mod(Int(side), 2)]))
        putmarker!(robot)
        position[2-mod(Int(side), 2)] = num_steps_along!(robot, side)
    end
    for i in waytostart
        along!(robot, i[1], i[2])
    end
end

mark4points!(robot)