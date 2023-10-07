using HorizonSideRobots
HSR = HorizonSideRobots
function HSR.move!(robot, side::Any) #полиметрический полиморфизм
    for s in side
        move!(robot, s)
    end
end
HSR.isborder(robot, side::Tuple{HorizonSide, HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2]) # 
inverse(side) = HorizonSide(mod(Int(side)+2, 4)) # разворот стороны на 180
leftside(side) = HorizonSide(mod(Int(side)+1, 4))
rightside(side) = HorizonSide(mod(Int(side)-1, 4))
inverse(side::Tuple{HorizonSide, HorizonSide}) = inverse.(side) #такой же разворот для всех сторон кортежа

function num_steps_along!(robot, side) # считает кол-во шагов для границы в заданную сторону и идем туда
    steps = 0
    while !isborder(robot, side)
        steps += 1
        move!(robot, side)
    end
    return steps
end

function along!(robot, side) # идем до упора в заданную сторону
    while !isborder(robot, side)
        move!(robot, side)
    end   
end

function along!(robot, side, steps) # метод along!, идем заданное кол-во шагов в заданную сторону
    for _ in 1:steps
        if !isborder(robot, side)
            move!(robot, side)
        else
            return false
        end
    end
    return true
end

function mark_row!(robot, side) # закрашиваем линию в заданном направлении до упора
    putmarker!(robot)
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
    end
end

function mark_row!(robot, side, steps)
    putmarker!(robot)
    for i in 1:(steps-1)
        if !isborder(robot, side)
            move!(robot, side)
            putmarker!(robot)
        else
            return along!(robot, inverse(side), i-1)
        end
    end
    along!(robot, inverse(side), steps-1)
end
 

function to_start_position!(robot)
    steps_array = []
    num = 1
    while !isborder(robot, Sud) | !isborder(robot, West)
        num += 1
        side = HorizonSide(mod(num, 2) + 1)
        steps = 0
        while !isborder(robot, side)
            move!(robot, side)
            steps += 1
        end
        push!(steps_array, (inverse(side), steps))
    end
    return reverse(steps_array)
end

function num_steps_markline!(robot, side) # маркируем в заданном направлении до упора и возвращаем пройденное кол-во шагов
    steps = 0
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
        steps += 1
    end
    return steps  
end

function mark_border_perimeter!(robot)
    A = to_start_position!(robot)
    mark_perimeter!(robot)
    for i in A
        along!(robot, i[1], i[2])
    end
end

function HSR.putmarker!(robot, steps)
    if mod(steps, 2) == 0
        putmarker!(robot)
    end
end 