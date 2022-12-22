program day18;

const
    SIZ = 22;
var
    inputfile: TextFile;
    line: String;
    lineNr: integer = 0;
    points: array [0..3000, 0..2] of integer;
    i: integer;
    j: integer;
    k: integer;
    t: integer;
    numberPos: integer;
    val: integer;
    res: integer;

    isExternal: array [0..SIZ, 0..SIZ, 0..SIZ] of integer;
    visited: array [0..SIZ, 0..SIZ, 0..SIZ] of integer;

    dfsstack: array[0..10000, 0..2] of integer;
    stackSize: integer = 0;
    cur: array[0..2] of integer;

procedure stackPush(x,y,z : integer); 
begin
    dfsstack[stackSize][0] := x;
    dfsstack[stackSize][1] := y;
    dfsstack[stackSize][2] := z;
    stackSize := stackSize + 1;
end;

procedure stackPop(); 
begin
    stackSize := stackSize - 1;
    cur[0] := dfsstack[stackSize][0];
    cur[1] := dfsstack[stackSize][1];
    cur[2] := dfsstack[stackSize][2];
end;

begin
    assign(inputfile, 'input/day18.in');
    reset(inputfile);

    lineNr := 0;
    while not eof(inputfile) do
    begin
        readLn(inputfile, line);
        line := line + ',';
        val := 0;
        numberPos := 0;
        for i:=1 to length(line) do
        begin
            if line[i] = ',' then begin
                points[lineNr][numberPos] := val+1;
                val := 0;
                numberPos := numberPos + 1;
            end
            else
                val := val * 10 + (ord(line[i])-ord('0'));
        end;
        lineNr := lineNr + 1;
    end;

    res := lineNr*6;
    for i := 0 to lineNr-1 do begin
        visited[points[i][0], points[i][1], points[i][2]] := 1;
        isExternal[cur[0]][cur[1]][cur[2]] := 0;
        for j := i+1 to lineNr-1 do begin
            if abs(points[i][0]-points[j][0]) + abs(points[i][1] - points[j][1]) + abs(points[i][2] - points[j][2]) = 1 then
                res := res - 2;
        end;
    end;
    writeln(res);

    isExternal[0][0][0] := 1;
    stackPush(0,0,0);
    while stackSize > 0 do begin
        stackPop();
        visited[cur[0]][cur[1]][cur[2]] := 1;
        isExternal[cur[0]][cur[1]][cur[2]] := 1;
        for i := -1 to 1 do
            for j := -1 to 1 do
                for k := -1 to 1 do
                    if (abs(i) + abs(j) + abs(k) = 1) and (cur[0]+i >= 0) and (cur[1]+j >= 0) and (cur[2]+k >= 0) and (cur[0]+i <= SIZ) and (cur[1]+j <= SIZ) and (cur[2]+k <= SIZ) and (visited[cur[0]+i][cur[1]+j][cur[2]+k] = 0) then begin
                        visited[cur[0]+i][cur[1]+j][cur[2]+k] := 1;
                        stackPush(cur[0]+i, cur[1]+j, cur[2]+k);
                    end;
    end;

    res := 0;
    for t := 0 to lineNr-1 do
        for i := -1 to 1 do
            for j := -1 to 1 do
                for k := -1 to 1 do
                    if (abs(i) + abs(j) + abs(k) = 1) and (isExternal[points[t][0]+i][points[t][1]+j][points[t][2]+k] = 1) then
                        res := res + 1;

    writeln(res);

end.
