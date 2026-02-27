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
