include("library.jl")
robot = Robot(animate=true);
along!(robot, (Nord, Ost), 4) #пусть робот стоит здесь
function mark_square!(robot, n)
    side = Ost
    mark_row!(robot, side, n)
    for i in 1:(n-1)
        if !isborder(robot, Nord)
            move!(robot, Nord)
            mark_row!(robot, side, n)
        else
            return  along!(robot, Sud, i-1)
        end
    end
    along!(robot, Sud, n-1)
end

function mark_row_square!(robot, n)
    mark_square!(robot, n)
    while true
        if along!(robot, Ost, 2*n) == true
            mark_square!(robot, n)
        else
            along!(robot, West)
            break
        end
    end
end

function mark_chess_square!(robot, n)
    waytostart = to_start_position!(robot)
    mark_row_square!(robot, n)
    key = 0
    while along!(robot, Nord, n)
        key += 1
        if mod(key, 2) == 0
            mark_row_square!(robot, n)
        else
            if along!(robot, Ost, n)
                mark_row_square!(robot, n)
            end
            along!(robot, West)
        end
    end
    to_start_position!(robot)
    for i in waytostart
        along!(robot, i[1], i[2])
    end
end
mark_chess_square!(robot, 4)