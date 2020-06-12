#! -*- encoding: utf8 -*-
#!/usr/bin/env python

import pickle
import sys
import re
import time
from nltk.corpus import stopwords
from nltk.stem import SnowballStemmer

clean_re = re.compile('\W+')
def clean_text(text):
    return clean_re.sub(' ', text)

def ANDpostinglist(l1, l2):
    res = []
    x = y = 0
    while x < len(l1) and y < len(l2):
        diff = l1[x] - l2[y]
        if diff > 0:
            y += 1
        elif diff < 0:
            x += 1
        else:
            res.append(l1[x])
            x += 1
            y += 1
    return res

def ORpostinglist(l1,l2):
    res = []
    x = y = 0
    while x < len(l1) and y < len(l2):
        diff = l1[x] - l2[y]
        if diff == 0:
            res.append(l1[x])
            x += 1
            y += 1
        elif diff > 0:
            res.append(l2[y])
            y += 1
        else:
            res.append(l1[x])
            x += 1

    if x < len(l1):
        res += l1[x:]
    if y < len(l2):
        res += l2[y:]


    return res

def NANDpostinglist(l1, l2):
    res = []
    x = y = 0
    while x < len(l1) and y < len(l2):
        diff = l1[x] - l2[y]
        if diff > 0:
            y += 1
        elif diff < 0:
            res.append(l1[x])
            x += 1
        else:
            x += 1
            y += 1
    res.extend(l1[x:])
    return res

def performBinaryOP(l1, l2, Operacion):
    if Operacion == None:
        return l1
    elif Operacion == "AND":
        return ANDpostinglist(l1, l2)
    elif Operacion == "OR":
        return ORpostinglist(l1, l2)
    elif Operacion == "NAND":
         return NANDpostinglist(l1, l2)
    # elif Operacion == "NOR":
    #     return ORpostinglist([l1, NANDpostinglist(universe, l2)])
    elif Operacion == "NOT":
        return NANDpostinglist(l1, l2)

def processBinaryQuery(query):
    res = []   # Posting list
    words = [] # Words processed but not queried
    op = None  # Operation processed but not queried

    for w in query:
        if w == "NOT":
            if len(words) != 0:
                words = []
                res = performBinaryOP(res, words, op if op != None else "OR")
                op = "NAND"
            elif op == None:
                op = "NOT"
            elif op == "AND" or op == "NOT":
                op = "NAND"
            elif op == "OR":
                op = "NOR"
        elif w == "OR" or w == "AND":
            words = []
            res = performBinaryOP(res, words, op)
            op = w
        else:
            words.append(w.lower())
    return performBinaryOP(res, words, op)

def searcher(fichero):
    with open(fichero, "rb") as f:
        (indice_inv, indice_inv_pos, docsnot, docs, notid_title, notid_categoria, notid_fecha, cuerposNots) = pickle.load(f)
        f.close()
        longitudUniverso = len(docsnot)
        universo = list(range(longitudUniverso))
    while True:
        query = input("Dime: ")
        if query == "":
            break
        else:
            palabras = query.split()
            headline_bool = False
            categoria_bool = False
            fecha_bool = False
            texto_bool = False
            l1 = []
            l2 = []
            res = []
            notIdHeadline = []
            notIdCategoria = []
            notIdFecha = []
            op = None
            antNot = False
            for palabra in palabras:

                if "headline:"== palabra[:9]:
                    titulo = palabra[9:]
                    headline_bool = True
                    for key in notid_title:
                        if titulo in notid_title[key].lower():
                            notIdHeadline.append(key)
                    #print("Tu título es " + titulo + "\n")
                    continue
                elif "category:"== palabra[:9]:
                    categoria = palabra[9:].upper()
                    categoria_bool = True
                    notIdCategoria = notid_categoria[categoria]
                    #print("Tu categoria es " + categoria + "\n")
                # if "text:"== palabra[:5]:
                #     palabra = palabra[6:]
                elif "date:"== palabra[:5]:
                    fecha = palabra[5:]
                    fecha_bool = True
                    notIdFecha = notid_fecha[fecha]
                    #print("Tu fecha es " + fecha + "\n")
                else:
                    if "text:"== palabra[:5]:
                         palabra = palabra[5:]
                    if palabra in ['AND','OR','NAND','NOR','NOT']:
                        if palabra == 'NOT':
                            antNot = True
                            continue
                        op = str(palabra)
                        continue
                    if len(res)==0:
                        if antNot:
                            l2 = indice_inv[palabra]
                            res = performBinaryOP(universo, l2, 'NOT')
                        else:
                            try:
                                res = indice_inv[palabra]
                            except KeyError:
                                pass
                        continue
                    else:
                        l2 = indice_inv[palabra]
                        if antNot == True:
                            l2 = performBinaryOP(universo, l2, 'NOT')
                            antNot = False
                        res = performBinaryOP(res, l2, op)
                        continue

            if headline_bool:
                res = performBinaryOP(res, notIdHeadline, 'AND')
            if categoria_bool:
                res = performBinaryOP(res, notIdCategoria, 'AND')
            if fecha_bool:
                res = performBinaryOP(res, notIdFecha, 'AND')


            if len(res)==0:
                print("No se han encontrado resultados")
            elif len(res)<=2:
                for result in res:
                    print(notid_title[result])
                    print(cuerposNots[result])
                if len(res)==1:
                    print("Se ha encontrado " + str(len(res)) + " resultado")
                else:
                    print("Se han encontrado " + str(len(res)) + " resultados")
            elif len(res)<=5:
                for result in res:
                    print(notid_title[result])
                    snippet = ""
                    text = cuerposNots[result].lower().split()
                    for i in range(0, len(text)):
                        if text[i] in palabras:
                            snippet += "..." + " ".join(text[max(0, i - 5):min(len(text), i + 6)]) + "...\n"
                    print(snippet)
                print("Se han encontrado " + str(len(res)) + " resultados")
            elif len(res)>5:
                cont = 0
                for result in res:
                    if cont == 10:
                        break
                    else:
                        print(notid_title[result])
                        cont += 1
                print("Se han encontrado " + str(len(res)) + " resultados")




if __name__ == "__main__":
    #directorio = sys.argv[1]
    #fichero = sys.argv[2]
    fichero = "indexador"
    searcher(fichero)
