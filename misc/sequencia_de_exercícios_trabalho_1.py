import random

def exercícios(matrícula, quantidade=4):
    
    random.seed(matrícula)
    
    exercicios_lista2 = [1,7,13,14,16,17,18]

    exercicios_lista3 = [2,3,5,6,7,8,17,18,19]

    lista2 = random.sample(exercicios_lista2, len(exercicios_lista2))

    lista3 = random.sample(exercicios_lista3, len(exercicios_lista3))
    
    print('Da lista 2, você deve resolver os seguintes exercícios:', lista2[0:quantidade])
    print('Da lista 3, você deve resolver os seguintes exercícios:', lista3[0:quantidade])
    
