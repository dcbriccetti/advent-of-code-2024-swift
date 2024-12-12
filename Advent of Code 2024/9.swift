func day9(for part: Part) throws {
    struct Block {
        let id: Int // ignored for free blocks
        var position: Int
        var length: Int
        var active = true
    }
    let chars = try String(contentsOfFile: path + "/9-test.txt", encoding: .utf8)
    let blockCounts = chars.compactMap { $0.wholeNumberValue } // compactMap to ignore \n at end
    var fileId = 0
    var filesMap = [Int?]()
    var freeBlocks = [Block]()
    var files = [Block]()
    var isFreeBlock = false
    var position = 0

    for blockCount in blockCounts {
        let num: Int? = isFreeBlock ? nil : fileId
        filesMap.append(contentsOf: Array(repeating: num, count: blockCount))
        let block = Block(id: fileId, position: position, length: blockCount)
        if isFreeBlock {
            freeBlocks.append(block)
        } else {
            files.append(block)
        }
        if !isFreeBlock {
            fileId += 1
        }
        isFreeBlock.toggle()
        position += blockCount
    }
    printMap(filesMap)

    var done = false

    if part == .part1 {
        while !done {
            let right = filesMap.lastIndex { $0 != nil }!
            let left = filesMap.firstIndex { $0 == nil }!
            if right > left {
                filesMap[left] = filesMap[right]
                filesMap[right] = nil
                printMap(filesMap)
            } else {
                done = true
            }
        }
    } else {
        for i in (0..<files.count).reversed() { // Iterate in reversed order
            let file = files[i]
            if let targetIndex = freeBlocks.firstIndex(where: { $0.length >= file.length && $0.active }) {
                var block = freeBlocks[targetIndex] // Store the block in a variable
                files[i].position = block.position
                print("Moving file \(file.id) (len: \(file.length)) to position \(files[i].position)")

                if block.length == file.length {
                    block.active = false
                } else {
                    block.length -= file.length
                    block.position += file.length
                }

                // Update the free block back into the array
                freeBlocks[targetIndex] = block
            } else {
                print("No space found for \(file.id) (len: \(file.length))")
            }
        }
    }

    let checksum = part == .part1
        ? filesMap.enumerated().reduce(0) { (result, enumeratedItem) in
            let (position, fileId) = enumeratedItem
            return result + (fileId ?? 0) * position
        }
        : files
            .map { file in
                (0..<file.length)
                    .map { offset in
                        (file.position + offset) * file.id
                    }
                    .reduce(0, +)
            }
            .reduce(0, +)
    print(checksum)
}

func printMap(_ map: [Int?]) {
    guard map.count <= 100 else {
        print("Map too big to print")
        return
    }
    print(map.map { $0.map(String.init) ?? "." }.joined())
}
