' vbc day19.vb -optimize
Imports System.IO
Imports System.Text.RegularExpressions
Imports System.Threading

Module Program
    Private Structure State
        Public time As Integer
        Public oreRobots As Integer
        Public clayRobots As Integer
        Public obsidianRobots As Integer
        Public geodeRobots As Integer
        Public clay As Integer
        Public obsidian As Integer
        Public geode As Integer

        Public Overrides Function GetHashCode() As Integer
            Return 7 * time + oreRobots * 31 + clay * 63 + obsidian * 127 + clayRobots * 255 + geode * 1023
        End Function

        Public Sub New(ByVal t As Integer, ByVal ror As Integer, ByVal rc As Integer, ByVal rob As Integer, ByVal rg As Integer, ByVal cc As Integer, ByVal cob As Integer, ByVal cg As Integer)
            time = t
            oreRobots = ror
            clayRobots = rc
            obsidianRobots = rob
            geodeRobots = rg
            clay = cc
            obsidian = cob
            geode = cg
        End Sub
        Public Sub New(ByVal state As State)
            time = state.time
            oreRobots = state.oreRobots
            clayRobots = state.clayRobots
            obsidianRobots = state.obsidianRobots
            geodeRobots = state.geodeRobots
            clay = state.clay
            obsidian = state.obsidian
            geode = state.geode
        End Sub
    End Structure

    Private Structure Costs
        Public oreRobotOreCost As Integer
        Public clayRobotOreCost As Integer
        Public obsidianRobotOreCost As Integer
        Public obsidianRobotClayCost As Integer
        Public geodeRobotOreCost As Integer
        Public geodeRobotObsidianCost As Integer

        Public Sub New(ByVal c1 As Integer, ByVal c2 As Integer, ByVal c3 As Integer, ByVal c4 As Integer, ByVal c5 As Integer, ByVal c6 As Integer)
            oreRobotOreCost = c1
            clayRobotOreCost = c2
            obsidianRobotOreCost = c3
            obsidianRobotClayCost = c4
            geodeRobotOreCost = c5
            geodeRobotObsidianCost = c6
        End Sub
    End Structure

    Private Function Solve(ByRef costs As Costs, ByVal iters As Integer)
        'dp[time][oreRobots][clayRobots][obsRobots][geodeRobots][clay][obsidian][geode] = max ore you can have at time t, (no key if scenario not possible)
        Dim dp As New Dictionary(Of State, Integer)
        Dim start As State = New State(1, 1, 0, 0, 0, 0, 0, 0)
        dp.Add(start, 0)
        Dim que As Queue = New Queue()
        que.Enqueue(start)

        Dim res As Integer = 0
        Dim resLowerBound As Integer = 0
        Dim PutToQueueIfNotPresentAndUpdateDp =
            Sub(state As State, ore As Integer, ByRef _costs As Costs)
                state.clayRobots = Math.Min(state.clayRobots, _costs.obsidianRobotClayCost)
                state.obsidianRobots = Math.Min(state.obsidianRobots, _costs.geodeRobotObsidianCost)
                state.oreRobots = Math.Min(state.oreRobots, Math.Max(Math.Max(_costs.geodeRobotOreCost, _costs.oreRobotOreCost), Math.Max(_costs.clayRobotOreCost, _costs.obsidianRobotClayCost)))
                If state.time = iters Then
                    res = Math.Max(res, state.geode + state.geodeRobots)
                    Return
                ElseIf state.time = iters - 1 Then
                    If ore >= _costs.geodeRobotOreCost And state.obsidian >= _costs.geodeRobotObsidianCost Then
                        state.geode += 1
                    End If
                    res = Math.Max(res, state.geode + 2 * state.geodeRobots)
                    Return
                ElseIf state.time = iters - 2 Then
                    state.clay = 0
                    state.clayRobots = 0
                ElseIf state.time >= iters - 3 Then
                    state.clayRobots = 0
                End If

                resLowerBound = Math.Max(resLowerBound, state.geode + state.geodeRobots * (iters - state.time + 1))
                Dim resUpperBound = state.geode + state.geodeRobots * (iters - state.time + 1) + (iters - state.time) * (iters - state.time + 1) \ 2
                If resUpperBound <= resLowerBound Then
                    Return
                End If
                If Not dp.ContainsKey(state) Then
                    dp(state) = ore
                    que.Enqueue(state)
                End If
                dp(state) = Math.Max(dp(state), ore)
            End Sub


        While que.Count > 0
            Dim state As State = que.Dequeue()

            Dim updated = New State(state)
            updated.time += 1
            updated.clay += state.clayRobots
            updated.obsidian += state.obsidianRobots
            updated.geode += state.geodeRobots

            Dim ore = dp(state)
            Dim newOreCount = ore + state.oreRobots

            Dim resUpperBound = state.geode + state.geodeRobots * (iters - state.time + 1) + (iters - state.time) * (iters - state.time + 1) \ 2
            If resUpperBound <= resLowerBound Then
                Continue While
            End If

            If ore >= costs.geodeRobotOreCost And state.obsidian >= costs.geodeRobotObsidianCost Then
                Dim s = New State(updated)
                s.obsidian -= costs.geodeRobotObsidianCost
                s.geodeRobots += 1
                PutToQueueIfNotPresentAndUpdateDp(s, newOreCount - costs.geodeRobotOreCost, costs)
            End If
            If ore >= costs.obsidianRobotOreCost And state.clay >= costs.obsidianRobotClayCost Then
                Dim s = New State(updated)
                s.clay -= costs.obsidianRobotClayCost
                s.obsidianRobots += 1
                PutToQueueIfNotPresentAndUpdateDp(s, newOreCount - costs.obsidianRobotOreCost, costs)
            End If
            If ore >= costs.clayRobotOreCost Then
                Dim s = New State(updated)
                s.clayRobots += 1
                PutToQueueIfNotPresentAndUpdateDp(s, newOreCount - costs.clayRobotOreCost, costs)
            End If
            If ore >= costs.oreRobotOreCost Then
                Dim s = New State(updated)
                s.oreRobots += 1
                PutToQueueIfNotPresentAndUpdateDp(s, newOreCount - costs.oreRobotOreCost, costs)
            End If
            PutToQueueIfNotPresentAndUpdateDp(updated, newOreCount, costs)
        End While
        Return res
    End Function

    Private Function getCosts(ByVal line As String) As Costs
        Dim robotDescs() As String = Split(line, ".")
        Return New Costs(
            Regex.Matches(robotDescs.GetValue(0), "(\d+) ore").First.Groups(1).Value,
            Regex.Matches(robotDescs.GetValue(1), "(\d+) ore").First.Groups(1).Value,
            Regex.Matches(robotDescs.GetValue(2), "(\d+) ore").First.Groups(1).Value,
            Regex.Matches(robotDescs.GetValue(2), "(\d+) clay").First.Groups(1).Value,
            Regex.Matches(robotDescs.GetValue(3), "(\d+) ore").First.Groups(1).Value,
            Regex.Matches(robotDescs.GetValue(3), "(\d+) obsidian").First.Groups(1).Value
        )
    End Function


    Sub Main()
        Dim lines As String() = File.ReadLines(Path.Combine("input", "day19.in")).ToArray()
        Dim res As Integer = 0
        Parallel.ForEach(lines,
            Sub(line)
                Dim blueprintId = CInt(Regex.Matches(line, "Blueprint (\d+)").First.Groups(1).Value)
                Dim caseRes = Solve(getCosts(line), 24)
                Console.WriteLine("Case {0}: {1}", blueprintId, caseRes)
                Interlocked.Add(res, caseRes * blueprintId)
            End Sub
        )
        Console.WriteLine(res)
        Dim lock = New Object
        Dim res2 As Long = 1
        Parallel.ForEach({lines(0), lines(1), lines(2)},
           Sub(line)
               Dim caseRes = Solve(getCosts(line), 32)
               Console.WriteLine("Res = {0}", caseRes)
               SyncLock lock
                   res2 *= caseRes
               End SyncLock
           End Sub
       )
        Console.WriteLine(res2)
    End Sub
End Module




