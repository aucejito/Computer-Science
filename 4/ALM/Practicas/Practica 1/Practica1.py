def ejercicio2(a):
    long = [None]*len(a)
    for i in range(0,len(a)):
        actual = a[i]
        maxim = 0
        for j in range(0,i):
          if a[j]<actual:
              maxim=max(maxim,long[j])
        long[i]=maxim+1
    return long

def ejercicio3(a):
    long = ejercicio2(a)
    res = max(long)
    return res

def ejercicio4(a):
    long = [None]*len(a) #Lista las longitudes de mayor subsecuencia creciente en cada posicion
    B = [None]*len(a) #Lista con los backpointers
    for i in range(0,len(a)): #recorremos toda la lista de entrada
        actual = a[i] #nos quedamos con el valor actual
        maxim = 0 #para guardarnos la maxima longitud
        vengode=None #para apuntarnos de donde venimos
        for j in range(0,i): #recorremos la subsecuencia desde el primero hasta el actual
          if a[j]<actual and maxim<long[j]: #si encontramos un nodo anterior con valor menor que el actual y el maximo que tenemos hasta el momento es menor que la longitud maxima en ese nodo anterior
              maxim=long[j] #actualizamos el maximo
              vengode=j #nos quedamos con la posicion de ese elemento anterior

        long[i]=maxim+1 #actualizamos la lista longitud al valor del maximo + 1
        B[i]=vengode #Escribimos la lista de backpointers de donde venimos

    (_, posmax) = max((long[i], i) for i in range(len(long))) #nos quedamos con la posicion de la subsecuencia creciente de mayor longitud
    vengoDe = B[posmax] #nos quedamos con la posicion del elemento del que venimos

    lista = [] #Lista donde vamos a poner la subsecuencia creciente
    lista.append(a[posmax]) #añadimos el el valor del ultimo elemento visitado
    while vengoDe != None:
        lista.insert(0, a[vengoDe]) #Añadimos el valor del elemento anterior del que venimos
        vengoDe = B[vengoDe] #actualizamos el elemento del que venimos

    return lista

def opcional(a):
    long = ejercicio2(a)
    menores = []
    for i in range(0,len(a)):
        actual=a[i]
        if len(menores)==0:
            menores.append(actual)
        else:
            if actual > menores[-1]:
                menores.append(actual)
            else:
                if len(menores)==1:
                    menores[0]=actual
                else:
                    cont=len(menores)-1
                    while(actual < menores[cont]):
                        cont=cont-1
                        if cont<0:
                            break
                    menores[cont+1]=actual
    return menores

if __name__ == "__main__":
    a = [210, 816, 357, 107, 889, 635, 733, 930, 842, 542]
    #a = [10, 3, 5, 12, 7, 20, 18]
    print(ejercicio2(a))
