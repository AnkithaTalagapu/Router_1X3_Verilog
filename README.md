# Router_1X3_Verilog
Routing is the process of moving a packet of data from source to destination and enables messages to pass from one computer to another and eventually reach the target machine. A router is a networking device that forwards data packets between computer networks,commonly two LANs or WANs or  a LAN and  its ISP's network and  is located  at gateways, the places  where two or more networks connect. It is an OSI layer 3 routing device. It drives an incoming packet to an output channel based on the address fields contained in the packet header. 

Routers can be used in a variety of settings, including homes, businesses, and large-scale enterprise networks. They are essential components of the internet and other wide-area networks.It follows TCP/IP protocol which os a four layer protocol Application layer,Transport layer,Network layer,MAC layer also consits of Physical layer .

A device can not tranfer raw data , router tranfer data in the form of Data packet .

Format of Router Data packet as follows :

Packet format: 

The packet consists of 3 parts i.e., Header, payload and parity each of 8 bit width and the length of the payload can be extended between 3 between 3 byte to 65 byte.

--> Header: Packet header contain two fields DA and length. DA is destination address of the packet is of 2 bits. The router drives the packet to the respective ports based on this destination address of the packets. Each output port has 2-bit unique port address. If the destination address of the packet matches the port address, then router drives the packet to the output port.  The address 3(2'b11) is invalid. Payload Length of the data is of 6-bits. It specifies the number of the number of the data bytes i.e., payloads. A packet can have a minimum data size of 1 byte and a maximum size of 63 bytes. 

If length =1, it means data length is 1 byte If length =2, it means data length is 2 bytes If length =63, it means payload data length is 63 bytes 

--> Payload: payload is the data information. Data should be in terms of the bytes.Depends on the payload length the data is customized.

--> Parity: This field contains the security check of the packet. It is calculated as bitwise parity over the header and payload bytes of the packet.

In this design there are 4 sub blocks :

1) FIFO (3 blocks)
2) Synchronizer
3) FSM
4) Register

