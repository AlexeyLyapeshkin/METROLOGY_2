
binaryList = regular("".join(message))
for binary in range(len(binaryList)):
    for indexString in range(len(matrixKey)):
        for indexSymbol in range(len(matrixKey[indexString])):
            if binaryList[binary][0] == matrixKey[indexString][indexSymbol]:
                y0, x0 = indexString, indexSymbol
            if binaryList[binary][1] == matrixKey[indexString][indexSymbol]:
                y1, x1 = indexString, indexSymbol
    for indexString in range(len(matrixKey)):
        if matrixKey[y0][x0] in matrixKey[indexString]:
            if mode == 'd':
                while x0 != 4:
                    x0 = x0 + 1
            else:
                while x0 != 0:
                    x0 = x0 - 1
for binary in range(len(binaryList)):
    for symbol in binaryList[binary]:
        final += symbol
return final
