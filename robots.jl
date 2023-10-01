using HorizonSideRobots

HSR = HorizonSideRobots

function HSR.move!(robot, side::Any) #полиметрический полиморфизм
    for s in side
        move!(robot, s)
    end
end

HSR.isborder(robot, side::Tuple{HorizonSide, HorizonSide}) = isborder(robot, side[1]) || isborder(robot, side[2]) # 

robot = Robot(animate=true);

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
        move!(robot, side)
    end
end

function count_row_markers!(robot, side) # считает сколько маркеров в заданном направлении до упора
    num_markers = ismarker(robot)
    while !isborder(robot, side)
        move!(robot, side)
        num_markers += ismarker(robot)
    end
    return num_markers
end

function count_all_markers!(robot) # считаем все маркеры на поле и возвращаемся в исходную позицию
    steps_west = num_steps_along!(robot, West)
    steps_sud = num_steps_along!(robot, Sud)
    side = Ost
    num_all_markers = count_row_markers!(robot, side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        num_all_markers += count_row_markers!(robot, side)
    end
    along!(robot, West)
    along!(robot, Sud)
    along!(robot, Ost, steps_west)
    along!(robot, Nord, steps_sud)
    return num_all_markers
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

function mark_kross!(robot) # рисуем прямой крест вокруг нахождения робота
    for side in [Nord, Ost, Sud, West]
        steps = num_steps_markline!(robot, side)
        along!(robot, inverse(side), steps)
    end
end

function mark_kross_x!(robot) # рисуем косой крест вокруг нахождения робота
    for side in [(Nord, Ost), (Ost, Sud), (Sud, West), (West, Nord)]
        steps = num_steps_markline!(robot, side)
        along!(robot, inverse(side), steps)
    end
end

function mark_row!(robot, side) # закрашиваем линию в заданном направлении до упора
    putmarker!(robot)
    while !isborder(robot, side)
        move!(robot, side)
        putmarker!(robot)
    end
end
 
function mark_perimeter!(robot) # маркируем периметр нашего поля и возвращаемся на исходную позицию
    steps_sud = num_steps_along!(robot, Sud)
    steps_west = num_steps_along!(robot, West)
    for side in [Nord, Ost, Sud, West]
        mark_row!(robot, side)
    end
    along!(robot, Ost, steps_west)
    along!(robot, Nord, steps_sud)
end

function mark_out_perimeter!(robot, sides)
    for side in sides
        while isborder(robot, leftside(side))
            putmarker!(robot)
            move!(robot, side)
        end
        putmarker!(robot)
        move!(robot, leftside(side))
        putmarker!(robot)
    end    
end

function mark_all!(robot) # маркируем все клетки поля и возвращаемся в исходную позицию
    steps_sud = num_steps_along!(robot, Sud)
    steps_west = num_steps_along!(robot, West)
    side = Ost
    mark_row!(robot, side)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        mark_row!(robot, side)
    end
    along!(robot, West)
    along!(robot, Sud)
    along!(robot, Ost, steps_west)
    along!(robot, Nord, steps_sud)
end
"""
function find_in_row!(robot, side)
    while !isborder(robot, side) & !isborder(robot, Nord)  
        move!(robot, side)
end
function find_border!(robot)
    side = Ost
    while find_in_row!(robot, side)
        move!(robot, Nord)
        side = inverse(side)
    end
    return !isborder(robot, Nord)
end
"""
function mark_two_perimeters!(robot)
    steps_west_first = num_steps_along!(robot, West)
    steps_sud_second = num_steps_along!(robot, Sud)
    steps_west_third = num_steps_along!(robot, West)
    side = Ost
    mark_perimeter!(robot)
    while !isborder(robot, side) & !isborder(robot, Nord)
        move!(robot, side)
    end
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        while !isborder(robot, side) & !isborder(robot, Nord)
            move!(robot, side)
        end
    end
    if side == West
        while isborder(robot, Nord)
            move!(robot, West)
        end
        move!(robot, Ost)
    end
    mark_out_perimeter!(robot, (Ost, Nord, West, Sud))
    along!(robot, West)
    along!(robot, Sud)
    along!(robot, Ost, steps_west_third)
    along!(robot, Nord, steps_sud_second)
    along!(robot, Ost, steps_west_first)
end

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
   move!(robot, Nord)
end

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

function try_move!(robot, side) #
    return !isborder(robot, side)
end

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
    to_start_position!(robot)
    side = Ost
    borders_count = find_borders_in_row!(robot, side, 0)
    while !isborder(robot, Nord)
        move!(robot, Nord)
        side = inverse(side)
        borders_count = find_borders_in_row!(robot, side, borders_count)
    end
    return borders_count - 1
end
