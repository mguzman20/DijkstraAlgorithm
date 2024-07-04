#include <stdio.h>
#include <stdlib.h>

#include "dijsktra.h"

int main(int argc, char** argv)
{
  if(argc != 3)
  {
    printf("Modo de uso: %s input output\nDonde:\n", argv[0]);
    printf("\t\"input\" es la ruta al archivo de input\n");
    printf("\t\"output\" es la ruta al archivo de output\n");
    return 1;
  }

  // Abrimos el archivo de input
  FILE* input_stream = fopen(argv[1], "r");

  // Abrimos el archivo de output
  FILE* output_stream = fopen(argv[2], "w");

  // Si alguno de los dos archivos no se pudo abrir
  if(!input_stream)
  {
    printf("El archivo %s no existe o no se puede leer\n", argv[1]);
    return 2;
  }
  if(!output_stream)
  {
    printf("El archivo %s no se pudo crear o no se puede escribir\n", argv[2]);
    printf("Recuerda que \"fopen\" no puede crear carpetas\n");
    fclose(input_stream);
    return 3;
  }

  // [Aqui va tu tarea]
  int n_nodes;
  fscanf(input_stream, "%d", &n_nodes);

  int start_node, end_node;
  fscanf(input_stream, "%d %d", &start_node, &end_node);

  int **graph = calloc(n_nodes, sizeof(int*));
  for(int i = 0; i < n_nodes; i++)
  {
    graph[i] = calloc(n_nodes, sizeof(int));
  }

  int n_aristas;
  fscanf(input_stream, "%d", &n_aristas);

  for (int i = 0; i < n_aristas; i++)
  {
    int node1, node2, weight;
    fscanf(input_stream, "%d %d %d", &node1, &node2, &weight);
    graph[node1][node2] = weight;
  }


  int result = dijkstra(graph, start_node, end_node, n_nodes);

  fprintf(output_stream, "%d\n", result);

  for(int i = 0; i < n_nodes; i++)
  {
    free(graph[i]);
  }
  free(graph);

  // Cerrar archivo de input
  fclose(input_stream);

  // Cerrar archivo de output
  fclose(output_stream);

  return 0;
}
