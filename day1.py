from sys import stdin

last = 0
best = []
i = 1
for s in stdin:
    if len(s) == 1:
        best += [last]
        last = 0
        i += 1
    else:
        last += int(s[:-1])

best = sorted(best)
print(best[-1] + best[-2] + best[-3])
