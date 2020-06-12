#!/usr/bin/env python

import re
import os
import sys
from os import walk
import pickle
from nltk.stem import SnowballStemmer
import time
import xml.etree.ElementTree as ET

clean_re = re.compile('\W+')
def clean_text(text):
    return clean_re.sub(' ', text)

def indexer(directorio, fichero):
    docs = {}
    indice_inv = {}
    notid_title = {}
    notid_fecha = {}
    notid_categoria = {}
    cuerposNots = {}
    docid = 0
    docsnot = {}
    notid = 0
    for f in os.scandir(directorio): #Procesamos los documentos
        ruta = directorio+"/" + f.name
        contenido = open(ruta, encoding="utf8") #Guardamos en una variable el contenido de los ficheros de la ruta
        cont = contenido.read()
        docs[docid] = ruta
        # contenido.close()
        # noticia = ET.fromstring("<DOC>" + cont + "</DOC>")
        # print(noticia)
        # print("------------------------------------------------------")
        noticias = re.split("<DOC>", cont)
        simbolos_separacion = [" ","\n"]
        palabras = {}
        pos_not_in_doc = 0
        for noticia in noticias[1:]:
            empiezaTitulo = noticia.find("<TITLE>")
            terminaTitulo = noticia.find("</TITLE>")
            empiezaFecha = noticia.find("<DATE>")
            terminaFecha = noticia.find("</DATE>")
            empiezaCategoria = noticia.find("<CATEGORY>")
            terminaCategoria = noticia.find("</CATEGORY>")
            empiezaTexto = noticia.find("<TEXT>")
            terminaTexto = noticia.find("</TEXT>")
            titulo = noticia[empiezaTitulo + 8:terminaTitulo]
            notid_title[notid] = titulo
            categoria = noticia[empiezaCategoria + 10:terminaCategoria]
            lista = notid_categoria.get(categoria, [])
            if notid not in lista:
                lista.append(notid)
            notid_categoria[categoria] = lista
            fecha = noticia[empiezaFecha + 6:terminaFecha]
            lista = notid_fecha.get(fecha, [])
            if notid not in lista:
                lista.append(notid)
            notid_fecha[fecha] = lista
            cuerpoNoticia = noticia[empiezaTexto + 7:terminaTexto]
            texto = cuerpoNoticia
            cuerposNots[notid] = texto
            texto = clean_text(texto) #Quitamos los símbolos no alfanuméricos
            texto = texto.lower() #Convertimos a minúsculas
            docsnot[notid] = (docid, pos_not_in_doc)

            print(texto)
            for palabra in texto.split(" ")[1:]:
                if palabra in simbolos_separacion:
                    continue
                palabras[palabra] = palabras.get(palabra, 0) + 1
                lista = indice_inv.get(palabra,[])
                if notid not in lista:
                    lista.append(notid)
                indice_inv[palabra] = lista
            pos_not_in_doc += 1
            notid += 1
        docid += 1
    print(len(docsnot))
    print(noticias[0])
    obj = (indice_inv, docsnot, docs, notid_title, notid_categoria,notid_fecha, cuerposNots)
    with open(fichero, "wb") as f:
        pickle.dump(obj, f)

if __name__ == "__main__":
    #if len(sys.argv) != 3:
        #print("Datos mal introducidos. Introduce directorio y nombre de fichero")

    #directorio = sys.argv[1]
    #fichero = sys.argv[2]
    directorio = "../mini_enero2"
    fichero = "indexador"
    indexer(directorio, fichero)

