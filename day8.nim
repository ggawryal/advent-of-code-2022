import strutils, sequtils

var 
    trees = readFile("input/day8.in").split('\n').filterIt(it.len > 0)
    n = trees.len
    m = trees[0].len

var 
    score = newSeq[seq[int]](n)
    touches = newSeq[seq[int]](n)
for i in 0..n-1:
    touches[i] = repeat(0,m)
    score[i] = repeat(1,m)

proc updateScore(iIndices: seq[int], jIndices: seq[int]) = 
    var 
        maxH = -1
        stack = toSeq([(10,0)])

    for cnti, i in iIndices:
        for cntj, j in jIndices:
            var v = int(trees[i][j]) - int('0')
            while stack[^1][0] < v:
                discard stack.pop()
            
            score[i][j] *= cnti + cntj - stack[^1][1]
            if stack.len == 1:
                touches[i][j] = 1
            stack.add((v,cnti+cntj))

proc reverse(s: seq[int]): seq[int] =
    for s in s:
        result = s & result

proc updateScoreAndRev(iIndices: seq[int], jIndices: seq[int]) =    
    updateScore(iIndices, jIndices)
    updateScore(reverse(iIndices), reverse(jIndices))

for i in 0..n-1:
    updateScoreAndRev(@[i],  toSeq(0..m-1))

for j in 0..m-1:
    updateScoreAndRev(toSeq(0..n-1),  @[j])

var 
    res1 = 0
    res2 = 0
for i in 0..n-1:
    for j in 0..m-1:
        res1 += touches[i][j]
        res2 = max(res2, score[i][j])

echo res1, " ", res2
    