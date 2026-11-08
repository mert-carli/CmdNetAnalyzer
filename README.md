# CmdNetAnalyzer — Windows PowerShell & WinForms Network Utility

**CmdNetAnalyzer** is a lightweight, zero-dependency Windows desktop utility built with **PowerShell** and **Windows Forms (`System.Windows.Forms`)**. It provides a tabbed graphical interface around native Windows networking commands (`ipconfig`, `netsh wlan`, `ping`, `tracert`, `nslookup`, `arp`, and `netstat`) for quick local network inspection and troubleshooting.

*(Note: This project served as an early prototype prior to the development of [SENTRIX](https://github.com/mert-carli/SENTRIX).)*

---

## Features

Organized into four diagnostic tabs:

1. **Ağ Bilgisi (Network Information):**
   - Displays local IPv4/IPv6 configuration (`ipconfig /all`)
   - Lists active network adapters and MAC addresses (`getmac`)
2. **Wi-Fi Araçları (Wi-Fi Tools):**
   - Lists saved wireless profiles (`netsh wlan show profiles`)
   - Inspects saved Wi-Fi profile security keys (`key=clear`)
   - Displays current wireless interface signal strength, channel, and BSSID (`netsh wlan show interfaces`)
3. **Testler (Connectivity Diagnostics):**
   - Interactive Ping test (`ping`)
   - Route tracing (`tracert`)
   - DNS resolution lookup (`nslookup`)
4. **Tarama & Dinleme (Discovery & Listening Ports):**
   - Local ARP cache table inspection (`arp -a`)
   - Active `LISTENING` TCP/UDP port inspection (`netstat -an`)

---

## Tech Stack & Requirements

- **Operating System:** Windows 10 / Windows 11
- **Runtime:** Windows PowerShell 5.1+ (.NET Framework `System.Windows.Forms` & `System.Drawing`)
- **External Dependencies:** None (uses built-in Windows networking utilities)

---

## Project Structure

```text
CmdNetAnalyzer/
├── agg_gui_araci.ps1       # Main PowerShell Windows Forms GUI script
├── wifi_araci.bat          # Standalone launcher script
├── LICENSE                 # MIT License
└── README.md               # Project documentation
```

---

## Usage

1. **Clone the repository:**
   ```powershell
   git clone https://github.com/mert-carli/CmdNetAnalyzer.git
   cd CmdNetAnalyzer
   ```

2. **Launch the GUI:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\agg_gui_araci.ps1
   ```

---

## License

This project is licensed under the [MIT License](./LICENSE).

## Author

**Mevlana Mert Çarlı**  
- GitHub: [@mert-carli](https://github.com/mert-carli)  
- Portfolio: [mert-carli-cvu9.vercel.app](https://mert-carli-cvu9.vercel.app)
