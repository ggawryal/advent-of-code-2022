// node day11.js
const { assert } = require('console');
const fs = require('fs');

subtask = 2;
commonMultiply = 1;

fs.readFile('input/day11.in', 'utf8', (err, data) => {
    if (err) {
        console.error(err);
        return;
    }

    lines = data.split("\n");
    linesProcessed=0;
    function getLine() {
        do {
            linesProcessed += 1;
        }while(linesProcessed < lines.length && !lines[linesProcessed-1]);
        return lines[linesProcessed-1];
    }


    monkeys = [];
    while(currentLine = getLine()) {
        monkeyId = parseInt(currentLine.match(/Monkey (\d+)/i)[1]);
        startingItems = [...getLine().matchAll(/(\d+)/g)].map(x => parseInt(x[1]));

        operation = getLine();
        ops = [...operation.matchAll(/(\d+|old)/g)].map(x => x[1] == "old" ? x[1] : parseInt(x[1]));
        operationType = operation.match(/(\+|\*) (\d+|old)/i)[1];
        d = getLine().match(/(\d+)/i)[1];
        trueLink = parseInt(getLine().match(/(\d+)/i)[1]);
        falseLink = parseInt(getLine().match(/(\d+)/i)[1]);
        
        assert(trueLink != monkeyId);
        assert(falseLink != monkeyId);
        
        commonMultiply *= d

        monkeys[monkeyId] = {
            items: startingItems,
            a: ops[0],
            b: ops[1],
            d: d, 
            operationType: operationType,
            trueLink: trueLink,
            falseLink: falseLink,
            inspections: 0
        };
    }

    function update(monkey, val) {
        a = monkey.a == "old" ? val : monkey.a;
        b = monkey.b == "old" ? val : monkey.b;
        if(monkey.operationType == "+")
            a += b;
        else
            a *= b;
        if(subtask == 1)
            return Math.floor(a/3);
        else return a%commonMultiply;
    }

    function link(monkey, value) {
        if(value % parseInt(monkey.d) == 0)
            return monkey.trueLink;
        return monkey.falseLink;
    }
        
    for(round=0; round < (subtask == 1 ? 20 : 10000); round++) {
        for(monkey=0; monkey<monkeys.length; monkey++) {
            for(item of monkeys[monkey].items) {
                newItem = update(monkeys[monkey], item);
                monkeys[link(monkeys[monkey], newItem)].items.push(newItem);
                monkeys[monkey].inspections++;
            }
            monkeys[monkey].items = [];
        }
    }
    inspections = monkeys.map(x => x.inspections).sort((a,b) => b-a);
    console.log(inspections[0] * inspections[1]);
});
