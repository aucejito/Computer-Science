def giroRotores(dic, key):
    res = {}
    for clave, valor in dic.items():
        if(valor<key):
            valor = 27-key+valor
        else:
            valor = valor-key+1
        res[clave]=valor
    return res

def rotacion(dic):
    for clave, valor in dic.items():
        if(valor>1):
            valor -= 1
        else:
            valor = 26
        dic[clave] = valor
    pass

def inverso(dic):
    dicInv = {}
    for clave, valor in dic.items():
        dicInv[valor] = clave
    return dicInv

def cifrarEnigma(letra, alfInternoI, alfInternoIinv, rotorI, rotorIinv, alfInternoII, alfInternoIIinv, rotorII, rotorIIinv, alfInternoIII, alfInternoIIIinv, rotorIII, rotorIIIinv, letraClaveEntrada):
    """Llevamos a cabo el giro de los rotores y de sus alfabetos internos"""
    rotacion(alfInternoIII)
    alfInternoIIIinv = inverso(alfInternoIII)
    rotacion(rotorIIIinv)
    rotorIII = inverso(rotorIIIinv)
    if((alfInternoIIIinv[1]==giros1[orden[2]]) or (orden[2] in ['6','7','8'] and alfInternoIIIinv[1]=='N')):
        rotacion(alfInternoII)
        alfInternoIIinv = inverso(alfInternoII)
        rotacion(rotorIIinv)
        rotorII = inverso(rotorIIinv)
    if((alfInternoIIinv[1]==giros2[orden[1]] or (orden[1] in ['6','7','8'] and alfInternoIIinv[1]=='M')) and (alfInternoIIIinv[1]==giros3[orden[2]] or (orden[2] in ['6','7','8'] and alfInternoIIIinv[1]=='L'))):
        rotacion(alfInternoII)
        alfInternoIIinv = inverso(alfInternoII)
        rotacion(rotorIIinv)
        rotorII = inverso(rotorIIinv)
        rotacion(alfInternoI)
        alfInternoIinv = inverso(alfInternoI)
        rotacion(rotorIinv)
        rotorI = inverso(rotorIinv)
    """Llevamos a cabo el proceso de cifrado/descifrado de la letra en cuestión"""
    entradaII = alfInternoIII[rotorIII[clavesAlfanumericas[letra]]]
    entradaI = alfInternoII[rotorII[entradaII]]
    if(modelo==5 or modelo==6):
        entradaIV = alfInternoI[rotorI[entradaI]]
        retorno = reflector[alfInternoIV[rotorIV[entradaIV]]]
        entradaI = rotorIVinv[alfInternoIVinv[retorno]]
        entradaII = rotorIinv[alfInternoIinv[entradaI]]
        entradaIII = rotorIIinv[alfInternoIIinv[entradaII]]
        letraCifrada = clavesAlfanumericasInv[rotorIIIinv[alfInternoIIIinv[entradaIII]]]
        return [letraCifrada, alfInternoI, alfInternoIinv, rotorI, rotorIinv, alfInternoII, alfInternoIIinv, rotorII, rotorIIinv, alfInternoIII, alfInternoIIIinv, rotorIII, rotorIIIinv]
    else:
        retorno = reflector[alfInternoI[rotorI[entradaI]]]
        entradaII = rotorIinv[alfInternoIinv[retorno]]
        entradaIII = rotorIIinv[alfInternoIIinv[entradaII]]
        letraCifrada = clavesAlfanumericasInv[rotorIIIinv[alfInternoIIIinv[entradaIII]]]
        return [letraCifrada, alfInternoI, alfInternoIinv, rotorI, rotorIinv, alfInternoII, alfInternoIIinv, rotorII, rotorIIinv, alfInternoIII, alfInternoIIIinv, rotorIII, rotorIIIinv]

