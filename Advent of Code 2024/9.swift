func day9(for part: Part) throws {
    struct Block {
        let id: Int // ignored for free blocks
        var position: Int
        var length: Int
        var active = true
    }
    let chars = try String(contentsOfFile: path + "/9.txt", encoding: .utf8)
    let blockCounts = chars.compactMap(\.wholeNumberValue) // compactMap to ignore \n at end
    var fileId = 0
    var part1FileSystem = [Int?]() // Ints are file IDs; nils are free blocks
    var freeBlocks = [Block]()
    var files = [Block]()
    var position = 0

    for (index, blockCount) in blockCounts.enumerated() {
        let isFreeBlock = index % 2 == 1
        if part == .part1 {
            let num: Int? = isFreeBlock ? nil : fileId
            part1FileSystem.append(contentsOf: Array(repeating: num, count: blockCount))
        } else {
            let block = Block(id: fileId, position: position, length: blockCount)
            if isFreeBlock {
                freeBlocks.append(block)
            } else {
                files.append(block)
            }
        }
        if !isFreeBlock {
            fileId += 1
        }
        position += blockCount
    }
    printMap(part1FileSystem)

    var done = false

    if part == .part1 {
        while !done {
            let right = part1FileSystem.lastIndex { $0 != nil }!
            let left = part1FileSystem.firstIndex { $0 == nil }!
            if right > left {
                part1FileSystem[left] = part1FileSystem[right]
                part1FileSystem[right] = nil
                printMap(part1FileSystem)
            } else {
                done = true
            }
        }
    } else {
        for i in (0..<files.count).reversed() { // Iterate in reversed order
            let file = files[i]
            if let targetIndex = freeBlocks.firstIndex(where: { $0.length >= file.length && $0.active }) {
                var block = freeBlocks[targetIndex]
                files[i].position = block.position
                print("Moving file \(file.id) (len: \(file.length)) to position \(files[i].position)")

                if block.length == file.length { // Free block is completely filled
                    block.active = false
                } else { // Free block is partially filled
                    block.length -= file.length
                    block.position += file.length
                }

                freeBlocks[targetIndex] = block
            } else {
                print("No space found for \(file.id) (len: \(file.length))")
            }
        }
    }

    if part == .part2 { // Build the part 1 file system to use the same code for the checksum
        part1FileSystem = Array.init(repeating: nil, count: position)
        files.forEach { file in
            for offset in 0..<file.length {
                part1FileSystem[file.position + offset] = file.id
            }
        }
    }

    let checksum =
        part1FileSystem.enumerated().reduce(0) { (result, enumeratedItem) in
            let (position, fileId) = enumeratedItem
            return result + (fileId ?? 0) * position
        }
    print(checksum)
}

func printMap(_ map: [Int?]) {
    guard map.count <= 100 else {
        print("Map too big to print")
        return
    }
    print(map.map { $0.map(String.init) ?? "." }.joined())
}
