# Takes a string as input from the user and
# prints out the first non-repeating character.
# After that, the program prints out the string,
# reordered by number of character appearances and
# original order from the input string. The program
# remembers string-case.
#
#
# If the user inputs "Bubble", the letter 'u' would
# be printed out (as the first non-repeating character),
# followed by "uleBbb" as the reordered string.

def getFirstNonRepChar(string):
    charMap = createCharCountMap(string)
    for char in string:
        if charMap[char.lower()] == 1:
            return char


def createCharCountMap(string="Bubble"):
    charMap = {}
    for char in string:
        charMap[char.lower()] = charMap.get(char.lower(), 0) + 1
    return charMap

def reorderStringByCharCounts(string="Bubble"):
    charMap = createCharCountMap(string)
    toReturn = ""
    minCount = min(list(charMap.items()), key=lambda x: x[1])[1]
    maxCount = max(list(charMap.items()), key=lambda x: x[1])[1]
    for charCount in range(minCount, maxCount + 1):
        for char in string:
            if charMap[char.lower()] == charCount:
                toReturn += char
    return toReturn

if __name__ == '__main__':
    i = input("Please enter a string: ")
    firstChar = getFirstNonRepChar(i)
    print(firstChar)

    reorderedStr = reorderStringByCharCounts(i)
    print(reorderedStr)

