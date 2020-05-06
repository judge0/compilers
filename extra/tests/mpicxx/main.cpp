#include <mpi.h>

#include <iostream>

int main()
{
    MPI_Init(NULL, NULL);

    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    std::cout << "Hello from processor with rank "
              << world_rank << " out of " << world_size << " processors.\n";

    MPI_Finalize();

    return 0;
}