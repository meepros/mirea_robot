include("library.jl")
robot = Robot(animate=true)
along!(robot, (Nord, Ost), 4) # пусть робот начинает с этой клетки
function mark_kross_x!(robot) # рисуем косой крест вокруг нахождения робота
    for side in [(Nord, Ost), (Ost, Sud), (Sud, West), (West, Nord)]
        steps = num_steps_markline!(robot, side)
        along!(robot, inverse(side), steps)
    end
    putmarker!(robot)
end
mark_kross_x!(robot)