if __name__ == "__main__":
    """Definimos los rotores que puede usar Enigma (Wehrmacht trabaja solo con los tres primeros y los dos últimos solo los usan las máquinas de 4 rotores)"""
    r1 = {'E':1,'K':2,'M':3,'F':4,'L':5,'G':6,'D':7,'Q':8,'V':9,'Z':10,'N':11,'T':12,'O':13,'W':14,'Y':15,'H':16,'X':17,'U':18,'S':19,'P':20,'A':21,'I':22,'B':23,'R':24,'C':25,'J':26}
    r2 = {'A':1,'J':2,'D':3,'K':4,'S':5,'I':6,'R':7,'U':8,'X':9,'B':10,'L':11,'H':12,'W':13,'T':14,'M':15,'C':16,'Q':17,'G':18,'Z':19,'N':20,'P':21,'Y':22,'F':23,'V':24,'O':25,'E':26}
    r3 = {'B':1,'D':2,'F':3,'H':4,'J':5,'L':6,'C':7,'P':8,'R':9,'T':10,'X':11,'V':12,'Z':13,'N':14,'Y':15,'E':16,'I':17,'W':18,'G':19,'A':20,'K':21,'M':22,'U':23,'S':24,'Q':25,'O':26}
    r4 = {'E':1,'S':2,'O':3,'V':4,'P':5,'Z':6,'J':7,'A':8,'Y':9,'Q':10,'U':11,'I':12,'R':13,'H':14,'X':15,'L':16,'N':17,'F':18,'T':19,'G':20,'K':21,'D':22,'C':23,'M':24,'W':25,'B':26}
    r5 = {'V':1,'Z':2,'B':3,'R':4,'G':5,'I':6,'T':7,'Y':8,'U':9,'P':10,'S':11,'D':12,'N':13,'H':14,'L':15,'X':16,'A':17,'W':18,'M':19,'J':20,'Q':21,'O':22,'F':23,'E':24,'C':25,'K':26}
    r6 = {'J':1,'P':2,'G':3,'V':4,'O':5,'U':6,'M':7,'F':8,'Y':9,'Q':10,'B':11,'E':12,'N':13,'H':14,'Z':15,'R':16,'D':17,'K':18,'A':19,'S':20,'X':21,'L':22,'I':23,'C':24,'T':25,'W':26}
    r7 = {'N':1,'Z':2,'J':3,'H':4,'G':5,'R':6,'C':7,'X':8,'M':9,'Y':10,'S':11,'W':12,'B':13,'O':14,'U':15,'F':16,'A':17,'I':18,'V':19,'L':20,'P':21,'E':22,'K':23,'Q':24,'D':25,'T':26}
    r8 = {'F':1,'K':2,'Q':3,'H':4,'T':5,'L':6,'X':7,'O':8,'C':9,'B':10,'J':11,'S':12,'P':13,'D':14,'Z':15,'R':16,'A':17,'M':18,'E':19,'W':20,'N':21,'I':22,'U':23,'Y':24,'G':25,'V':26}
    beta = {'L':1,'E':2,'Y':3,'J':4,'V':5,'C':6,'N':7,'I':8,'X':9,'W':10,'P':11,'B':12,'Q':13,'M':14,'D':15,'R':16,'T':17,'A':18,'K':19,'Z':20,'G':21,'F':22,'U':23,'H':24,'O':25,'S':26} 
    gamma = {'F':1,'S':2,'O':3,'K':4,'A':5,'N':6,'U':7,'E':8,'R':9,'H':10,'M':11,'B':12,'T':13,'I':14,'Y':15,'C':16,'W':17,'L':18,'Q':19,'P':20,'Z':21,'X':22,'V':23,'G':24,'J':25,'D':26}
    
    """Definimos los reflectores que puede usar Enigma (Los dos últimos los usan las máquinas de 4 rotores)"""
    B3 = {1:25,2:18,3:21,4:8,5:17,6:19,7:12,8:4,9:16,10:24,11:14,12:7,13:15,14:11,15:13,16:9,17:5,18:2,19:6,20:26,21:3,22:23,23:22,24:10,25:1,26:20}
    C3 = {1:6,2:22,3:16,4:10,5:9,6:1,7:15,8:25,9:5,10:4,11:18,12:26,13:24,14:23,15:7,16:3,17:20,18:11,19:21,20:17,21:19,22:2,23:14,24:13,25:8,26:12}
    B4 = {1:5,2:14,3:11,4:17,5:1,6:21,7:25,8:23,9:10,10:9,11:3,12:15,13:16,14:2,15:12,16:13,17:4,18:24,19:26,20:22,21:6,22:20,23:8,24:18,25:7,26:19}
    C4 = {1:18,2:4,3:15,4:2,5:10,6:14,7:20,8:11,9:22,10:5,11:8,12:13,13:12,14:6,15:3,16:23,17:26,18:1,19:24,20:7,21:25,22:9,23:16,24:19,25:21,26:17}

    """Creamos un diccionario para señalar la letra del rotor que hace que el de su izquierda gire"""
    giros1 = {'1':'R','2':'F','3':'W','4':'K','5':'A','6':'A','7':'A','8':'A'}
    giros2 = {'1':'Q','2':'E','3':'V','4':'J','5':'Z','6':'Z','7':'Z','8':'Z'}
    giros3 = {'1':'S','2':'G','3':'X','4':'L','5':'B','6':'B','7':'B','8':'B'}

    """Creamos una lista donde guardaremos los rotores que elija el usuario"""
    rotores = []
    
    print(" ---------------------------------------------------------------------------------------------")
    print("|         BIENVENIDO AL SIMULADOR DE LA MÁQUINA ENIGMA PARA CIFRAR/DESCIFRAR MENSAJES         |")
    print(" ---------------------------------------------------------------------------------------------")

    print("\nSeleccione qué tipo de máquina Enigma desea simular (Teclee un número del 1 al 6 y presione Enter):\n")
    print("(1) Wehrmacht - UKW = B")
    print("(2) Wehrmacht - UKW = C")
    print("(3) Kriegsmarine M3 - UKW = B")
    print("(4) Kriegsmarine M3 - UKW = C")
    print("(5) Kriegsmarine M4 - UKW = B")
    print("(6) Kriegsmarine M4 - UKW = C")
    aux = False
    while(not aux):
        modelo = int(input())
        if(modelo in range(1,7)):
            aux=True
        else:
            print("\nEntrada incorrecta. Por favor, introduzca un número del 1 al 6\n")

    if(modelo==1 or modelo==2):
        rotores = [[],[],[]]
        if(modelo==1):
            reflector = B3
        else:
            reflector = C3
        print("Dispone de 5 rotores, escriba cuáles desea usar y el orden para situarlos (123, 142, 253...)")
        aux = False
        while(not aux):
            orden=input()
            if(len(orden)==3):
                aux=True
            else:
                print("\nEntrada incorrecta. Por favor, escriba un orden de rotores válido\n")
        cont = 0
        for i in orden:
            if(i=='1'): rotores[cont] = r1
            if(i=='2'): rotores[cont] = r2
            if(i=='3'): rotores[cont] = r3
            if(i=='4'): rotores[cont] = r4
            if(i=='5'): rotores[cont] = r5
            cont = cont+1
    if(modelo==3 or modelo==4):
        rotores = [[],[],[]]
        if(modelo==3):
            reflector = B3
        else:
            reflector = C3
        print("Dispone de 8 rotores, escriba cuáles desea usar y el orden para situarlos (127, 146, 853...)")
        aux = False
        while(not aux):
            orden=input()
            if(len(orden)==3):
                aux=True
            else:
                print("\nEntrada incorrecta. Por favor, escriba un orden de rotores válido\n")
        cont = 0
        for i in orden:
            if(i=='1'): rotores[cont] = r1
            if(i=='2'): rotores[cont] = r2
            if(i=='3'): rotores[cont] = r3
            if(i=='4'): rotores[cont] = r4
            if(i=='5'): rotores[cont] = r5
            if(i=='6'): rotores[cont] = r6
            if(i=='7'): rotores[cont] = r7
            if(i=='8'): rotores[cont] = r8
            cont = cont+1
    if(modelo==5 or modelo==6):
        rotores = [[],[],[],[]]
        if(modelo==5):
            reflector = B4
        else:
            reflector = C4
        print("Dispone de 8 rotores para las tres primeras posiciones, escriba cuáles desea usar y el orden para situarlos (127, 146, 853...)")
        aux = False
        while(not aux):
            orden=input()
            if(len(orden)==3):
                aux=True
            else:
                print("\nEntrada incorrecta. Por favor, escriba un orden de rotores válido\n")
        cont = 0
        for i in orden:
            if(i=='1'): rotores[cont] = r1
            if(i=='2'): rotores[cont] = r2
            if(i=='3'): rotores[cont] = r3
            if(i=='4'): rotores[cont] = r4
            if(i=='5'): rotores[cont] = r5
            if(i=='6'): rotores[cont] = r6
            if(i=='7'): rotores[cont] = r7
            if(i=='8'): rotores[cont] = r8
            cont = cont+1
        print("Dispone de 2 rotores para colocar en la última posición, elija cuál desea usar:\n")
        print("(1) Rotor beta")
        print("(2) Rotor gamma")
        aux = False
        while(not aux):
            cuarto=input()
            if(cuarto=='1' or cuarto=='2'):
                aux=True
            else:
                print("\nEntrada incorrecta. Por favor, escriba un orden de rotores válido\n")
        if(cuarto=='1'):
            rotores[3] = beta
        else:
            rotores[3] = gamma

    print("Introduzca clave de tres letras (si la máquina es de 3 rotores) o de 4 letras (si la máquina es de 4 rotores) (en mayúsculas): ")
    letraClaveEntrada = input()

    print("Introduzca mensaje a cifrar/descifrar (en mayúsculas): ")
    mensaje = input()

    clavesAlfanumericas = {'A':1,'B':2,'C':3,'D':4,'E':5,'F':6,'G':7,'H':8,'I':9,'J':10,'K':11,'L':12,'M':13,'N':14,'O':15,'P':16,'Q':17,'R':18,'S':19,'T':20,'U':21,'V':22,'W':23,'X':24,'Y':25,'Z':26}
    clavesAlfanumericasInv = inverso(clavesAlfanumericas)

    if(modelo==5 or modelo==6):
        aux = letraClaveEntrada[0]
        letraClaveEntrada = letraClaveEntrada[1:len(letraClaveEntrada)]
        claveEntradaIV = clavesAlfanumericas[aux]
        
        alfInternoIV = clavesAlfanumericas
        alfInternoIV = giroRotores(alfInternoIV, claveEntradaIV)
        alfInternoIVinv = inverso(alfInternoIV)

        rotorIVinv = rotores[3]
        rotorIVinv = giroRotores(rotorIVinv, claveEntradaIV)
        rotorIV = inverso(rotorIVinv)

    claveEntradaI = clavesAlfanumericas[letraClaveEntrada[0]]
    claveEntradaII = clavesAlfanumericas[letraClaveEntrada[1]]
    claveEntradaIII = clavesAlfanumericas[letraClaveEntrada[2]]

    alfInternoIII = clavesAlfanumericas
    alfInternoIII = giroRotores(alfInternoIII, claveEntradaIII)
    alfInternoIIIinv = inverso(alfInternoIII)
    alfInternoII = clavesAlfanumericas
    alfInternoII = giroRotores(alfInternoII, claveEntradaII)
    alfInternoIIinv = inverso(alfInternoII)
    alfInternoI = clavesAlfanumericas
    alfInternoI = giroRotores(alfInternoI, claveEntradaI)
    alfInternoIinv = inverso(alfInternoI)

    rotorIIIinv = rotores[2] 
    rotorIIIinv = giroRotores(rotorIIIinv, claveEntradaIII)
    rotorIII = inverso(rotorIIIinv)
    rotorIIinv = rotores[1]
    rotorIIinv = giroRotores(rotorIIinv, claveEntradaII)
    rotorII = inverso(rotorIIinv)
    rotorIinv = rotores[0]
    rotorIinv = giroRotores(rotorIinv, claveEntradaI)
    rotorI = inverso(rotorIinv)

    letras = clavesAlfanumericas.keys()
    respuesta = ''
    iteracion = 0
    for letra in mensaje:
        if(letra not in letras):
            respuesta += letra
        else:
            iteracion = iteracion + 1
            aux = cifrarEnigma(letra, alfInternoI, alfInternoIinv, rotorI, rotorIinv, alfInternoII, alfInternoIIinv, rotorII, rotorIIinv, alfInternoIII, alfInternoIIIinv, rotorIII, rotorIIIinv, letraClaveEntrada)
            respuesta +=  aux[0]
            alfInternoI = aux[1]
            alfInternoIinv = aux[2]
            rotorI = aux[3]
            rotorIinv = aux[4]
            alfInternoII = aux[5]
            alfInternoIIinv = aux[6]
            rotorII = aux[7]
            rotorIIinv = aux[8]
            alfInternoIII = aux[9]
            alfInternoIIIinv = aux[10]
            rotorIII = aux[11]
            rotorIIIinv = aux[12]
    print("\nTu mensaje cifrado/descifrado es:", respuesta)
    