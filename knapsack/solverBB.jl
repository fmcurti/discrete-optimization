using DataStructures

struct Item
    index::Int32
    value::Int32
    weight::Int32
end

mutable struct Node
    level::Int32
    value::Int32
    estimate::Float32
    weight::Int32
    selected
end

function compare(x::Item)
    return float(-x.value/x.weight)
end



function get_estimate(node::Node,n::Int32,K::Int32,sorteditems)
    if node.weight > K
        return 0
    end


    estimate = node.value

    j = node.level + 1
    weight = node.weight

    while j <= n && ((weight + sorteditems[j].weight) <= K)
        weight += sorteditems[j].weight
        estimate += sorteditems[j].value
        j+=1
    end

    if j <= n
        estimate += (K - weight) * (sorteditems[j].value / sorteditems[j].weight)
    end
    return estimate
end

function solve(input)
    n,K,items = (0,0,0)
    if length(input) < 1
        n,K,items = parseFile("tmp.data")
    else 
        n,K,items = parseFile(input[1])
    end
    sort!(items,by=compare)
    selected = zeros(Int8,n)
    Q = Stack{Node}()
    u = Node(0,0,0,0,selected)

    push!(Q,u)

    best_value = 0
    while !isempty(Q)
        w = pop!(Q)
        if w.level == n
            continue
        end
        selected_new = copy(w.selected)
        selected_new[items[w.level+1].index] = 1
        v = Node(w.level+1,w.value + items[w.level+1].value,0,w.weight + items[w.level+1].weight,selected_new)

        if v.weight <= K && v.value > best_value
            selected = v.selected
            best_value = v.value
        end

        
        x = Node(w.level+1,w.value,0,w.weight,w.selected)
        x.estimate = get_estimate(x,n,K,items)

        if x.estimate > best_value
            push!(Q,x)
        end

        v.estimate = get_estimate(v,n,K,items)
        if v.estimate > best_value
           push!(Q,v)
        end



    end
    println("$best_value 1")
    str = ""
    for i in selected
        str = string(str,"$i ")
    end
    println(str)
end




function parseFile(file)
    lines = readlines(file)

    n,K = split(lines[1],' ')
    n = parse(Int32,n)
    K = parse(Int32,K)
    items = []
    i = 1
    for l in lines[2:end]
        v,w = split(l,' ')
        item = Item(i,parse(Int32,v),parse(Int32,w))
        push!(items,item)
        i+=1
    end
    return n,K,items
end

solve(ARGS)