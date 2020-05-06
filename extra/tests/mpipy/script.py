from mpi4py import MPI

comm = MPI.COMM_WORLD
world_size = comm.Get_size()
world_rank = comm.Get_rank()

print(f"Hello from processor with rank {world_rank} out of {world_size} processors")