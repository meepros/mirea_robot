include("library.jl")
robot = Robot("task7.sit", animate=true)
function find_hole!(robot)
    side = Nord
    for sides in (Nord, Sud, West, Ost)
         if Int(isborder(robot, sides)) > Int(isborder(robot, side))
             side = sides
         end
    end
    steps_len = 1
    steps_side = leftside(side)
    while isborder(robot, side)
         along!(robot, steps_side, steps_len)
         steps_side = inverse(steps_side)
         steps_len += 1
    end
    move!(robot, side)
 end
 find_hole!(robot)