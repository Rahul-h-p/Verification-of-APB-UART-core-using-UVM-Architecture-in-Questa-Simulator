# Verification-of-APB-UART-core-using-UVM-Architecture-in-Questa-Simulator
UVM-based functional verification of an APB-based UART Master Core RTL. Includes multi-agent environment, assertions, coverage collection, and multiple test scenarios (full/half duplex, parity, framing, timeout errors) achieving above 90% functional coverage and protocol compliance.
<h1>Advanced Pheripheral Bus</h1>
<p>The Advanced Peripheral Bus (APB) is a protocol from the Advanced Microcontroller Bus Architecture (AMBA) family, primarily used for low-bandwidth peripherals. APB is designed to offer low-cost and efficient  communication, with a focus on minimizing power consumption and simplifying the interface.<br>
Unlike other bus protocols like AHB (Advanced High-performance Bus), APB operates as a non-pipelined protocol. It connects low-bandwidth peripherals to a system-on-chip (SoC) and typically requires at least two clock cycles (SETUP Cycle and ACCESS Cycle) to complete a transfer. APB can also interface with AHB and AXI protocols via bridge components.</p>
<h2>Table of contents</h2>
<p>
1. APB in a System-on-Chip (SoC)<br>
2. Key Components and Signal Description<br>
3. Understanding APB Write and Read Transfers<br>
4. Error Handling in APB Protocol<br>
5. Protection Unit Support in APB Protocol<br>
6. Operating States of APB Protocol<br>
7. Conclusion: Key Takeaways About the APB Protocol</p>
<h3>APB in a System-on-Chip (SoC)</h3>
<p>The APB_soc  diagram below illustrates how APB fits into a typical system architecture. The central component of this system is the high-performance ARM  processor. Other high-bandwidth components, like RAM and DMA controllers, are connected to the ARM core via the AHB system bus. Low-bandwidth peripherals like UART, timers, keypads, and PIOs are connected through a bridge to the APB bus.</p>
<img width="500" height="350" alt="image" src="https://github.com/user-attachments/assets/cff7675f-28cc-4e57-b25b-045bc1e5d0e1" />
<p>In this setup, the AHB to APB bridge acts as the APB master, controlling the transfer of data to low-bandwidth peripherals. This configuration ensures the system maintains high performance while managing simpler peripheral devices.</p>
<h3>Key Components and Signal Description</h3>
<p>Below is a detailed explanation of the main signals in the APB protocol, as shown in the block diagram:</p>
<img width="500" height="350" alt="{17E04741-8911-45D6-99C0-A8B6EA8BA4F2}" src="https://github.com/user-attachments/assets/617f26a4-5b1b-417c-97ac-b9d386624cb0" />
<h3>Understanding APB Write and Read Transfers</h3>
<h4>Write Transfer Without Wait States</h4>
<p>In a typical APB write transfer without wait states, the process unfolds as follows:</p>
<img width="500" height="350" alt="{FED27CC1-B335-4AFE-9BAE-12FA5FA8E2BA}" src="https://github.com/user-attachments/assets/08040ed0-bd35-42fd-88a3-cb7ccedee667" />
<P>
  1. Setup Phase (T1): The master provides the address (PADDR), write data (PWDATA), and control signals.<br>
