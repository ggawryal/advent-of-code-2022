import java.io.File

val shapes = listOf(
    listOf("####"),
    listOf(
        ".#.",
        "###",
        ".#."
    ),
    listOf(
        "..#",
        "..#",
        "###"
    ),
    listOf(
        "#",
        "#",
        "#",
        "#"
    ),
    listOf(
        "##",
        "##"
    )
)

fun simulate(total: Long, movement: String): Long {
    val tower: MutableList<MutableList<Char>> = mutableListOf(".......".toMutableList())
    var jetPos: Int = 0
    var H: Int = 0
    var t: Long = -1

    var prevH: Int = 0
    var prevT = 0L
    var xtra: Long = 0
    while(t < total) {
        t += 1
        val block = shapes[(t%shapes.size.toLong()).toInt()]
        if(t%shapes.size.toLong() == 0L && jetPos%movement.length == 25) {
           if(t >= 100000) {
                println("skip")
                val it: Long = (total-t)/(t-prevT)
                xtra = it*1L*(H-prevH)
                t += it*1L*(t-prevT)
            }
            prevH = H
            prevT = t
        }

        var pos: MutableList<Pair<Int, Int> > = mutableListOf()
        for(i in 0..block.size-1)
            for(j in 0..block[i].length-1)
                if(block[i][j] == '#')
                    pos.add(Pair(H+2+block.size-i, j+2))
                    
        while(true) {
            val pos2 = pos.map {Pair(it.first, it.second + if(movement[jetPos%movement.length] == '>') 1 else -1)}
            jetPos += 1
            if(pos2.all {it.second >= 0 && it.second < tower[0].size && (it.first >= tower.size || tower[it.first][it.second] != '#')})
                pos = pos2.toMutableList()

            val pos3 = pos.map {Pair(it.first-1, it.second)}
            if(pos3.all {it.first >= 0 && (it.first >= tower.size || tower[it.first][it.second] != '#')} )
                pos = pos3.toMutableList()
            else {
                for((i,j) in pos) {
                    while(tower.size <= i)
                        tower.add(".......".toMutableList())
                    
                    tower[i][j] = '#'
                    H = if(H < i+1) i+1 else H
                }
                break
            }
        }
    }
    return H.toLong()+xtra
}

fun main() {
    val movement = File("input/day17.in").readLines()[0]
    println(simulate(2021, movement))
    println(simulate(1000000000000L-1, movement))
}