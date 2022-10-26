import random

def exercícios(matrícula, quantidade_de_listas=4, quantidade_exercicios=4):
    
    random.seed(matrícula)
    
    listas = [4, 5, 6, 7, 9, 12]
    
    exercicios_lista4 = [12, 13, 14]

    exercicios_lista5 = [11, 13, 14, 15, 16]
    
    exercicios_lista6 = [6, 7, 9, 10]
    
    exercicios_lista7 = [4, 5, 6]
    
    exercicios_lista9 = [5, 7, 8]
    
    exercicios_lista12 = [17, 18, 19, 21, 22, 24]
    
    exercicios = [exercicios_lista4, exercicios_lista5, exercicios_lista6, exercicios_lista7, exercicios_lista9, exercicios_lista12]

    listas_selecionadas = random.sample(listas, len(listas))[0:quantidade_de_listas]
    
    listas_selecionadas.sort()
        
    for lista in listas_selecionadas:
        idx = listas.index(lista)
        exercicio = random.sample(exercicios[idx], len(exercicios[idx]))[0]
        print('Da lista %d, você deve resolver o seguinte exercício: %d' % (lista, exercicio))