2. Access Phase (T2): After the next rising edge of PCLK, the slave acknowledges the start of the access phase with the PENABLE signal.<br>
3. The master ensures that all signals remain stable until the transfer completes at T3.</P>
<h4>Write Transfer With Wait States</h4>
<img width="500" height="350" alt="{F5CA3EFE-A9BF-46C0-8C2C-81929483455F}" src="https://github.com/user-attachments/assets/db06dbd4-374c-41a6-9728-623ad7f3a12d" />
<p>When the slave needs more time, it can assert PREADY low, indicating it isn’t ready to complete the transaction. The master must hold the signals stable while PREADY is low. Once PREADY goes high, the transfer proceeds to completion.</p>
<h4>Read Transfer Without Wait States</h4>
<p>In a typical APB read transfer, the following steps occur:</p>
<img width="500" height="350" alt="{969B493C-C39E-4E96-90D2-FC7FDF35F3E5}" src="https://github.com/user-attachments/assets/d651a617-2c1f-4162-857a-f6b48af3a45e" />
<p>1.Setup Phase (T1): The master initiates the read request with PADDR and control signals.<br>
2.Access Phase (T2): The slave begins the read transfer by providing the requested data (PRDATA).<br>
3.The data must be ready before the end of the transfer (T3).</p>
<h4>Read Transfer With Wait States</h4>
<img width="500" height="350" alt="{1EE375DB-F21A-49BD-B54E-10996A551245}" src="https://github.com/user-attachments/assets/b27b6406-1eaa-4812-91e8-eb173f9603d1" />
<p>When the slave can’t provide the data immediately, it drives PREADY low during the access phase, extending the transfer until it’s ready to send the data. The master should hold all signals stable during this period.</p>
<h4>Error Handling in APB Protocol</h4>
<p>Error Response for a read transfer:</p>
<img width="528" height="253" alt="{F197E5AD-786D-41E8-BDB8-9459900BBF17}" src="https://github.com/user-attachments/assets/c51daa9e-d2c7-41c6-ae3b-54026fda2252" />
<p>Error Response for a write transfer:</p>
<img width="494" height="268" alt="{2B1A341A-041A-40E3-A2B0-0776B1AF86C4}" src="https://github.com/user-attachments/assets/a52962ca-845b-40a0-879a-1dfc9bb08e68" />
<p>In case of errors during a transaction, the PSLVERR signal is used. This signal indicates an error response when the transfer is complete (during the last cycle). If an error occurs, it is not guaranteed that the data was successfully written or read. For example, if a write transaction encounters an error, the data may not be written to the slave device.</p>
<img width="300" height="100" alt="{7E9B446B-722F-4927-B2CF-FF2C5B41540D}" src="https://github.com/user-attachments/assets/967d135e-a98f-4c9c-b4c9-310010ae829c" />
<h4>Protection Unit Support in APB Protocol</h4>
<p>To enhance system security, APB includes protection mechanisms. These are governed by the PPROT signals, which provide three levels of access control:</p>
<img width="714" height="174" alt="{E6DC0887-0917-48E2-AF89-899A357942A5}" src="https://github.com/user-attachments/assets/dcfc4a21-daf3-4b16-9d40-94a0123c2abb" />
<p>These signals help prevent illegal transactions within the system.</p>
<h4>Operating States of APB Protocol</h4>
<p>The APB Protocol operates in three primary states:</p>
<img width="336" height="307" alt="{52236659-4072-442C-88AD-86A6DF73BCFC}" src="https://github.com/user-attachments/assets/93be49af-08b9-4610-85a0-009c45a2917c" />
<p>1. IDLE State: This is the default state where the bus is inactive.<br>
2. SETUP State: When a transfer is requested, the bus enters the SETUP state. This lasts for just one clock cycle.<br>
3. ACCESS State: The bus enters the ACCESS state once PENABLE is asserted. During this state, the address, write, and data signals must remain stable.</p>
<img width="574" height="133" alt="{3E9424EC-B287-41FB-9DFC-EE2E1F5B648D}" src="https://github.com/user-attachments/assets/21632897-7963-41a5-87e5-b49ab0e9eee0" />
<h4>Key Takeaways About the APB Protocol</h4>
<p>The APB Protocol offers a simple and efficient solution for connecting low-bandwidth peripherals in a system. By using low power and reducing complexity, it serves as an essential component in modern SoCs. The protocol’s operation, including its write and read transfer procedures, error handling, and protection mechanisms, ensures reliable and secure  communication within a system.
<br>
By implementing a bridge between AHB and APB, APB seamlessly integrates with high-performance buses, making it a versatile and indispensable protocol in embedded system design.</p>
