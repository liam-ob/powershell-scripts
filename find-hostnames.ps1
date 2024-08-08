# Define the subnet to scan
$subnet = "10.11.11"

# Create an empty array to store results
$results = @()

# Function to update the displayed IP address
function Update-IPDisplay {
    param($ip)
    Write-Host "`rScanning IP: $ip     " -NoNewline
}

# Loop through all possible IP addresses in the /24 subnet
try {
    1..254 | ForEach-Object {
        $ip = "$subnet.$_"
        
        Update-IPDisplay $ip
        
        # Use Test-Connection to check if the IP is responsive
        if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
            try {
                # Attempt to resolve hostname
                $hostname = [System.Net.Dns]::GetHostEntry($ip).HostName
            }
            catch {
                # If hostname resolution fails, set hostname to "N/A"
                $hostname = "N/A"
            }
            
            # Add the result to our array
            $results += [PSCustomObject]@{
                IPAddress = $ip
                Hostname = $hostname
            }
        }
    }
} finally {
    Write-Host " "
    Write-Host "Ended early:"
    $results | Format-Table -AutoSize
}

# Display the results
$results | Format-Table -AutoSize