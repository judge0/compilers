#include <mpi.h>

#include <stdio.h>

int main()
{
    MPI_Init(NULL, NULL);

    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    printf("Hello from processor with rank %d out of %d processors.\n", world_rank, world_size);

    MPI_Finalize();

    return 0;
}