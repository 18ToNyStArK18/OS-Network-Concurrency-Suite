# C-Shark: Terminal Packet Sniffer

**C-Shark** is a raw socket network analyzer designed to capture, dissect, and display network traffic directly in the terminal. It mimics core Wireshark functionalities using `libpcap`.

## 📂 Project Structure

```text
Terminal-Packet-Sniffer/
├── main.c        # Entry point, Interface selection, & Thread management
├── func.c        # Protocol decoding (L2, L3, L4, L7) & Hex dump logic
├── func.h        # Function prototypes and structs
├── cshark        # Compiled executable
└── Makefile      # Build configuration
```

## 🦈 Features

- **Interface Discovery**: Auto-detects available network interfaces (e.g., wlan0, eth0, lo).
- **Layer 2 (Data Link)**: Decodes Ethernet Headers (MAC addresses, EtherType).
- **Layer 3 (Network)**: Decodes IPv4, IPv6, and ARP headers.
- **Layer 4 (Transport)**: Decodes TCP (Ports, Flags, Seq/Ack) and UDP.
- **Layer 7 (Application)**: Identifies HTTP, HTTPS, DNS, and provides a Hex + ASCII Dump of the payload.
- **Filtering**: Filters traffic based on protocol (HTTP, TCP, UDP, etc.).

## 🔨 Build & Usage

### 1. Dependencies:
```bash
sudo apt install libpcap-dev
```

### 2. Compile:
```bash
make
```

### 3. Run (Requires Root):
```bash
sudo ./cshark
```

### 4. Controls:
- **Ctrl+C**: Stop capture and return to menu.
- **Ctrl+Z**: Exit application.
