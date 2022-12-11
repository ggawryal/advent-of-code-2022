
ropeLength = 10 # 2

def updateTail(head, tail)
    if head[0] != tail[0] && head[1] != tail[1] && (head[0]-tail[0]).abs() + (head[1]-tail[1]).abs() > 2
        tail[0] += (tail[0] < head[0] ? 1 : -1)        
        tail[1] += (tail[1] < head[1] ? 1 : -1)        
    elsif head[0] == tail[0]
        if head[1]-tail[1] > 1
            tail[1] += 1
        elsif tail[1]-head[1] > 1
            tail[1] -= 1
        end
    elsif head[1] == tail[1]
        if head[0]-tail[0] > 1
            tail[0] += 1
        elsif tail[0]-head[0] > 1
            tail[0] -= 1
        end
    end
    raise "zle" unless (head[0]-tail[0]).abs() <= 1 && (head[1]-tail[1]).abs() <= 1
end

elements = ([[0,0]]*ropeLength).map {|item| item.clone()}

dirs = {"R" => [1,0], 'L' => [-1,0], 'U' => [0,-1], 'D' => [0,1]}
visitedCnt = {[0,0] => 1}
visitedCnt.default = 0

File.readlines('input/day9.in').each do |line|
    direction, steps = line.split()
    Integer(steps).times {
        elements[0][0] += dirs[direction][0]
        elements[0][1] += dirs[direction][1]
        for i in 0..elements.length-2
            updateTail(elements[i], elements[i+1])
        end
        visitedCnt[elements[-1].clone()] += 1
    }
end

puts(visitedCnt.keys.length)