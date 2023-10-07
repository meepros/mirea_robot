include("library.jl")
robot = Robot(animate=true)
along!(robot, (Nord, Ost), 4) # пусть робот начинает с этой клетки
function mark_kross!(robot) # рисуем прямой крест вокруг нахождения робота
    for side in [Nord, Ost, Sud, West]
        steps = num_steps_markline!(robot, side)
        along!(robot, inverse(side), steps)
    end
    putmarker!(robot)
end
mark_kross!(robot)