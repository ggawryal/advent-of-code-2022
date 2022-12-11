open Printf

let to_char_list s = List.init (String.length s) (String.get s)

let rec take k xs = if k == 0 then [] else match xs with
| [] -> failwith "take"
| x::xs -> if k=1 then [x] else x::take (k-1) xs

let rec drop k xs = if k == 0 then xs else match xs with
| [] -> failwith "drop"
| _::xs -> if k=0 then xs else drop (k-1) xs

let lines file =
  let contents = In_channel.with_open_bin file In_channel.input_all 
  in String.split_on_char '\n' contents

let add_to_stack s v = 
    if v == ' ' then s else List.append [v] s

let rec make_stack i desc =
    match desc with
    | [] -> []
    | x :: t -> 
        let newStack = make_stack i t
        in add_to_stack newStack (List.nth x (4*i+1) )

let rec make_stacks num_of_stacks desc  =
    match num_of_stacks with
    | -1 -> []
    | x -> List.append (make_stacks (x-1) desc) [make_stack x desc]

let is_stack_description line = String.contains line '['
let is_operation_description line = String.contains line 'm'

let contains1 line = String.contains line '1'

let get_num_of_stacks input = String.length (List.hd (List.filter contains1 input)) / 4

let rec modify_ith_stack stacks i f = 
    match stacks with
    | [] -> []
    | x::xs -> 
        let s = if (List.length stacks) != i then x else f x
        in List.append [s] (modify_ith_stack xs i f)

let push stacks into value = modify_ith_stack stacks into (fun x -> List.append x [value])

let pop stacks from = modify_ith_stack stacks from (fun x -> List.rev (List.tl (List.rev x) ) )

let getLast stacks from = List.hd (List.rev (List.nth stacks ((List.length stacks) - from) ) )

let reverse_top_k_elements stack k =
    let bottom = take ((List.length stack)-k) stack in
    let top = drop ((List.length stack)-k) stack in
    List.append bottom (List.rev top)

let prepare_stacks_to_subtask_2_operation stacks k into = modify_ith_stack stacks into (fun x -> reverse_top_k_elements x k)

let apply stacks from into =
    let v = getLast stacks from in
    let pushed = push stacks into v in
    pop pushed from

let rec apply_k_times stacks k from into = 
    match k with
    | 0 -> stacks
    | x -> apply_k_times (apply stacks from into) (x-1) from into

let apply_line stacks line subtask =
    let k, from, into  = Scanf.sscanf line "move %d from %d to %d" (fun x y z -> x, y, z) in
    let siz = List.length stacks in
    let stacks2 = if subtask == 1 then stacks else prepare_stacks_to_subtask_2_operation stacks k (siz - from + 1) in
    apply_k_times stacks2 k (siz - from + 1) (siz - into + 1)

let rec apply_all_operations stacks operations subtask =
    match operations with
    | [] -> stacks
    | x::xs -> apply_all_operations (apply_line stacks x subtask) xs subtask

let rec print_stack stack =
    match stack with
    | [] -> printf "\n"
    | x::xs -> printf "%c" x; print_stack xs

let rec tops stacks = 
    match stacks with
    | [] -> ""
    | x::xs -> (String.make 1 (List.hd (List.rev x))) ^ (tops xs) 

let () = 
    let input = lines "bin/input/day5.in" in
    let stacks = make_stacks (get_num_of_stacks input) (List.map to_char_list ( List.rev (List.filter is_stack_description input) ) ) in
    let s2 = apply_all_operations stacks (List.filter is_operation_description input) 2
    in List.iter (print_stack) s2; printf "Answer = %s\n" (tops s2)
    