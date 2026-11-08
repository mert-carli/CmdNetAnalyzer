Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Ana Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Wi-Fi ve Að Aracý"
$form.Size = New-Object System.Drawing.Size(500, 600)
$form.StartPosition = "CenterScreen"

# Sekme Kontrolü
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Size = $form.ClientSize
$tabs.Dock = "Fill"

# Sekmeler
$tabInfo = New-Object System.Windows.Forms.TabPage
$tabInfo.Text = "Að Bilgisi"

$tabWifi = New-Object System.Windows.Forms.TabPage
$tabWifi.Text = "Wi-Fi Araçlarý"

$tabTests = New-Object System.Windows.Forms.TabPage
$tabTests.Text = "Testler"

$tabTools = New-Object System.Windows.Forms.TabPage
$tabTools.Text = "Tarama & Dinleme"

# Fonksiyon: Buton Oluþturucu
function Add-Button($tab, $text, $y, $action) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(440, 30)
    $btn.Location = New-Object System.Drawing.Point(20, $y)
    $btn.Add_Click($action)
    $tab.Controls.Add($btn)
}

### AÐ BÝLGÝSÝ
Add-Button $tabInfo "Genel IP Adresi" 20 {
    $ip = Invoke-RestMethod https://api.ipify.org
    [System.Windows.Forms.MessageBox]::Show("Genel IP: $ip")
}

Add-Button $tabInfo "Yerel IP & MAC Adresi" 60 {
    $netInfo = Get-NetIPConfiguration | Where-Object { $_.IPv4Address -ne $null } | ForEach-Object {
        "Arayüz: $($_.InterfaceAlias)`nIPv4: $($_.IPv4Address.IPAddress)`nMAC: $($_.MacAddress)`n---"
    } | Out-String
    [System.Windows.Forms.MessageBox]::Show($netInfo, "Yerel Að Bilgileri")
}

Add-Button $tabInfo "DNS Ayarlarýný Göster" 100 {
    $dnsInfo = Get-DnsClientServerAddress | Where-Object { $_.ServerAddresses } | 
    ForEach-Object {
        "Arayüz: $($_.InterfaceAlias)`nDNS: $($_.ServerAddresses -join ', ')`n---"
    } | Out-String
    [System.Windows.Forms.MessageBox]::Show($dnsInfo, "DNS Ayarlarý")
}

Add-Button $tabInfo "Aktif Baðlantýyý Göster" 140 {
    $ssid = netsh wlan show interfaces | Select-String "SSID" | ForEach-Object {
        ($_ -split ":")[1].Trim()
    } | Select-Object -First 1
    $pass = netsh wlan show profile name="$ssid" key=clear | Select-String "Key Content" | ForEach-Object {
        ($_ -split ":")[1].Trim()
    }
    [System.Windows.Forms.MessageBox]::Show("Baðlý olunan að: $ssid`nÞifre: $pass")
}

### WIFI
Add-Button $tabWifi "Kayýtlý Wi-Fi Þifrelerini Göster" 20 {
    $output = ""
    $profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
        ($_ -split ":")[1].Trim()
    }
    foreach ($profile in $profiles) {
        $sifre = netsh wlan show profile name="$profile" key=clear | Select-String "Key Content"
        $output += "`n$profile : $($sifre -replace '.*:','' -replace '\s+$','')"
    }
    [System.Windows.Forms.MessageBox]::Show($output, "Wi-Fi Þifreleri")
}

### TESTLER
Add-Button $tabTests "Ping Testi" 20 {
    $hedef = [System.Windows.Forms.Interaction]::InputBox("Ping atýlacak site/IP:", "Ping", "google.com")
    $ping = Test-Connection -ComputerName $hedef -Count 4 | Out-String
    [System.Windows.Forms.MessageBox]::Show($ping, "Ping Sonucu")
}

Add-Button $tabTests "Traceroute (tracert)" 60 {
    $hedef = [System.Windows.Forms.Interaction]::InputBox("Traceroute yapýlacak site/IP:", "Traceroute", "google.com")
    $trace = tracert $hedef | Out-String
    [System.Windows.Forms.MessageBox]::Show($trace, "Traceroute Sonucu")
}

Add-Button $tabTests "DNS Sorgusu (nslookup)" 100 {
    $hedef = [System.Windows.Forms.Interaction]::InputBox("DNS sorgusu için site/IP:", "nslookup", "google.com")
    $dns = nslookup $hedef | Out-String
    [System.Windows.Forms.MessageBox]::Show($dns, "DNS Sorgusu")
}

### TARAMA & DÝNLENEN PORTLAR
Add-Button $tabTools "Aðdaki Cihazlarý Göster (ARP)" 20 {
    $arpList = arp -a | Out-String
    [System.Windows.Forms.MessageBox]::Show($arpList, "Aðdaki Cihazlar (ARP)")
}

Add-Button $tabTools "Dinlenen Portlarý Göster (netstat)" 60 {
    $ports = netstat -an | Select-String "LISTENING" | Out-String
    [System.Windows.Forms.MessageBox]::Show($ports.Substring(0, [Math]::Min(4000, $ports.Length)), "Dinlenen Portlar")
}

# Sekmeleri Ekle
$tabs.TabPages.AddRange(@($tabInfo, $tabWifi, $tabTests, $tabTools))
$form.Controls.Add($tabs)
$form.Topmost = $true
$form.ShowDialog()
