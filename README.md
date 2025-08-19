# FIFO


# Synchronous FIFO
First In First Out (FIFO) is a very popular and useful design block for purpose of synchronization and a handshaking mechanism between the modules.

Depth of FIFO: The number of slots or rows in FIFO is called the depth of the FIFO.

Width of FIFO: The number of bits that can be stored in each slot or row is called the width of the FIFO.

There are two types of FIFOs

1. Synchronous FIFO
2. Asynchronous FIFO

# Synchronous FIFO
<img width="749" height="354" alt="image" src="https://github.com/user-attachments/assets/02695ce2-efa9-4181-9cbb-4b0c2267d032" />

# 8 Bit FIFO Basic Structure
<img width="1037" height="521" alt="image" src="https://github.com/user-attachments/assets/73fe98c9-15fb-45c7-ac74-8f2ec194c221" />


<img width="469" height="264" alt="image" src="https://github.com/user-attachments/assets/1bca0c57-0a5d-40c3-8b65-9bc62a308c4d" />


In Synchronous FIFO, data read and write operations use the same clock frequency. Usually, they are used with high clock frequency to support high-speed systems.
Synchronous FIFO Operation
Signals:

wr_en: write enable
wr_data: write data
full: FIFO is full
empty: FIFO is empty
rd_en: read enable
rd_data: read data
w_ptr: write pointer
r_ptr: read pointer
# FIFO write operation
FIFO can store/write the wr_data at every posedge of the clock based on wr_en signal till it is full. The write pointer gets incremented on every data write in FIFO memory.

# FIFO read operation
The data can be taken out or read from FIFO at every posedge of the clock based on the rd_en signal till it is empty. The read pointer gets incremented on every data read from FIFO memory.

# Synchronous FIFO Verilog Code
A synchronous FIFO can be implemented in various ways. Full and empty conditions differ based on implementation.

# Method 1
In this method, the width of the write and read pointer = log2(depth of FIFO). The FIFO full and empty conditions can be determined as

Empty condition
w_ptr == r_ptr i.e. write and read pointers has the same value.

Full condition
The full condition means every slot in the FIFO is occupied, but then w_ptr and r_ptr will again have the same value. Thus, it is not possible to determine whether it is a full or empty condition. Thus, the last slot of FIFO is intentionally kept empty, and the full condition can be written as (w_ptr+1’b1) == r_ptr)

# Method 2
In order to avoid an empty slot as mentioned in method 1, the width of write and read pointers is increased by 1 bit. This extra bit helps determine empty and full conditions when FIFO is empty (w_ptr == r_ptr when all slots are empty) and FIFO is full (w_ptr == r_ptr when all slots are full).

Empty condition
w_ptr == r_ptr i.e. write and read pointers has the same value. MSB of w_ptr and r_ptr also has the same value.

Full condition
w_ptr == r_ptr i.e. write and read pointers has the same value, but the MSB of w_ptr and r_ptr differs.

# Method 3
The synchronous FIFO can also be implemented using a common counter that can be incremented or decremented based on write to the FIFO or read from the FIFO respectively.

Empty condition
count == 0 i.e. FIFO contains nothing.

Full condition
count == FIFO_DEPTH i.e. counter value has reached till the depth of FIFO


# Asynchronous FIFO
In asynchronous FIFO, data read and write operations use different clock frequencies. Since write and read clocks are not synchronized, it is referred to as asynchronous FIFO. Usually, these are used in systems where data need to pass from one clock domain to another which is generally termed as ‘clock domain crossing’. Thus, asynchronous FIFO helps to synchronize data flow between two systems working on different clocks.
<img width="782" height="342" alt="image" src="https://github.com/user-attachments/assets/341a2112-69fe-4e4d-a8a5-44e328101331" />

# 8 Bit FIFO Basic Structure
<img width="1274" height="578" alt="image" src="https://github.com/user-attachments/assets/821b51f2-1b78-4109-b74e-a027566a7b55" />



<img width="1113" height="728" alt="image" src="https://github.com/user-attachments/assets/f682c6e0-a4db-4c04-85fd-6ab8765f12db" />

# Signals:

wr_en: write enable

wr_data: write data

full: FIFO is full

empty: FIFO is empty

rd_en: read enable

rd_data: read data

b_wptr: binary write pointer

g_wptr: gray write pointer

b_wptr_next: binary write pointer next

g_wptr_next: gray write pointer next

b_rptr: binary read pointer

g_rptr: gray read pointer

b_rptr_next: binary read pointer next

g_rptr_next: gray read pointer next

b_rptr_sync: binary read pointer synchronized

b_wptr_sync: binary write pointer synchronized

# Asynchronous FIFO Operation
In the case of synchronous FIFO, the write and read pointers are generated on the same clock. However, in the case of asynchronous FIFO write pointer is aligned to the write clock domain whereas the read pointer is aligned to the read clock domain. Hence, it requires domain crossing to calculate FIFO full and empty conditions. This causes metastability in the actual design. In order to resolve this metastability, 2 flip flops or 3 flip flops synchronizer can be used to pass write and read pointers. For explanation, we will go with 2 flip-flop synchronizers. Please note that a single “2 FF synchronizer” can resolve metastability for only one bit. Hence, depending on write and read pointers multiple 2FF synchronizers are required.
<img width="677" height="459" alt="image" src="https://github.com/user-attachments/assets/d5e937f0-db19-48f2-9ff2-e880b62c41d5" />

Till now, we discussed how to get asynchronous write and read pointers in respective clock domains. However, we should not pass binary formatted write and read pointer values. Due to metastability, the overall write or read pointer value might be different.

Example: When binary value wr_ptr = 4’b1101 at the write clock domain is transferred via 2FF synchronizer, at the read clock domain wr_ptr value may receive as 4’b1111 or any other value that is not acceptable. Whereas gray code is assured to have only a single bit change from its previous value. Hence, both write and read pointers need to convert first to their equivalent gray code in their corresponding domain and then pass them to an opposite domain. To check FIFO full and empty conditions in another domain, we have two ways.




